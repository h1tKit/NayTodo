import 'package:flutter/material.dart';
import 'package:naytodo/core/theme/app_colors.dart';

class AddTodoDialog extends StatefulWidget {
  final String? initialText;
  const AddTodoDialog({super.key, this.initialText});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late final _controller = TextEditingController(
    text: widget.initialText ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.of(context).pop(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialText != null;
    final colorTheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorTheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        isEdit ? '编辑待办事项' : '添加待办事项',
        style: TextStyle(
          color: colorTheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      content: SizedBox(
        height: 150,
        width: 300,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(
                color: colorTheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: '待办事项',
                labelStyle: TextStyle(
                  color: colorTheme.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submit,
          child: Text(
            isEdit ? '保存' : '添加',
            style: TextStyle(
              color: colorTheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
