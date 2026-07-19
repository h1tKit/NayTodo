import '../data/models/todo_work.dart';

class SeedData {
  const SeedData._();

  static final List<TodoWork> defaults = [
    TodoWork(title: '待办事项示例', isDone: true),
    TodoWork(title: '左滑编辑', isDone: false),
    TodoWork(title: '右滑删除', isDone: false),
    TodoWork(title: '长按拖拽排序', isDone: false),
  ];
}
