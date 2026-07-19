import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/shared/widgets/add_todo_dialog.dart';
import 'package:naytodo/state/todo_store.dart';

class AddTodoFAB extends StatelessWidget {
  const AddTodoFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _add(context),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _add(BuildContext context) async {
    final store = context.read<TodoStore>();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const AddTodoDialog(),
    );
    if (result != null) {
      store.addTodo(result);
    }
  }
}
