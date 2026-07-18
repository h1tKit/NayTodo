import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naytodo/models/todo_work.dart'; // 导入 TodoWork 类

class StorageService {
  static const String _key = 'todos';

  /// 保存待办列表到本地
  static Future<void> saveTodos(List<TodoWork> todos) async {
    final prefs = await SharedPreferences.getInstance();
    // 将 List<TodoWork> 转为 List<Map>，再 JSON 编码为字符串
    final jsonString = jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  /// 从本地加载待办列表
  static Future<List<TodoWork>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    // JSON 解码为 List<dynamic>，再逐项转为 TodoWork
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => TodoWork.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}