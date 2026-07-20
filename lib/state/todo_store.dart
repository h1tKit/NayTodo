import 'package:flutter/foundation.dart';

import '../data/models/todo_work.dart';
import '../data/repositories/todo_repository.dart';
import 'seed_data.dart';

class TodoStore extends ChangeNotifier {
  final TodoRepository _repo;
  TodoStore(this._repo);

  List<TodoWork> _todos = [];
  List<TodoWork> _view = const [];
  bool _isLoading = true;
  String? _error;

  List<TodoWork> get todos => _view;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final loaded = await _repo.getAll();
      _todos = loaded.isEmpty ? List.of(SeedData.defaults) : loaded;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _refreshView();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) =>
      _mutate((t) => t.add(TodoWork(title: title)));

  Future<void> toggleDone(String id) => _mutate((t) {
    final i = t.indexWhere((e) => e.id == id);
    if (i != -1) t[i].isDone ^= true;
  });

  Future<void> deleteTodo(String id) =>
      _mutate((t) => t.removeWhere((e) => e.id == id));

  Future<void> editTodo(String id, String title) => _mutate((t) {
    final i = t.indexWhere((e) => e.id == id);
    if (i != -1) t[i].title = title;
  });

  Future<void> reorder(int oldIndex, int newIndex) => _mutate((t) {
    if (oldIndex < newIndex) newIndex--;
    final item = t.removeAt(oldIndex);
    t.insert(newIndex, item);
  });

  Future<void> _mutate(void Function(List<TodoWork> todos) mutate) async {
    final snapshot = List<TodoWork>.of(_todos);
    mutate(_todos);
    _refreshView();
    notifyListeners();
    try {
      await _repo.save(_todos);
    } catch (e) {
      _todos = snapshot;
      _refreshView();
      _error = e.toString();
      notifyListeners();
    }
  }

  void _refreshView() {
    _view = List.unmodifiable(_todos);
  }
}
