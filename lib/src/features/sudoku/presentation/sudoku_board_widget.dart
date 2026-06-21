import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../domain/sudoku_board.dart';
import 'game_session_controller.dart';

class SudokuBoardWidget extends StatelessWidget {
  const SudokuBoardWidget({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: OrbaceTheme.ink,
              border: Border.all(color: OrbaceTheme.ink, width: 4),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: SudokuBoard.cellCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: SudokuBoard.size,
              ),
              itemBuilder: (context, index) {
                return _SudokuCell(controller: controller, index: index);
              },
            ),
          ),
        );
      },
    );
  }
}

class _SudokuCell extends StatelessWidget {
  const _SudokuCell({required this.controller, required this.index});

  static const double _valueFontScale = 0.75;
  static const double _noteFontScale = 0.26;
  static const double _notePaddingScale = 0.08;

  final GameSessionController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final value = controller.valueAt(index);
    final selected = controller.selectedIndex == index;
    final related = controller.isRelatedToSelection(index);
    final sameValue = controller.hasSameValueAsSelection(index);
    final isHintTarget = controller.hintTargetIndex == index;
    final isGiven = controller.isGiven(index);
    final incorrect = controller.isIncorrect(index);

    final row = SudokuBoard.rowOf(index);
    final col = SudokuBoard.colOf(index);
    final rightBorder = col == 2 || col == 5 ? 2.5 : 0.7;
    final bottomBorder = row == 2 || row == 5 ? 2.5 : 0.7;

    return Semantics(
      button: true,
      selected: selected,
      label: _semanticLabel(row, col, value, isGiven),
      child: GestureDetector(
        onTap: () => controller.selectCell(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _cellColor(
              selected: selected,
              related: related,
              sameValue: sameValue,
              isHintTarget: isHintTarget,
              incorrect: incorrect,
            ),
            border: Border(
              right: BorderSide(color: OrbaceTheme.ink, width: rightBorder),
              bottom: BorderSide(color: OrbaceTheme.ink, width: bottomBorder),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = constraints.biggest.shortestSide;
              return value == null
                  ? _NotesGrid(
                      notes: controller.notesAt(index),
                      fontSize: cellSize * _noteFontScale,
                      padding: cellSize * _notePaddingScale,
                    )
                  : Text(
                      '$value',
                      style: TextStyle(
                        color: incorrect
                            ? OrbaceTheme.vermilion
                            : isGiven
                            ? OrbaceTheme.ink
                            : const Color(0xFF006FE6),
                        fontSize: cellSize * _valueFontScale,
                        fontWeight: isGiven ? FontWeight.w700 : FontWeight.w600,
                        height: 1,
                        letterSpacing: 0,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Color _cellColor({
    required bool selected,
    required bool related,
    required bool sameValue,
    required bool isHintTarget,
    required bool incorrect,
  }) {
    if (incorrect) {
      return const Color(0xFFF7D8D1);
    }
    if (isHintTarget) {
      return const Color(0xFFFFE2A8);
    }
    if (selected) {
      return const Color(0xFFFFD166);
    }
    if (sameValue) {
      return const Color(0xFFE9EFE5);
    }
    if (related) {
      return const Color(0xFFF0EEE5);
    }
    return OrbaceTheme.ricePaper;
  }

  String _semanticLabel(int row, int col, int? value, bool isGiven) {
    final valueText = value == null ? 'empty' : 'value $value';
    final sourceText = isGiven ? 'given' : 'player cell';
    return 'row ${row + 1}, column ${col + 1}, $valueText, $sourceText';
  }
}

class _NotesGrid extends StatelessWidget {
  const _NotesGrid({
    required this.notes,
    required this.fontSize,
    required this.padding,
  });

  final Set<int> notes;
  final double fontSize;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(padding),
      crossAxisCount: 3,
      children: [
        for (var value = 1; value <= 9; value++)
          Center(
            child: Text(
              notes.contains(value) ? '$value' : '',
              style: TextStyle(
                color: const Color(0xFF006FE6),
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
      ],
    );
  }
}
