import 'package:flutter/material.dart';
import 'package:naytodo/widgets/add_todo_dialog.dart';
import 'package:naytodo/models/todo_work.dart';
import 'services/storage_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<TodoWork> todos = [];
  bool isLoading = true;
  
  final Map<String, SlidableController> _slidableControllers = {};

  SlidableController _controllerFor(TodoWork todo) {
    return _slidableControllers.putIfAbsent(todo.id, () => SlidableController(this));
  }

  @override
  void dispose() {    // 释放所有 controller，避免内存泄漏
    for (final c in _slidableControllers.values) {
      c.dispose();
    }
    _slidableControllers.clear();
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {     // 拖拽回调
    _updateData(() {
      if (oldIndex < newIndex) newIndex--;
      final item = todos.removeAt(oldIndex);
      todos.insert(newIndex, item);
    });
  }

  void _deleteTodo(TodoWork todo) {     // 删除回调 
    _updateData(() {
      todos.removeWhere((t) => t.id == todo.id);
    });
    _slidableControllers.remove(todo.id)?.dispose();    // 删除项时同步释放它的 controller
   }

  Future<void> _editTodo(TodoWork todo) async {     // 编辑回调
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AddTodoDialog(initialText: todo.title),
    );
    if (result != null && result.trim().isNotEmpty) {
      _updateData(() => todo.title = result.trim());
    }
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
        TodoWork(title: '待办事项示例', isDone: true),
        TodoWork(title: '左滑编辑', isDone: false),
        TodoWork(title: '右滑删除', isDone: false),
        TodoWork(title: '长按拖拽排序', isDone: false)
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
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: Stack(
        children: [
          Container(    // 背景颜色
            color: Color(0xFFFFF9C4),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SlidableAutoCloseBehavior(
              child: ReorderableListView.builder(
                itemCount: todos.length,
                onReorder: _onReorder,
                onReorderStart: (index) {
                  _slidableControllers[todos[index].id]?.close();
                },
                // 拖拽中的样式
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Material(
                        color: Color(0xFFFFF9C4),
                        elevation: 8,
                        shadowColor: Colors.pink.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: child,
                      );
                    },
                    child: child,
                  );
                },


                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Slidable(
                    key: ValueKey(todo.id),
                    controller: _controllerFor(todo),  // 注入外部 controller，使 overlay 中的拖拽副本共享同一 controller
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (_) => _deleteTodo(todo),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
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
                          onPressed: (_) => _editTodo(todo),
                          icon: Icons.edit,
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),

                    child: GestureDetector(
                      onTap: () {
                        _updateData(() {
                          todos[index].isDone = !todos[index].isDone;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  color: Color(0xFF360516),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                                  decorationThickness: 2,
                                  decorationColor: Color(0xFF360516),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Checkbox(
                              value: todo.isDone,
                              onChanged: (value) {
                                _updateData(() {
                                  todos[index].isDone = value!;
                                });
                              },
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                              activeColor: Colors.pink,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                },
              ),
            )
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
