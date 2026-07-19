import 'package:flutter/material.dart';
import 'package:naytodo/core/theme/app_colors.dart';

enum AppThemeMode { light, dark, system }

class ThemeStore extends ChangeNotifier {
  ThemeStore();

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

  // 操作
  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void setSeedColor(Color color) {
    if (_seedColor == color) return;
    _seedColor = color;
    notifyListeners();
  }
}