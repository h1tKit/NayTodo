import 'package:flutter/material.dart';
import 'package:naytodo/widgets/add_todo_dialog.dart';
import 'package:naytodo/models/todo_work.dart';
import 'services/storage_service.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<TodoWork> todos = [];

  bool isLoading = true;   // 拖拽中标记，防止拖拽时误触 Checkbox

  void _onReorder(int oldIndex, int newIndex) {     // 拖拽回调
    _updateData(() {
      if (oldIndex < newIndex) newIndex--;
      final item = todos.removeAt(oldIndex);
      todos.insert(newIndex, item);
    });
  }


   @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedTodos = await StorageService.loadTodos();
    setState(() {
      todos = loadedTodos.isEmpty ? <TodoWork>[
        TodoWork(title: '待办事项', isDone: false)
      ] : loadedTodos;
      isLoading = false;
    });
  }

  Future<void> _updateData(Function() updater) async {
    setState(updater);
    await StorageService.saveTodos(todos);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NayTodo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Stack(
        children: [
          Container(    // 背景颜色
            color: Color(0xFFFFF9C4),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: ReorderableListView.builder(
              itemCount: todos.length,
              onReorder: _onReorder,

              // 拖拽中的样式
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Material(
                      color: Color.fromARGB(255, 248, 243, 201),
                      elevation: 8,
                      shadowColor: Colors.pink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      child: child,
                    );
                  },
                  child: child,
                );
              },


              itemBuilder: (context, index) {
                return CheckboxListTile(      // ListView 列表项
                  key: ValueKey(todos[index].id),
                  title: Text(
                    todos[index].title,
                    style: TextStyle(
                      color: Color(0xFF360516),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: todos[index].isDone,
                  onChanged: (value) {
                    _updateData(() {
                      todos[index].isDone = value!;
                    });
                  },
                  checkboxShape: CircleBorder(),
                  checkColor: Colors.white,
                  activeColor: Colors.pink,
                );
              },
            ),
          ),


          Positioned.fill(      // 添加按钮
            child: Align(
            alignment: Alignment(0.75, 0.85), // x横向(-1~1) y纵向(-1~1)
              child: FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: Colors.pink,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) => AddTodoDialog(),
                  );
                  if (result != null && result.trim().isNotEmpty) {
                    _updateData(() {
                      todos.add(TodoWork(title: result.trim(), isDone: false));
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
