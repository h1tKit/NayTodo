import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/state/todo_store.dart';
import 'widgets/add_todo_fab.dart';
import 'widgets/todo_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ErrorSnackListener(child: _HomeScaffold());
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<TodoStore, bool>((s) => s.isLoading);
    return Scaffold(
      appBar: AppBar(title: const Text('NayTodo')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : const TodoListView(),
      floatingActionButton: const AddTodoFAB(),
    );
  }
}

class _ErrorSnackListener extends StatefulWidget {
  final Widget child;
  const _ErrorSnackListener({required this.child});

  @override
  State<_ErrorSnackListener> createState() => _ErrorSnackListenerState();
}

class _ErrorSnackListenerState extends State<_ErrorSnackListener> {
  String? _shown;

  @override
  Widget build(BuildContext context) {
    final error = context.select<TodoStore, String?>((s) => s.error);
    if (error == null) {
      _shown = null;
    } else if (error != _shown) {
      _shown = error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(error)),
        );
        context.read<TodoStore>().clearError();
      });
    }
    return widget.child;
  }
}
