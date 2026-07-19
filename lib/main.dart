import 'package:flutter/material.dart';
import 'package:naytodo/app.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 开启 edge-to-edge：导航栏变透明，应用绘制到全屏
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const NayTodoApp());
}
