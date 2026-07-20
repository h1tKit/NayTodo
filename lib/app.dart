import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/data/repositories/todo_repository.dart';
import 'package:naytodo/data/services/storage_service.dart';
import 'package:naytodo/features/todo/home/home_page.dart';
import 'package:naytodo/shared/widgets/page_background.dart';
import 'package:naytodo/shared/widgets/slidable_controller_pool.dart';
import 'package:naytodo/state/todo_store.dart';
import 'package:naytodo/state/theme_store.dart';

class NayTodoApp extends StatelessWidget {
  const NayTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        Provider(create: (c) => TodoRepository(c.read<StorageService>())),
        ChangeNotifierProvider(
          create: (c) => TodoStore(c.read<TodoRepository>())..load(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeStore()..load()),
      ],
      child: SlidableControllerPool(
        child: Consumer<ThemeStore>(
          builder: (context, themeStore, _) {
            final isDark =
                themeStore.flutterThemeMode == ThemeMode.dark ||
                (themeStore.flutterThemeMode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) ==
                        Brightness.dark);
            final theme = isDark ? themeStore.darkTheme : themeStore.lightTheme;
            final primary = theme.colorScheme.primary;
            final iconBrightness =
                ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
                ? Brightness.light
                : Brightness.dark;
            final navigationIconBrightness = isDark
                ? Brightness.light
                : Brightness.dark;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                // 状态栏
                statusBarColor: primary,
                statusBarIconBrightness: iconBrightness, // useful
                // 保持导航栏透明，让全局背景延伸到系统手势区域。
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: navigationIconBrightness,
                systemNavigationBarContrastEnforced: false,
              ),
              child: MaterialApp(
                title: 'NayTodo',
                theme: themeStore.lightTheme,
                darkTheme: themeStore.darkTheme,
                themeMode: themeStore.flutterThemeMode,
                home: const HomePage(),
                builder: (context, child) => AppBodyBackground(
                  mode: themeStore.backgroundMode,
                  imagePath: themeStore.backgroundImagePath,
                  overlayOpacity: themeStore.backgroundOverlayOpacity,
                  focus: Offset(
                    themeStore.backgroundFocusX,
                    themeStore.backgroundFocusY,
                  ),
                  scale: themeStore.backgroundScale,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
