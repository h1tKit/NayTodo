import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naytodo/core/theme/app_colors.dart';

enum AppThemeMode { light, dark, system }

enum AppBackgroundMode { solid, image }

class ThemeStore extends ChangeNotifier {
  ThemeStore();

  static const _keyMode = 'theme_mode';
  static const _keySeed = 'theme_seed';
  static const _keyBackgroundMode = 'background_mode';
  static const _keyBackgroundImagePath = 'background_image_path';
  static const _keyBackgroundOverlayOpacity = 'background_overlay_opacity';
  static const _keyBackgroundFocusX = 'background_focus_x';
  static const _keyBackgroundFocusY = 'background_focus_y';
  static const _keyBackgroundScale = 'background_scale';

  // 状态
  AppThemeMode _mode = AppThemeMode.light;
  AppThemeMode get mode => _mode;

  Color _seedColor = AppColors.primary;
  Color get seedColor => _seedColor;

  AppBackgroundMode _backgroundMode = AppBackgroundMode.solid;
  AppBackgroundMode get backgroundMode => _backgroundMode;

  String? _backgroundImagePath;
  String? get backgroundImagePath => _backgroundImagePath;
  bool get hasBackgroundImage => _backgroundImagePath != null;

  double _backgroundOverlayOpacity = 0.35;
  double get backgroundOverlayOpacity => _backgroundOverlayOpacity;

  double _backgroundFocusX = 0.5;
  double get backgroundFocusX => _backgroundFocusX;

  double _backgroundFocusY = 0.5;
  double get backgroundFocusY => _backgroundFocusY;

  double _backgroundScale = 1.0;
  double get backgroundScale => _backgroundScale;

  // 派生
  ThemeMode get flutterThemeMode => switch (_mode) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
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
      scaffoldBackgroundColor: Colors.transparent,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(
            backgroundColor: Colors.transparent,
          ),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          // 左侧返回图标
          color: colorScheme.onPrimary,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          // 动作图标主题（首页设置图标）
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
    final backgroundModeIndex = prefs.getInt(_keyBackgroundMode);
    final backgroundImagePath = prefs.getString(_keyBackgroundImagePath);

    bool changed = false;
    if (modeIndex != null &&
        modeIndex >= 0 &&
        modeIndex < AppThemeMode.values.length) {
      _mode = AppThemeMode.values[modeIndex];
      changed = true;
    }
    if (seedValue != null) {
      _seedColor = Color(seedValue);
      changed = true;
    }
    if (backgroundImagePath != null &&
        await File(backgroundImagePath).exists()) {
      _backgroundImagePath = backgroundImagePath;
      changed = true;
    } else if (backgroundImagePath != null) {
      await prefs.remove(_keyBackgroundImagePath);
    }
    if (backgroundModeIndex != null &&
        backgroundModeIndex >= 0 &&
        backgroundModeIndex < AppBackgroundMode.values.length &&
        (backgroundModeIndex == AppBackgroundMode.solid.index ||
            _backgroundImagePath != null)) {
      _backgroundMode = AppBackgroundMode.values[backgroundModeIndex];
      changed = true;
    }
    _backgroundOverlayOpacity =
        (prefs.getDouble(_keyBackgroundOverlayOpacity) ?? 0.35).clamp(0.0, 1.0);
    _backgroundFocusX = (prefs.getDouble(_keyBackgroundFocusX) ?? 0.5).clamp(
      0.0,
      1.0,
    );
    _backgroundFocusY = (prefs.getDouble(_keyBackgroundFocusY) ?? 0.5).clamp(
      0.0,
      1.0,
    );
    _backgroundScale = (prefs.getDouble(_keyBackgroundScale) ?? 1.0).clamp(
      1.0,
      4.0,
    );
    if (changed) notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMode, _mode.index);
    await prefs.setInt(_keySeed, _seedColor.toARGB32());
    await prefs.setInt(_keyBackgroundMode, _backgroundMode.index);
    await prefs.setDouble(
      _keyBackgroundOverlayOpacity,
      _backgroundOverlayOpacity,
    );
    await prefs.setDouble(_keyBackgroundFocusX, _backgroundFocusX);
    await prefs.setDouble(_keyBackgroundFocusY, _backgroundFocusY);
    await prefs.setDouble(_keyBackgroundScale, _backgroundScale);
    final imagePath = _backgroundImagePath;
    if (imagePath == null) {
      await prefs.remove(_keyBackgroundImagePath);
    } else {
      await prefs.setString(_keyBackgroundImagePath, imagePath);
    }
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

  void setBackgroundMode(AppBackgroundMode mode) {
    if (mode == AppBackgroundMode.image && !hasBackgroundImage) return;
    if (_backgroundMode == mode) return;
    _backgroundMode = mode;
    _persist();
    notifyListeners();
  }

  void previewBackgroundOverlayOpacity(double opacity) {
    final next = opacity.clamp(0.0, 1.0);
    if (_backgroundOverlayOpacity == next) return;
    _backgroundOverlayOpacity = next;
    notifyListeners();
  }

  Future<void> persistBackgroundOverlayOpacity() => _persist();

  Future<String> createPendingBackground(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw const FileSystemException('选择的图片文件不存在');
    }

    final backgroundDirectory = await _backgroundDirectory();
    final extension = p.extension(sourcePath).toLowerCase();
    final target = File(
      p.join(
        backgroundDirectory.path,
        'pending_${DateTime.now().microsecondsSinceEpoch}'
        '${extension.isEmpty ? '.jpg' : extension}',
      ),
    );
    await source.copy(target.path);
    return target.path;
  }

  Future<void> applyBackgroundImage({
    required String pendingPath,
    required Offset focus,
    required double scale,
  }) async {
    final directory = await _backgroundDirectory();
    final normalizedPending = p.normalize(p.absolute(pendingPath));
    final normalizedDirectory = p.normalize(p.absolute(directory.path));
    if (!p.isWithin(normalizedDirectory, normalizedPending)) {
      throw const FileSystemException('背景图片不在应用目录中');
    }

    final pending = File(normalizedPending);
    if (!await pending.exists()) {
      throw const FileSystemException('待保存的背景图片不存在');
    }

    final extension = p.extension(pending.path);
    final target = File(
      p.join(
        directory.path,
        'background_${DateTime.now().microsecondsSinceEpoch}$extension',
      ),
    );
    await pending.rename(target.path);

    final oldPath = _backgroundImagePath;
    _backgroundImagePath = target.path;
    _backgroundFocusX = focus.dx.clamp(0.0, 1.0);
    _backgroundFocusY = focus.dy.clamp(0.0, 1.0);
    _backgroundScale = scale.clamp(1.0, 4.0);
    _backgroundMode = AppBackgroundMode.image;
    await _persist();
    notifyListeners();

    if (oldPath != null && oldPath != target.path) {
      await _deleteManagedBackground(oldPath);
    }
  }

  Future<void> updateBackgroundPosition({
    required Offset focus,
    required double scale,
  }) async {
    _backgroundFocusX = focus.dx.clamp(0.0, 1.0);
    _backgroundFocusY = focus.dy.clamp(0.0, 1.0);
    _backgroundScale = scale.clamp(1.0, 4.0);
    await _persist();
    notifyListeners();
  }

  Future<void> discardPendingBackground(String path) async {
    await _deleteManagedBackground(path);
  }

  Future<void> clearBackgroundImage() async {
    final oldPath = _backgroundImagePath;
    _backgroundImagePath = null;
    _backgroundMode = AppBackgroundMode.solid;
    _backgroundFocusX = 0.5;
    _backgroundFocusY = 0.5;
    _backgroundScale = 1.0;
    await _persist();
    notifyListeners();
    if (oldPath != null) await _deleteManagedBackground(oldPath);
  }

  Future<Directory> _backgroundDirectory() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final directory = Directory(p.join(supportDirectory.path, 'backgrounds'));
    await directory.create(recursive: true);
    return directory;
  }

  Future<void> _deleteManagedBackground(String filePath) async {
    final directory = await _backgroundDirectory();
    final normalizedFile = p.normalize(p.absolute(filePath));
    final normalizedDirectory = p.normalize(p.absolute(directory.path));
    if (!p.isWithin(normalizedDirectory, normalizedFile)) return;

    final file = File(normalizedFile);
    if (await file.exists()) await file.delete();
  }
}
