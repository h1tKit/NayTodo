import '../models/todo_work.dart';
import '../services/storage_service.dart';

class TodoRepository {
  final StorageService _storage;
  TodoRepository(this._storage);

  Future<List<TodoWork>> getAll() => _storage.loadTodos();
  Future<void> save(List<TodoWork> todos) => _storage.saveTodos(todos);
}
