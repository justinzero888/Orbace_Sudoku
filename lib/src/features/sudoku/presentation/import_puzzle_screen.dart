import 'package:flutter/material.dart';

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
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
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

  @override
  void dispose() {
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            Text(
              'Imported puzzles are personal, local-only, and not eligible for worldwide ranking.',
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
              height: 390,
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
              onPressed: _saving ? null : _validate,
              icon: const Icon(Icons.fact_check_outlined),
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

  void _validate() {
    setState(() {
      _error = null;
      _preview = null;
    });

    try {
      final preview = _tabController.index == 0
          ? _service.previewFromString(
              _pasteController.text,
              title: _titleController.text,
              sourceLabel: _sourceController.text,
            )
          : _service.previewFromCells(
              _manualCells(),
              title: _titleController.text,
              sourceLabel: _sourceController.text,
            );
      setState(() => _preview = preview);
    } on ImportedPuzzleException catch (error) {
      setState(() => _error = error.message);
    } on Object catch (error) {
      setState(() => _error = 'Could not import this puzzle: $error');
    }
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 12,
      maxLines: 14,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: '81-cell puzzle string',
        hintText: '530070000600195000098000060...',
        helperText: 'Use 1-9 for givens; 0, dot, or dash for blanks.',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _ManualGridPane extends StatelessWidget {
  const _ManualGridPane({required this.controllers});

  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
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
          return DecoratedBox(
            decoration: BoxDecoration(
              color: OrbaceTheme.paper,
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
            child: TextField(
              controller: controllers[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          );
        },
      ),
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
