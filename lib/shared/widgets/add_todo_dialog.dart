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
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        isEdit ? '编辑待办事项' : '添加待办事项',
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        height: 150,
        width: 300,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: '待办事项',
                labelStyle: TextStyle(
                  color: AppColors.label,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
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
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
