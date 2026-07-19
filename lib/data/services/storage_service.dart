import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_work.dart';

class StorageService {
  static const String _key = 'todos';

  Future<void> saveTodos(List<TodoWork> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<List<TodoWork>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => TodoWork.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
