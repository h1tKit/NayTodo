import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naytodo/data/repositories/todo_repository.dart';
import 'package:naytodo/data/services/storage_service.dart';
import 'package:naytodo/features/todo/home/home_page.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeStore()),
      ],
      child: SlidableControllerPool(
        child: Consumer<ThemeStore>(
          builder: (context, themeStore, _) {
            return MaterialApp(
              title: 'NayTodo',
              theme: themeStore.lightTheme,
              darkTheme: themeStore.darkTheme,
              themeMode: themeStore.flutterThemeMode,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
