import 'package:flutter/material.dart';

import '../../../app/ad_mob_bottom_banner.dart';
import '../../../app/orbace_theme.dart';
import '../data/imported_puzzle_service.dart';
import '../data/puzzle_pack_loader.dart';
import '../data/sudoku_repository.dart';
import '../domain/sudoku_board.dart';
import 'sudoku_game_screen.dart';

class ImportPuzzleScreen extends StatefulWidget {
  const ImportPuzzleScreen({super.key, required this.repository});

  final SudokuRepository repository;

  @override
  State<ImportPuzzleScreen> createState() => _ImportPuzzleScreenState();
}

class _ImportPuzzleScreenState extends State<ImportPuzzleScreen>
    with SingleTickerProviderStateMixin {
  static const double _pasteTabHeight = 380;
  static const double _gridTabHeight = 560;

  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  )..addListener(_onTabChanged);
  late final ImportedPuzzleService _service = ImportedPuzzleService(
    repository: widget.repository,
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _pasteController = TextEditingController();
  final List<TextEditingController> _cellControllers =
      List<TextEditingController>.generate(
        SudokuBoard.cellCount,
        (_) => TextEditingController(),
      );
  ImportedPuzzlePreview? _preview;
  String? _error;
  bool _saving = false;
  bool _validating = false;

  void _onTabChanged() {
    // TabController fires this listener during the drag/settle animation
    // too, not just on a completed switch -- only rebuild once it settles
    // on a new tab so the pane height doesn't jitter mid-swipe.
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _titleController.dispose();
    _sourceController.dispose();
    _pasteController.dispose();
    for (final controller in _cellControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Puzzle'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Paste'),
            Tab(text: 'Grid'),
          ],
        ),
      ),
      bottomNavigationBar: const AdMobBottomBanner(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            Text(
              'Imported puzzles are personal and stored locally on this device only.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Imported challenge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source note',
                hintText: 'Optional, for your own reference',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: _tabController.index == 0
                  ? _pasteTabHeight
                  : _gridTabHeight,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PasteImportPane(controller: _pasteController),
                  _ManualGridPane(controllers: _cellControllers),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saving || _validating ? null : _validate,
              icon: _validating
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.fact_check_outlined),
              label: const Text('Validate Puzzle'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (_preview case final preview?) ...[
              const SizedBox(height: 14),
              _PreviewCard(
                preview: preview,
                saving: _saving,
                onSaveAndPlay: _saveAndPlay,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _validate() async {
    setState(() {
      _error = null;
      _preview = null;
      _validating = true;
    });

    try {
      final preview = _tabController.index == 0
          ? await _service.previewFromString(
              _pasteController.text,
              title: _titleController.text,
              sourceLabel: _sourceController.text,
            )
          : await _service.previewFromCells(
              _manualCells(),
              title: _titleController.text,
              sourceLabel: _sourceController.text,
            );
      if (!mounted) {
        return;
      }
      setState(() => _preview = preview);
      _showSavePrompt(preview);
    } on ImportedPuzzleException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.message);
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = 'Could not import this puzzle: $error');
    } finally {
      if (mounted) {
        setState(() => _validating = false);
      }
    }
  }

  /// Surfaces the "Save & Play" CTA immediately as a bottom sheet instead of
  /// leaving the user to scroll down and find it -- see UAT feedback that it
  /// wasn't obvious the puzzle had validated successfully.
  Future<void> _showSavePrompt(ImportedPuzzlePreview preview) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: _PreviewCard(
            preview: preview,
            saving: false,
            onSaveAndPlay: () {
              Navigator.of(sheetContext).pop();
              _saveAndPlay();
            },
          ),
        );
      },
    );
  }

  List<int?> _manualCells() {
    return [
      for (final controller in _cellControllers)
        switch (controller.text.trim()) {
          '' || '0' || '.' || '-' => null,
          final value when RegExp(r'^[1-9]$').hasMatch(value) => int.parse(
            value,
          ),
          _ => throw const ImportedPuzzleException(
            'Grid cells can only contain digits 1-9 or blanks.',
          ),
        },
    ];
  }

  Future<void> _saveAndPlay() async {
    final preview = _preview;
    if (preview == null) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _service.save(preview);
      final catalog = await PuzzlePackLoader(
        repository: widget.repository,
      ).load();
      final puzzle = catalog.byId(preview.id);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => SudokuGameScreen(
            repository: widget.repository,
            puzzle: puzzle,
            catalog: catalog,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _PasteImportPane extends StatelessWidget {
  const _PasteImportPane({required this.controller});

  final TextEditingController controller;
  static const String example =
      '530070000600195000098000060800060003400803001700020006060000280000419005000080079';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          minLines: 10,
          maxLines: 12,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: '81-cell puzzle string',
            hintText: example,
            helperText: 'Use 1-9 for givens; 0, dot, or dash for blanks.',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => controller.text = example,
          icon: const Icon(Icons.content_paste),
          label: const Text('Use Example String'),
        ),
      ],
    );
  }
}

class _ManualGridPane extends StatefulWidget {
  const _ManualGridPane({required this.controllers});

  final List<TextEditingController> controllers;

  @override
  State<_ManualGridPane> createState() => _ManualGridPaneState();
}

class _ManualGridPaneState extends State<_ManualGridPane> {
  int _selectedIndex = 0;

  int get _filledCount => widget.controllers
      .where((controller) => controller.text.isNotEmpty)
      .length;

  void _selectCell(int index) {
    setState(() => _selectedIndex = index);
  }

  void _setSelectedValue(int? value) {
    setState(() {
      widget.controllers[_selectedIndex].text = value?.toString() ?? '';
      if (value != null && _selectedIndex < SudokuBoard.cellCount - 1) {
        _selectedIndex += 1;
      }
    });
  }

  void _clearGrid() {
    setState(() {
      for (final controller in widget.controllers) {
        controller.clear();
      }
      _selectedIndex = 0;
    });
  }

  TextStyle? _cellTextStyle(BuildContext context, double boardWidth) {
    final cellSize = boardWidth / 9;
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: OrbaceTheme.vermilion,
      fontSize: cellSize * 0.62,
      fontWeight: FontWeight.w800,
      height: 1,
    );
  }

  Widget _buildKeyButton({
    required BuildContext context,
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 42,
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: OrbaceTheme.ink,
          side: BorderSide(color: OrbaceTheme.ink.withValues(alpha: 0.28)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildNumberPad(BuildContext context) {
    final numberStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: OrbaceTheme.ink,
    );
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var number = 1; number <= 9; number += 1)
          _buildKeyButton(
            context: context,
            onPressed: () => _setSelectedValue(number),
            child: Text('$number', style: numberStyle),
          ),
        _buildKeyButton(
          context: context,
          onPressed: () => _setSelectedValue(null),
          child: const Icon(Icons.backspace_outlined, size: 20),
        ),
        _buildKeyButton(
          context: context,
          onPressed: _clearGrid,
          child: const Icon(Icons.clear_all, size: 22),
        ),
      ],
    );
  }

  Widget _buildBoard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth;
        final cellStyle = _cellTextStyle(context, boardWidth);
        return AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
            ),
            itemCount: SudokuBoard.cellCount,
            itemBuilder: (context, index) {
              final row = SudokuBoard.rowOf(index);
              final col = SudokuBoard.colOf(index);
              final selected = index == _selectedIndex;
              final value = widget.controllers[index].text;
              return Material(
                color: selected
                    ? OrbaceTheme.vermilion.withValues(alpha: 0.16)
                    : OrbaceTheme.paper,
                child: InkWell(
                  onTap: () => _selectCell(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: row % 3 == 0 ? 1.8 : 0.5,
                        ),
                        left: BorderSide(
                          color: Colors.black,
                          width: col % 3 == 0 ? 1.8 : 0.5,
                        ),
                        right: BorderSide(
                          color: Colors.black,
                          width: col == 8 ? 1.8 : 0.5,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                          width: row == 8 ? 1.8 : 0.5,
                        ),
                      ),
                    ),
                    child: Center(child: Text(value, style: cellStyle)),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tap a cell, then choose 1-9. Leave blank cells empty.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: _buildBoard(context),
          ),
        ),
        const SizedBox(height: 14),
        _buildNumberPad(context),
        const SizedBox(height: 10),
        Text(
          '$_filledCount givens entered. 17 or more are required before validation.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: OrbaceTheme.ink),
        ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.preview,
    required this.saving,
    required this.onSaveAndPlay,
  });

  final ImportedPuzzlePreview preview;
  final bool saving;
  final VoidCallback onSaveAndPlay;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(preview.title, style: textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              '${preview.difficulty.label} · ${preview.givens.cells.where((value) => value != null).length} givens',
            ),
            const SizedBox(height: 6),
            Text(
              preview.humanSolvable
                  ? 'Known techniques: ${preview.requiredTechniques.join(', ')}'
                  : 'Unique solution found. Advanced techniques may be required.',
              style: textTheme.bodyMedium?.copyWith(color: OrbaceTheme.ink),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: saving ? null : onSaveAndPlay,
              icon: saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: const Text('Save & Play'),
            ),
          ],
        ),
      ),
    );
  }
}
