import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/features/settings/background_editor_page.dart';
import 'package:naytodo/state/theme_store.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _seedOptions = [
    Colors.pink, // Pink
    Colors.blue, // Blue
    Colors.green, // Green
    Colors.orange, // Orange
    Colors.purple, // Purple
    Colors.cyan, // Cyan
  ];

  // 根据种子色推导 primary
  static Color _primaryFromSeed(Color seed, Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ).primary;
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _selectBackgroundImage(BuildContext context) async {
    final store = context.read<ThemeStore>();
    String? pendingPath;

    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 3200,
        maxHeight: 3200,
        imageQuality: 90,
      );
      if (image == null) return;

      pendingPath = await store.createPendingBackground(image.path);
      if (!context.mounted) {
        await store.discardPendingBackground(pendingPath);
        return;
      }

      final result = await Navigator.of(context).push<BackgroundEditResult>(
        MaterialPageRoute(
          builder: (_) => BackgroundEditorPage(imagePath: pendingPath!),
        ),
      );

      if (result == null) {
        await store.discardPendingBackground(pendingPath);
        return;
      }

      await store.applyBackgroundImage(
        pendingPath: pendingPath,
        focus: result.focus,
        scale: result.scale,
      );
      pendingPath = null;
    } catch (error) {
      if (pendingPath != null) {
        await store.discardPendingBackground(pendingPath);
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('设置背景失败：$error')));
    }
  }

  Future<void> _editBackgroundImage(BuildContext context) async {
    final store = context.read<ThemeStore>();
    final path = store.backgroundImagePath;
    if (path == null) return;

    final result = await Navigator.of(context).push<BackgroundEditResult>(
      MaterialPageRoute(
        builder: (_) => BackgroundEditorPage(
          imagePath: path,
          initialFocus: Offset(store.backgroundFocusX, store.backgroundFocusY),
          initialScale: store.backgroundScale,
        ),
      ),
    );
    if (result == null) return;
    await store.updateBackgroundPosition(
      focus: result.focus,
      scale: result.scale,
    );
  }

  Future<void> _setBackgroundMode(
    BuildContext context,
    AppBackgroundMode mode,
  ) async {
    final store = context.read<ThemeStore>();
    if (mode == AppBackgroundMode.image && !store.hasBackgroundImage) {
      await _selectBackgroundImage(context);
      return;
    }
    store.setBackgroundMode(mode);
  }

  Future<void> _removeBackgroundImage(BuildContext context) async {
    try {
      await context.read<ThemeStore>().clearBackgroundImage();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('移除背景失败：$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeStore = context.watch<ThemeStore>();
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '设置',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            // 主题模式
            _buildSectionTitle(context, '主题模式'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<AppThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: AppThemeMode.light,
                    label: Text('浅色'),
                    icon: Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.dark,
                    label: Text('深色'),
                    icon: Icon(Icons.dark_mode),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.system,
                    label: Text('跟随系统'),
                    icon: Icon(Icons.settings_brightness),
                  ),
                ],
                selected: {themeStore.mode},
                onSelectionChanged: (set) => themeStore.setMode(set.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            // 主题色
            _buildSectionTitle(context, '主题色'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _seedOptions.map((seed) {
                  final displayColor = _primaryFromSeed(seed, brightness);
                  final isSelected = themeStore.seedColor == seed;

                  return GestureDetector(
                    onTap: () => themeStore.setSeedColor(seed),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: displayColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: displayColor.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            _buildSectionTitle(context, '页面背景'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<AppBackgroundMode>(
                segments: const [
                  ButtonSegment(
                    value: AppBackgroundMode.solid,
                    label: Text('纯色'),
                    icon: Icon(Icons.format_color_fill),
                  ),
                  ButtonSegment(
                    value: AppBackgroundMode.image,
                    label: Text('图片'),
                    icon: Icon(Icons.image_outlined),
                  ),
                ],
                selected: {themeStore.backgroundMode},
                onSelectionChanged: (selection) {
                  _setBackgroundMode(context, selection.first);
                },
              ),
            ),
            if (themeStore.hasBackgroundImage) ...[
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('背景图片'),
                subtitle: Text(
                  themeStore.backgroundMode == AppBackgroundMode.image
                      ? '正在使用'
                      : '已保留，切换到图片模式即可恢复',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'replace':
                        _selectBackgroundImage(context);
                      case 'adjust':
                        _editBackgroundImage(context);
                      case 'remove':
                        _removeBackgroundImage(context);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'replace', child: Text('更换图片')),
                    PopupMenuItem(value: 'adjust', child: Text('调整图片')),
                    PopupMenuItem(value: 'remove', child: Text('移除图片')),
                  ],
                ),
                onTap: () => _editBackgroundImage(context),
              ),
            ] else
              ListTile(
                leading: const Icon(Icons.add_photo_alternate_outlined),
                title: const Text('选择背景图片'),
                onTap: () => _selectBackgroundImage(context),
              ),
            if (themeStore.backgroundMode == AppBackgroundMode.image &&
                themeStore.hasBackgroundImage)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '主题色叠加强度 '
                      '${(themeStore.backgroundOverlayOpacity * 100).round()}%',
                    ),
                    Slider(
                      value: themeStore.backgroundOverlayOpacity,
                      min: 0,
                      max: 1,
                      divisions: 20,
                      label:
                          '${(themeStore.backgroundOverlayOpacity * 100).round()}%',
                      onChanged: themeStore.previewBackgroundOverlayOpacity,
                      onChangeEnd: (_) {
                        themeStore.persistBackgroundOverlayOpacity();
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
