import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeStore = context.watch<ThemeStore>();
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
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
                          ? [BoxShadow(color: displayColor.withValues(alpha: 0.5), blurRadius: 8)]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}