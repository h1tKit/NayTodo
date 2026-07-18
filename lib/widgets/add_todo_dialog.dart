import 'package:flutter/material.dart';


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
    return AlertDialog(
      backgroundColor: Color(0xFFFFF9C4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        widget.initialText != null ? '编辑待办事项' : '添加待办事项',
        style: TextStyle(
          color: Color(0xFF360516),
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
              style: TextStyle(
                color: Color(0xFF360516),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: '待办事项',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 108, 68, 82),
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
            widget.initialText != null ? '保存' : '添加',
            style: TextStyle(
              color: Color(0xFF360516),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}