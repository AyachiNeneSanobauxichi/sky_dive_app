# CLAUDE.md — happy_os 工程规范

本文件是 Claude 在本仓库工作的入口约定（位于 `.claude/`，由 Claude Code 自动加载）。**详细规范以 skill 形式维护：`flutter-best-practices`（`.claude/skills/flutter-best-practices/`），是唯一权威来源。** 编写/修改/审查 Dart/Flutter 代码时按需读取该 skill 的 `references/` 模块。

## 🚦 首要红线（务必遵守）

1. 字符串用**双引号** `"..."`（`prefer_double_quotes: true`）。
2. 状态管理用 **Riverpod 3**（`flutter_riverpod`）。**新代码用 `@riverpod` 注解 + `riverpod_generator` 生成**（已实测可用）；模型用 **Freezed 3** + `build_runner`。⚠️ `pubspec.yaml` 里 `flutter_riverpod` 上限锁 `<3.3.0`、`riverpod_generator` 上限锁 `<4.0.6`，**这两个上限不许改成 `^`，也不要跑 `flutter pub upgrade`**，否则解算立刻失败。⚠️ `riverpod_lint` 在当前 Dart 3.10.1 下无解、未安装，provider 用法错误只能靠 review 兜。原委与解锁路径见 `references/12-code-generation.md`。
3. 严格 **feature-first + 分层**：`data / domain / controllers / screens / widgets`，依赖单向向下。
4. 网络只通过 `core/network/DioClient`；错误统一 `AppException → Failure → AsyncValue`。
5. 每个目录维护 `index.dart` barrel；对外只经 barrel 引用。
6. 提交前 `dart format` + `flutter analyze`（零告警）+ `flutter test`。禁止 `print`。
7. **关键函数/复杂逻辑必须写注释**（讲意图/为什么）；UI 代码注释保持简洁。
8. **禁止魔法值**：间距用 `HappySemanticSpacing`/`HappySpacing`（`s16` 式数值命名），圆角/描边/图标/控件高度用 `HappyRadius`/`HappyBorderWidth`/`HappyIconSize`/`HappyControlSize`，颜色用 `colorScheme`（业务层**禁止**直接引 `HappyColors`），文字用 `textTheme`，渐变/阴影用 `HappyGradients`/`HappyShadows`，动效时长与曲线用 `HappyMotion`；禁止内联 `TextStyle(fontSize: ...)`、`Color(0xFF...)`、裸数值尺寸、`Duration(milliseconds: ...)`。详见 `references/09-theming-ui.md`。
9. **页面文案禁止硬编码**：用户可见文案一律走国际化（gen-l10n `AppLocalizations`/ARB），`screens/`·`widgets/` 内不得出现中/英文字面量。
10. **agent 生成边界**：依业务文档（`*_page.md`/`*_api.md`）生成的代码**只写业务层**，**禁止改动 infra**（`core/`、`app/router`、`theme/`、`DioClient`、工程配置等）；确有必要必须停下重点询问、由人工操作。`agent/infra/*` 文档只写 infra。**`_api.md` 只生成接口定义相关代码**（`data/` DTO/数据源/仓库 + 对应 `domain/` 实体），**`_page.md` 才生成 UI 与业务**（`screens/`·`widgets/`·`controllers/`）；不得跨文档越界。业务文档须遵循 `_page`/`_api` 拆分 + `## vN` 版本化书写模式（详见 `references/16-agent-workflow.md`）。
11. **无真实接口用 mock**：暂无后端时在 feature 的 `data/mock/` 建 mock 数据跑通逻辑，**接入真实接口后立即删除** mock 文件夹；不确定处一律加带描述的 `TODO(<scope>): ...`。
12. **沟通语言**：给用户的所有回答一律用**中文**（代码、标识符、必要的英文术语除外）。
13. **加载与轻提示**：接口 / 页面级加载态用**骨架屏**（`skeletonizer`），不用 loading 转圈（按钮内联忙碌态例外）；用户轻提示统一走 **`HappyToast`**（`lib/shared/widgets/toast/`），禁止直接 `ScaffoldMessenger.showSnackBar` 或裸调 `toastification`。详见 `references/09-theming-ui.md`。
14. **自定义全局组件加 `Happy` 前缀**：下沉到 `lib/shared/widgets/` 的通用组件 / 封装类，类名一律 `Happy` 前缀、文件 `happy_*.dart`（如 `HappyButton`、`HappyToast`）；feature 私有业务组件**不加**前缀。详见 `references/03-naming-conventions.md`。

## 📚 详细规范

完整规范见 skill **`flutter-best-practices`**，编码前先读 `references/00-overview.md`，再按任务领域读对应模块（结构/架构/Riverpod/Dio/Freezed/路由/错误/UI/存储/国际化/代码生成/测试/性能/命名/Git/Agent 工作流）。表单校验统一用 `form_builder_validators`。**按 `agent/` 文档生成代码前，先读 `references/16-agent-workflow.md`。**

## 🔧 常用命令

```bash
flutter pub get
dart run build_runner build   # 改了 freezed / json / @riverpod 注解后
dart run build_runner watch   # 开发期自动生成
dart format .
flutter analyze
flutter test
```

## 🔁 规范同步（skill ↔ rules）

- 同一套规范有两种表达：Claude 用 skill（`.claude/skills/flutter-best-practices/`），Cursor 用 rules（`.cursor/rules/*.mdc`，内容自包含）。
- 改规范/新增约定：**两处都要更新**，保持内容一致；新增领域时补 skill 的 `references/<nn-xxx>.md`（并在 `SKILL.md` 索引加行）+ 对应 `.cursor/rules/<xxx>.mdc`。
- 详见 `.cursor/rules/sync.mdc`。
