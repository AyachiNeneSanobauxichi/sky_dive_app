---
name: flutter-best-practices
description: >-
  happy_os 的 Flutter 工程规范（企业级最佳实践）。在本仓库编写、修改或审查任何
  Dart/Flutter 代码时使用：涉及 Riverpod 状态管理、Freezed 数据模型、Dio 网络层、
  go_router 路由、错误处理、主题/UI、存储与安全、国际化、build_runner 代码生成、
  测试、性能、命名与目录结构、Git 提交规范时，先读对应的 references/ 模块再动手。
---

# Flutter 工程规范（happy_os）

本 skill 是本仓库 Flutter 开发的**权威规范**。编码前先读 `references/00-overview.md`，再按任务领域读对应模块。

## 🚦 首要红线（务必遵守）

1. 字符串用**双引号** `"..."`（`prefer_double_quotes: true`）。
2. 状态管理用 **Riverpod 3**（`flutter_riverpod`）。**新代码用 `@riverpod` 注解 + `riverpod_generator` 生成**（已实测可用）；模型用 **Freezed 3** + `build_runner`。⚠️ `pubspec.yaml` 里 `flutter_riverpod` 上限锁 `<3.3.0`、`riverpod_generator` 上限锁 `<4.0.6`，**这两个上限不许改成 `^`，也不要跑 `flutter pub upgrade`**，否则解算立刻失败。⚠️ `riverpod_lint` 在当前 Dart 3.10.1 下无解、未安装，provider 用法错误只能靠 review 兜。原委与解锁路径见 `references/12-code-generation.md`。
3. 严格 **feature-first + 分层**：`data / domain / controllers / screens / widgets`，依赖单向向下（domain 不依赖 data）。
4. 网络只通过 `core/network/DioClient`；错误统一 `AppException → Failure → AsyncValue`。
5. 每个目录维护 `index.dart` barrel；对外只经 barrel 引用。
6. 提交前 `dart format` + `flutter analyze`（零告警）+ `flutter test`。禁止 `print`（用 `AppLogger`）。
7. **关键函数/复杂逻辑必须写注释**（讲意图/为什么）；UI 代码注释保持简洁。
8. **禁止魔法值**：间距用 `HappySemanticSpacing`/`HappySpacing`（`s16` 式数值命名），圆角/描边/图标/控件高度用 `HappyRadius`/`HappyBorderWidth`/`HappyIconSize`/`HappyControlSize`，颜色用 `colorScheme`（业务层**禁止**直接引 `HappyColors`），文字用 `textTheme`，渐变/阴影用 `HappyGradients`/`HappyShadows`，动效时长与曲线用 `HappyMotion`；禁止内联 `TextStyle(fontSize: ...)`、`Color(0xFF...)`、裸数值尺寸、`Duration(milliseconds: ...)`。详见 `references/09-theming-ui.md`。
9. **页面文案禁止硬编码**：用户可见文案一律走国际化（gen-l10n `AppLocalizations`/ARB），`screens/`·`widgets/` 内不得出现中/英文字面量。
10. **agent 生成边界**：依业务文档（`*_page.md`/`*_api.md`）生成的代码**只写业务层**，**禁止改动 infra**（`core/`、`app/router`、`theme/`、`DioClient`、工程配置等）；确有必要必须停下重点询问、由人工操作。`agent/infra/*` 文档只写 infra。**`_api.md` 只生成接口定义相关代码**（`data/` DTO/数据源/仓库 + 对应 `domain/` 实体），**`_page.md` 才生成 UI 与业务**（`screens/`·`widgets/`·`controllers/`）；不得跨文档越界。业务文档须遵循 `_page`/`_api` 拆分 + `## vN` 版本化书写模式。详见 `references/16-agent-workflow.md`。
11. **加载与轻提示**：接口 / 页面级加载态用**骨架屏**（`skeletonizer`），不用 loading 转圈（按钮内联忙碌态例外）；用户轻提示统一走 **`HappyToast`**（`lib/shared/widgets/toast/`），禁止直接 `ScaffoldMessenger.showSnackBar` 或裸调 `toastification`。详见 `references/09-theming-ui.md`。
12. **自定义全局组件加 `Happy` 前缀**：下沉到 `lib/shared/widgets/` 的通用组件 / 封装类，类名一律 `Happy` 前缀、文件 `happy_*.dart`（如 `HappyButton`、`HappyToast`）；feature 私有业务组件**不加**前缀。详见 `references/03-naming-conventions.md`。
13. **交互体验是本项目第一优先级**（C 端「AI 聊天生成爽文」app，UI 为重中之重）：① 每个交互四时刻都要有反馈（按下=视觉+触感 / 等待=进行态且不可重复触发 / 成功=结果可见 / 失败=说清下一步）；② 异步界面**加载(骨架) · 空(带引导行动) · 错误(带重试) · 有数据**四态必须齐全，接口没就绪也要用 mock 跑通全链路；③ 热区 ≥44、防重复提交、危险操作可确认/可撤销、键盘不遮挡输入、动效只取 `HappyMotion` 且不阻塞交互；④ **每次生成/改动 UI 后必须在回复里附 1–3 条「UI / 交互建议」**（改什么、为什么更好、代价），发现更优方案要主动提醒而不是闷头照文档实现。详见 `references/17-ux-interaction.md`。

## 🔧 常用命令

```bash
flutter pub get
dart run build_runner build   # 改了 freezed / json / @riverpod 注解后
dart run build_runner watch   # 开发期自动生成
dart format .
flutter analyze
flutter test
```

## 📚 领域模块（按需读 references/）

| 任务领域 | 参考文件 |
| --- | --- |
| 技术栈与核心原则、代码风格 | `references/00-overview.md` |
| 目录结构（feature-first） | `references/01-project-structure.md` |
| 分层架构（Clean Architecture） | `references/02-architecture.md` |
| 命名规范 | `references/03-naming-conventions.md` |
| Riverpod 3 状态管理 | `references/04-state-management.md` |
| Dio 网络层 | `references/05-networking.md` |
| Freezed 数据模型 | `references/06-data-models.md` |
| go_router 路由 | `references/07-routing.md` |
| 错误处理 | `references/08-error-handling.md` |
| 主题与 UI | `references/09-theming-ui.md` |
| 存储/配置/安全 | `references/10-storage-security.md` |
| 国际化 | `references/11-i18n-localization.md` |
| build_runner 代码生成 | `references/12-code-generation.md` |
| 测试 | `references/13-testing.md` |
| 性能 | `references/14-performance.md` |
| Git 与质量门禁 | `references/15-git-and-quality.md` |
| Agent 文档驱动工作流（业务/infra 边界、mock、TODO、_page/_api） | `references/16-agent-workflow.md` |
| **交互体验（C 端第一优先级：反馈四时刻、异步四态、触感、键盘、动效、无障碍）** | `references/17-ux-interaction.md` |

## ✅ 工作流约定

- 新增功能前，先读 `01`（结构）+ `02`（架构）+ 相关领域模块，再动手。
- **写任何 UI（`screens/` `widgets/`）前必读 `09`（视觉令牌）+ `17`（交互体验）**——本项目是 C 端产品，交互体验优先级高于"功能能跑通"。
- 生成/修改带注解的文件后，**立即**运行 `build_runner`，再继续。
- 完成后自检：barrel 导出补齐、`flutter analyze` 干净、无敏感信息入库。

> 同源提醒：本 skill 与 `.cursor/rules/*.mdc` 是同一套规范的两种表达（Claude 用 skill，Cursor 用 rules）。改规范时两处都要更新，见 `.cursor/rules/sync.mdc`。
