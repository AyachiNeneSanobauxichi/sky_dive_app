# 00 · 总览与核心原则

## 技术栈（以 `pubspec.yaml` 为准）

| 领域 | 库 | 版本 | 说明 |
| --- | --- | --- | --- |
| 状态管理 | `flutter_riverpod` | 3.1.x（上限锁 `<3.3.0`） | `@riverpod` 注解 + 生成 |

> Dart SDK: `^3.10.1`。使用现代语法（records、patterns、sealed class、switch 表达式）。

## 核心原则（Golden Rules）

1. **Feature-First + 分层清晰**：功能内聚在 `lib/features/<feature>/`，跨功能能力放 `lib/core/` 与 `lib/shared/`。
2. **不可变优先**：模型用 Freezed；状态用不可变对象，通过 `copyWith` 更新。
3. **单向数据流**：UI → Controller(Notifier) → Repository → DataSource；反向只通过状态回流。
4. **显式错误处理**：网络/数据层抛 `AppException`，向上转换为 `Failure`；UI 层用 `AsyncValue` 渲染。
5. **代码生成**：Freezed / JSON / **Riverpod provider** 全部用注解 + `build_runner`；⚠️ riverpod 相关版本上限已锁死，勿放宽（见 `references/12-code-generation.md`）。
6. **Barrel 导出**：每个目录维护 `index.dart`，对外只暴露 barrel。
7. **零 Lint 警告**：提交前 `flutter analyze` 必须干净。
8. **不在 UI 写业务逻辑**：Widget 只负责渲染与交互转发。

## 全局代码风格

- **字符串**：使用**双引号** `"..."`（`analysis_options.yaml` 已配置 `prefer_double_quotes: true`）。
- **const 优先**：能 `const` 的 Widget/构造一律加 `const`。
- **导入顺序**：`dart:` → `package:`（第三方）→ `package:sky_dive/`（本项目）→ 相对导入，组间空行。
- **行宽**：遵循 `dart format` 默认（80 列），不要手动关闭格式化。
- **禁止** `print()`，统一用 `AppLogger`（见 `10-storage-security.md` / utils）。

### 注释规范

- **关键函数 / 复杂逻辑必须写注释**：讲清「意图 / 为什么这么做」，而非复述代码字面；公共 API、非直观算法、边界处理与临时兜底都要注释。
- **UI 代码注释保持简洁**：一句话点明这块 UI 的作用或某个不直观参数的原因即可（如 `// loading 时置空 onPressed：防重复提交`），不逐行解释布局。
- 公共类 / 方法用 `///` 文档注释；局部原因用 `//` 行内注释。注释随代码同步更新，删代码要删对应注释，不留失效 / 误导注释。

### 禁止魔法值（尺寸 / 字体 / 颜色）

> 项目**不允许**魔法数字、内联字体、硬编码颜色，一律用全局令牌。

- **间距** → `SkySemanticSpacing`（`screenPadding`/`cardPadding`/`sectionGap`…，优先）或 `SkySpacing`（`s4`/`s8`/`s16`… 4pt 数值刻度），不写裸数值。
- **圆角 / 描边 / 图标 / 控件高度** → `SkyRadius` / `SkyBorderWidth` / `SkyIconSize` / `SkyControlSize`。
- **颜色** → `Theme.of(context).colorScheme`。`SkyColors` 只给 `app_theme` / `app_gradients` / `app_shadows` 当原料，**业务层禁止直接引用**。
- **文字样式** → `Theme.of(context).textTheme`，禁止内联 `TextStyle(fontSize: ..., fontWeight: ...)`。
- **渐变 / 阴影 / 光晕** → `SkyGradients` / `SkyShadows`。
- **动效时长与曲线** → `SkyMotion`，禁止 `Duration(milliseconds: 300)`、`Curves.easeInOut` 字面量。

```dart
// ❌ 禁止：魔法字号 + 内联字体 + 裸数值间距
textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
padding: const EdgeInsets.all(16),
// ✅ 用全局令牌
style: Theme.of(context).textTheme.labelLarge,
padding: const EdgeInsets.all(SkySemanticSpacing.cardPadding),
```

> 完整令牌清单与用法见 `09-theming-ui.md`。

## 快速决策表

| 场景 | 用什么 |
| --- | --- |
| 需要一个可变的、带异步加载的状态 | `@riverpod class Xxx extends _$Xxx` + `Future<T> build()` |
| 只读派生值 | `@riverpod T xxx(Ref ref) {...}` |
| 一次性依赖（如 Repository） | `@Riverpod(keepAlive: true) Xxx xxxRepository(Ref ref) => ...` |
| 定义数据结构 | Freezed `abstract class` |
| 定义多态/状态机 | Freezed `sealed class` union |
| 页面跳转 | `context.goNamed` / `context.pushNamed` + `RouteName` 常量 |
| 调接口 | 通过 feature 的 `data/` Repository，内部用 `DioClient` |
