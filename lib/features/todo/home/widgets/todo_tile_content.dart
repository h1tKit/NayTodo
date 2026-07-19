import 'package:flutter/material.dart';
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
    final colorTheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(           // 代办项字体样式
                  color: todo.isDone
                      ? colorTheme.onSurface.withValues(alpha: 0.38)
                      : colorTheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  decorationThickness: 2,
                  decorationColor: colorTheme.onSurface.withValues(alpha: 0.38)
                ),
              ),
            ),
            const SizedBox(width: 12),
            Checkbox(
              value: todo.isDone,
              onChanged: (_) => onToggle(),
              shape: const CircleBorder(),
              checkColor: colorTheme.surface,
              activeColor: colorTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
