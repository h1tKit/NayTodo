import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naytodo/core/theme/app_colors.dart';

enum AppThemeMode { light, dark, system }

class ThemeStore extends ChangeNotifier {
  ThemeStore();

  static const _keyMode = 'theme_mode';
  static const _keySeed = 'theme_seed';

  // 状态
  AppThemeMode _mode = AppThemeMode.light;
  AppThemeMode get mode => _mode;

  Color _seedColor = AppColors.primary;
  Color get seedColor => _seedColor;

  // 派生
  ThemeMode get flutterThemeMode => switch (_mode) {
        AppThemeMode.light  => ThemeMode.light,
        AppThemeMode.dark   => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      };

  ThemeData get lightTheme => _buildTheme(Brightness.light);
  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(                     // 左侧返回图标
          color: colorScheme.onPrimary,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(    // 动作图标主题（首页设置图标）
          color: colorScheme.onPrimary,
          size: 24,
        ),
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
      ),
    );
  }

  // 持久化
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_keyMode);
    final seedValue = prefs.getInt(_keySeed);

    bool changed = false;
    if (modeIndex != null && modeIndex < AppThemeMode.values.length) {
      _mode = AppThemeMode.values[modeIndex];
      changed = true;
    }
    if (seedValue != null) {
      _seedColor = Color(seedValue);
      changed = true;
    }
    if (changed) notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMode, _mode.index);
    await prefs.setInt(_keySeed, _seedColor.value);
  }

   // 操作
  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _persist();
    notifyListeners();
  }

  void setSeedColor(Color color) {
    if (_seedColor == color) return;
    _seedColor = color;
    _persist();
    notifyListeners();
  }
}