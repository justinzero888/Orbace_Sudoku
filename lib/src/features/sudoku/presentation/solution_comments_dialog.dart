import 'package:flutter/material.dart';

Future<String?> showSolutionCommentsDialog(
  BuildContext context, {
  required String initialText,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _SolutionCommentsDialog(initialText: initialText),
  );
}

class _SolutionCommentsDialog extends StatefulWidget {
  const _SolutionCommentsDialog({required this.initialText});

  final String initialText;

  @override
  State<_SolutionCommentsDialog> createState() =>
      _SolutionCommentsDialogState();
}

class _SolutionCommentsDialogState extends State<_SolutionCommentsDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Solution Comments'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 6,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(
          hintText: 'Add notes about difficulty, technique, or ranking.',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save Notes'),
        ),
      ],
    );
  }
}
