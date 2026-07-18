# NayTodo

EN | 中文

> A clean and simple Flutter todo app. / 一个简洁的待办事项 Flutter 应用。

---

## Why / 为什么做这个项目

I needed a todo list for daily use. Existing apps were either too bloated or not visually appealing enough. I wanted to build one that is simple in function, smooth in interaction, and clean in design — something that serves my own daily needs.

我自己有使用待办清单的需求。现有的待办应用要么功能过于臃肿，要么界面不够美观。我希望做一个功能简洁、交互流畅、界面干净美观的待办应用，满足自己的日常使用。

---

## Features / 功能

- Add, complete, and delete todos / 添加、完成、删除待办事项
- Long-press to drag and reorder / 长按拖拽排序
- Swipe left to delete, swipe right for actions / 左滑删除、右滑操作
- Auto-save via SharedPreferences / 通过 SharedPreferences 自动持久化

---

## Tech Stack / 技术栈

| Category / 类别 | Choice / 选型 |
|-----------------|---------------|
| Framework / 框架 | Flutter (Dart) |
| Platform / 平台 | Android |
| UI | Material Design |
| State / 状态管理 | setState (built-in / 内置) |
| Storage / 存储 | shared_preferences |

---

## Requirements / 环境要求

- Flutter SDK >= 3.x (stable)
- Dart SDK >= 3.11.4
- Android SDK (for building Android apps / 用于构建 Android 应用)

---

## Quick Start / 快速开始

```bash
# Install dependencies / 安装依赖
flutter pub get

# Run the app / 运行应用
flutter run
```

---

## Project Structure / 项目结构

```
naytodo/
├── lib/
│   ├── main.dart                    # Entry point / 入口文件
│   ├── models/
│   │   └── todo_work.dart           # Todo data model / 待办数据模型
│   ├── services/
│   │   └── storage_service.dart     # Persistence layer / 持久化层
│   └── widgets/
│       └── add_todo_dialog.dart     # Add todo dialog / 添加待办对话框
├── android/                         # Android platform config / Android 平台配置
├── test/                            # Tests / 测试代码
├── pubspec.yaml                     # Dependency manifest / 依赖清单
└── analysis_options.yaml
```


