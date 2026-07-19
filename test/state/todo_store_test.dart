import 'package:flutter_test/flutter_test.dart';
import 'package:naytodo/data/models/todo_work.dart';
import 'package:naytodo/data/repositories/todo_repository.dart';
import 'package:naytodo/data/services/storage_service.dart';
import 'package:naytodo/state/todo_store.dart';

class _MemoryStorage extends StorageService {
  List<TodoWork> items = [];

  @override
  Future<List<TodoWork>> loadTodos() async => List.of(items);

  @override
  Future<void> saveTodos(List<TodoWork> todos) async {
    items = List.of(todos);
  }
}

class _FailingStorage extends StorageService {
  @override
  Future<List<TodoWork>> loadTodos() async => [];

  @override
  Future<void> saveTodos(List<TodoWork> todos) async {
    throw Exception('disk full');
  }
}

void main() {
  late _MemoryStorage storage;
  late TodoStore store;

  setUp(() async {
    storage = _MemoryStorage();
    store = TodoStore(TodoRepository(storage));
    await store.load();
  });

  test('load uses seed data when storage is empty', () {
    expect(store.todos, hasLength(4));
    expect(store.todos.first.title, '待办事项示例');
    expect(store.isLoading, isFalse);
  });

  test('addTodo appends and persists', () async {
    await store.addTodo('新事项');
    expect(store.todos, hasLength(5));
    expect(store.todos.last.title, '新事项');
    expect(storage.items, hasLength(5));
  });

  test('toggleDone flips isDone by id', () async {
    final id = store.todos.first.id;
    final before = store.todos.first.isDone;
    await store.toggleDone(id);
    expect(store.todos.first.isDone, !before);
  });

  test('deleteTodo removes by id', () async {
    final id = store.todos.first.id;
    await store.deleteTodo(id);
    expect(store.todos.where((t) => t.id == id), isEmpty);
    expect(store.todos, hasLength(3));
  });

  test('editTodo updates title by id', () async {
    final id = store.todos.first.id;
    await store.editTodo(id, '改后');
    expect(store.todos.first.title, '改后');
  });

  test('reorder moves item from old to new index', () async {
    final firstId = store.todos.first.id;
    await store.reorder(0, 2);
    expect(store.todos[1].id, firstId);
  });

  test('load restores previously saved items', () async {
    await store.addTodo('持久');
    final second = TodoStore(TodoRepository(storage));
    await second.load();
    expect(second.todos.where((t) => t.title == '持久'), isNotEmpty);
  });

  test('toggleDone is a no-op when id is missing', () async {
    await store.toggleDone('nonexistent-id');
    expect(store.todos, hasLength(4));
  });

  test('editTodo is a no-op when id is missing', () async {
    await store.editTodo('nonexistent-id', 'x');
    expect(store.todos.every((t) => t.title != 'x'), isTrue);
  });

  test('persistence failure rolls back in-memory change and sets error', () async {
    final failing = _FailingStorage();
    final s = TodoStore(TodoRepository(failing));
    await s.load();
    final len = s.todos.length;
    await s.addTodo('不会留下');
    expect(s.todos.length, len);
    expect(s.error, isNotNull);
  });
}
