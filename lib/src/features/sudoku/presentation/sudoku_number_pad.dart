import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import 'game_session_controller.dart';

class SudokuNumberPad extends StatelessWidget {
  const SudokuNumberPad({super.key, required this.controller});

  final GameSessionController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          children: [
            Row(
              children: [
                _ToolButton(
                  icon: Icons.edit_note,
                  label: 'Notes',
                  selected: controller.notesMode,
                  onPressed: controller.toggleNotesMode,
                ),
                _ToolButton(
                  icon: Icons.undo,
                  label: 'Undo',
                  onPressed: controller.canUndo ? controller.undo : null,
                ),
                _ToolButton(
                  icon: Icons.redo,
                  label: 'Redo',
                  onPressed: controller.canRedo ? controller.redo : null,
                ),
                _ToolButton(
                  icon: Icons.backspace_outlined,
                  label: 'Erase',
                  onPressed: controller.eraseSelected,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var value = 1; value <= 9; value++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: value == 9 ? 0 : 6),
                      child: SizedBox(
                        height: 48,
                        child: FilledButton.tonal(
                          onPressed: () => controller.enterNumber(value),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('$value'),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Tooltip(
          message: label,
          child: SizedBox(
            height: 44,
            child: IconButton.filledTonal(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                backgroundColor: selected ? OrbaceTheme.celadon : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(icon),
            ),
          ),
        ),
      ),
    );
  }
}
