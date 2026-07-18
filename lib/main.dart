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

  bool isLoading = true;
  bool _isDragging = false;

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
            child: ListView.separated(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(      // ListView 列表项
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
              separatorBuilder: (context, index) {
                return Divider(      // 分隔线
                  height: 10,
                  color: Colors.pink,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
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
