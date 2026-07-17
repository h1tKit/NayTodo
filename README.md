# NayTodo

一个简洁的待办事项 Flutter 应用。

## 为什么做这个项目

我自己有使用待办清单的需求。现有的待办应用要么功能过于臃肿，要么界面不够美观。我希望做一个功能简洁、交互流畅、界面干净美观的待办应用，满足自己的日常使用。

## 技术栈

| 类别 | 选型 |
|------|------|
| 框架 | Flutter (Dart) |
| 平台 | Android |
| UI | Material Design |

## 环境要求

- Flutter SDK >= 3.x (stable)
- Dart SDK >= 3.11.4
- Android SDK（用于构建 Android 应用）

## 快速开始

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run
```

## 项目结构

```
naytodo/
├── lib/            # 应用源代码
│   └── main.dart   # 入口文件
├── android/        # Android 平台配置
├── test/           # 测试代码
├── pubspec.yaml    # 依赖清单
└── analysis_options.yaml
```

## Git 工作流

本项目遵循 [doc/git-workflow.md](../doc/git-workflow.md) 中定义的 main 单主干 + feature 分支策略。

提交信息遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/v1.0.0/) 规范，详见 [doc/git-commit-message.md](../doc/git-commit-message.md)。
