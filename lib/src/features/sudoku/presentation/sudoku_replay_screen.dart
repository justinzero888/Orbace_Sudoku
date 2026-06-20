import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import '../domain/sudoku_attempt.dart';
import '../domain/sudoku_board.dart';
import '../domain/sudoku_move.dart';

class SudokuReplayScreen extends StatefulWidget {
  const SudokuReplayScreen({
    super.key,
    required this.givens,
    required this.attempt,
  });

  final SudokuBoard givens;
  final SudokuAttempt attempt;

  @override
  State<SudokuReplayScreen> createState() => _SudokuReplayScreenState();
}

class _SudokuReplayScreenState extends State<SudokuReplayScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final values = _valuesAtStep();

    return Scaffold(
      appBar: AppBar(title: const Text('Replay')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Attempt ${widget.attempt.attemptNumber}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Step $_step of ${widget.attempt.moveHistory.length}'),
            const SizedBox(height: 16),
            _ReplayBoard(values: values, givens: widget.givens),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _step == 0
                        ? null
                        : () => setState(() => _step--),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _step >= widget.attempt.moveHistory.length
                        ? null
                        : () => setState(() => _step++),
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _MoveList(attempt: widget.attempt, currentStep: _step),
          ],
        ),
      ),
    );
  }

  List<int?> _valuesAtStep() {
    final values = widget.givens.toMutableCells();
    for (var i = 0; i < _step && i < widget.attempt.moveHistory.length; i++) {
      final move = widget.attempt.moveHistory[i];
      switch (move.type) {
        case SudokuMoveType.valueEntry:
        case SudokuMoveType.erase:
        case SudokuMoveType.hintReveal:
          values[move.cellIndex] = move.nextValue;
          break;
        case SudokuMoveType.noteToggle:
          break;
      }
    }
    return values;
  }
}

class _ReplayBoard extends StatelessWidget {
  const _ReplayBoard({required this.values, required this.givens});

  final List<int?> values;
  final SudokuBoard givens;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: OrbaceTheme.ink,
          border: Border.all(color: OrbaceTheme.ink, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: SudokuBoard.cellCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SudokuBoard.size,
          ),
          itemBuilder: (context, index) {
            final row = SudokuBoard.rowOf(index);
            final col = SudokuBoard.colOf(index);
            final value = values[index];
            final isGiven = givens.valueAtIndex(index) != null;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isGiven
                    ? const Color(0xFFF0EEE5)
                    : OrbaceTheme.ricePaper,
                border: Border(
                  right: BorderSide(
                    color: OrbaceTheme.ink,
                    width: col == 2 || col == 5 ? 2 : 0.7,
                  ),
                  bottom: BorderSide(
                    color: OrbaceTheme.ink,
                    width: row == 2 || row == 5 ? 2 : 0.7,
                  ),
                ),
              ),
              child: Text(
                value == null ? '' : '$value',
                style: TextStyle(
                  color: isGiven ? OrbaceTheme.ink : const Color(0xFF385D4A),
                  fontWeight: isGiven ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MoveList extends StatelessWidget {
  const _MoveList({required this.attempt, required this.currentStep});

  final SudokuAttempt attempt;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Move History', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (var i = 0; i < attempt.moveHistory.length; i++)
              _MoveRow(
                index: i,
                move: attempt.moveHistory[i],
                active: i == currentStep - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _MoveRow extends StatelessWidget {
  const _MoveRow({
    required this.index,
    required this.move,
    required this.active,
  });

  final int index;
  final SudokuMove move;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final row = SudokuBoard.rowOf(move.cellIndex) + 1;
    final col = SudokuBoard.colOf(move.cellIndex) + 1;
    final label = switch (move.type) {
      SudokuMoveType.valueEntry => 'R$row C$col = ${move.nextValue}',
      SudokuMoveType.erase => 'Erase R$row C$col',
      SudokuMoveType.hintReveal =>
        'Hint reveal R$row C$col = ${move.nextValue}',
      SudokuMoveType.noteToggle => 'Note ${move.noteValue} at R$row C$col',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE1E9DD) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('${index + 1}. $label'),
    );
  }
}
