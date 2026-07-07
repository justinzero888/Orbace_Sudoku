import 'package:flutter/material.dart';

import '../../../app/orbace_theme.dart';
import 'game_session_controller.dart';

class SudokuNumberPad extends StatelessWidget {
  const SudokuNumberPad({
    super.key,
    required this.controller,
    required this.showAssistControls,
    required this.onHint,
  });

  final GameSessionController controller;
  final bool showAssistControls;
  final VoidCallback onHint;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final metrics = _KeypadMetrics.fromContext(context);
        final toolButtons = <_ToolButton>[
          _ToolButton(
            icon: Icons.edit_note,
            label: 'Notes',
            selected: controller.notesMode,
            onPressed: controller.toggleNotesMode,
            height: metrics.toolButtonHeight,
          ),
          if (showAssistControls)
            _ToolButton(
              icon: Icons.light_mode_outlined,
              label: 'Lantern Hint',
              onPressed: onHint,
              height: metrics.toolButtonHeight,
            ),
          _ToolButton(
            icon: Icons.undo,
            label: 'Undo',
            onPressed: controller.canUndo ? controller.undo : null,
            height: metrics.toolButtonHeight,
          ),
          _ToolButton(
            icon: Icons.redo,
            label: 'Redo',
            onPressed: controller.canRedo ? controller.redo : null,
            height: metrics.toolButtonHeight,
          ),
          if (showAssistControls)
            _ToolButton(
              icon: controller.mistakeChecking
                  ? Icons.visibility
                  : Icons.visibility_off,
              label: controller.mistakeChecking ? 'Check On' : 'Check Off',
              selected: controller.mistakeChecking,
              onPressed: () =>
                  controller.setMistakeChecking(!controller.mistakeChecking),
              height: metrics.toolButtonHeight,
            ),
        ];

        return Column(
          children: [
            Row(children: [for (final button in toolButtons) button]),
            const SizedBox(height: 12),
            _NumberRow(
              values: const [1, 2, 3, 4, 5],
              controller: controller,
              metrics: metrics,
            ),
            const SizedBox(height: 8),
            _NumberRow(
              values: const [6, 7, 8, 9],
              controller: controller,
              metrics: metrics,
              trailing: _EraseButton(
                onPressed: controller.eraseSelected,
                metrics: metrics,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KeypadMetrics {
  const _KeypadMetrics({
    required this.numberButtonHeight,
    required this.toolButtonHeight,
    required this.numberFontSize,
  });

  final double numberButtonHeight;
  final double toolButtonHeight;
  final double numberFontSize;

  factory _KeypadMetrics.fromContext(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight <= 680) {
      return const _KeypadMetrics(
        numberButtonHeight: 50,
        toolButtonHeight: 46,
        numberFontSize: 25,
      );
    }
    if (screenHeight <= 740) {
      return const _KeypadMetrics(
        numberButtonHeight: 56,
        toolButtonHeight: 50,
        numberFontSize: 27,
      );
    }
    return const _KeypadMetrics(
      numberButtonHeight: 64,
      toolButtonHeight: 56,
      numberFontSize: 30,
    );
  }
}

class _NumberRow extends StatelessWidget {
  const _NumberRow({
    required this.values,
    required this.controller,
    required this.metrics,
    this.trailing,
  });

  final List<int> values;
  final GameSessionController controller;
  final _KeypadMetrics metrics;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[
      for (final value in values)
        _NumberButton(value: value, controller: controller, metrics: metrics),
      ?trailing,
    ];
    return Row(
      children: [
        for (var i = 0; i < cells.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == cells.length - 1 ? 0 : 6),
              child: cells[i],
            ),
          ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    required this.value,
    required this.controller,
    required this.metrics,
  });

  final int value;
  final GameSessionController controller;
  final _KeypadMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.numberButtonHeight,
      child: FilledButton.tonal(
        onPressed: () => controller.enterNumber(value),
        style: FilledButton.styleFrom(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          '$value',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF006FE6),
            fontSize: metrics.numberFontSize,
            fontStyle: controller.notesMode
                ? FontStyle.italic
                : FontStyle.normal,
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _EraseButton extends StatelessWidget {
  const _EraseButton({required this.onPressed, required this.metrics});

  final VoidCallback onPressed;
  final _KeypadMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.numberButtonHeight,
      child: Tooltip(
        message: 'Erase',
        child: FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(Icons.backspace_outlined, size: 24),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onPressed,
    required this.height,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Tooltip(
          message: label,
          child: SizedBox(
            height: height,
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
