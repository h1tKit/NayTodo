import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/shared/widgets/slidable_controller_pool.dart';
import 'package:naytodo/state/todo_store.dart';
import 'todo_tile.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TodoStore>();
    final pool = SlidableControllerPool.of(context);
    final todos = store.todos;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SlidableAutoCloseBehavior(
        child: ReorderableListView.builder(
          itemCount: todos.length,
          onReorder: store.reorder,
          onReorderStart: (index) => pool.close(todos[index].id),
          proxyDecorator: _proxyDecorator,
          itemBuilder: (context, index) =>
              TodoTile(key: ValueKey(todos[index].id), todo: todos[index]),
        ),
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int _, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          shadowColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      child: child,
    );
  }
}
