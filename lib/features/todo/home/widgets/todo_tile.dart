import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/core/theme/app_colors.dart';
import 'package:naytodo/data/models/todo_work.dart';
import 'package:naytodo/shared/widgets/add_todo_dialog.dart';
import 'package:naytodo/shared/widgets/slidable_controller_pool.dart';
import 'package:naytodo/state/todo_store.dart';
import 'todo_tile_content.dart';

class TodoTile extends StatelessWidget {
  final TodoWork todo;
  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final store = context.read<TodoStore>();
    final pool = SlidableControllerPool.of(context);
    return Slidable(
      key: ValueKey(todo.id),
      controller: pool.of(todo.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => store.deleteTodo(todo.id),
            icon: Icons.delete,
            backgroundColor: AppColors.delete,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => _edit(context, store),
            icon: Icons.edit,
            backgroundColor: AppColors.edit,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: TodoTileContent(
        todo: todo,
        onToggle: () => store.toggleDone(todo.id),
      ),
    );
  }

  Future<void> _edit(BuildContext context, TodoStore store) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AddTodoDialog(initialText: todo.title),
    );
    if (result != null) {
      store.editTodo(todo.id, result);
    }
  }
}
