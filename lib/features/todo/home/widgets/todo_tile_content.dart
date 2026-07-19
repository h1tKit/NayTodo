import 'package:flutter/material.dart';
import 'package:naytodo/core/theme/app_colors.dart';
import 'package:naytodo/data/models/todo_work.dart';

class TodoTileContent extends StatelessWidget {
  final TodoWork todo;
  final VoidCallback onToggle;
  const TodoTileContent({
    super.key,
    required this.todo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  decorationThickness: 2,
                  decorationColor: AppColors.text,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Checkbox(
              value: todo.isDone,
              onChanged: (_) => onToggle(),
              shape: const CircleBorder(),
              checkColor: Colors.white,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
