# 00 · 总览与核心原则

## 技术栈（以 `pubspec.yaml` 为准）

| 领域 | 库 | 版本 | 说明 |
| --- | --- | --- | --- |
| 状态管理 | `flutter_riverpod` | 3.3.x | **手写 Provider**（工具链不支持 codegen，见 04） |
| 网络 | `dio` + `pretty_dio_logger` + `connectivity_plus` | 5.10.x | 统一 `DioClient` |
| 数据模型 | `freezed` + `json_serializable` + `*_annotation` | 3.2.x / 6.11.x | 不可变模型 + JSON |
| 路由 | `go_router` | 17.3.x | 声明式路由 |
| 配置 | `flutter_dotenv` | 6.0.x | `.env` 环境变量 |
| 日志 | `logger` | 2.7.x | 统一 `AppLogger` |
| 国际化 | `intl` | 0.20.x | 日期/数字/文案 |
| 图片 | `cached_network_image` | 3.4.x | 网络图缓存 |
| Lint | `flutter_lints` | 6.0.x | 基线规则 |
| 代码生成 | `build_runner` | 2.15.x | freezed/json（**不含 riverpod**） |

> Dart SDK: `^3.10.1`。使用现代语法（records、patterns、sealed class、switch 表达式）。

## 核心原则（Golden Rules）

1. **Feature-First + 分层清晰**：功能内聚在 `lib/features/<feature>/`，跨功能能力放 `lib/core/` 与 `lib/shared/`。
2. **不可变优先**：模型用 Freezed；状态用不可变对象，通过 `copyWith` 更新。
3. **单向数据流**：UI → Controller(Notifier) → Repository → DataSource；反向只通过状态回流。
4. **显式错误处理**：网络/数据层抛 `AppException`，向上转换为 `Failure`；UI 层用 `AsyncValue` 渲染。
5. **模型代码生成**：Freezed / JSON 用注解 + `build_runner`；⚠️ Riverpod provider 因当前工具链无法运行 `riverpod_generator` 而**手写**（见 `04-state-management.md` 与 `agent/study/riverpod-codegen-issue.md`）。
6. **Barrel 导出**：每个目录维护 `index.dart`，对外只暴露 barrel。
7. **零 Lint 警告**：提交前 `flutter analyze` 必须干净。
8. **不在 UI 写业务逻辑**：Widget 只负责渲染与交互转发。

## 全局代码风格

- **字符串**：使用**双引号** `"..."`（`analysis_options.yaml` 已配置 `prefer_double_quotes: true`）。
- **const 优先**：能 `const` 的 Widget/构造一律加 `const`。
- **导入顺序**：`dart:` → `package:`（第三方）→ `package:happy_os/`（本项目）→ 相对导入，组间空行。
- **行宽**：遵循 `dart format` 默认（80 列），不要手动关闭格式化。
- **禁止** `print()`，统一用 `AppLogger`（见 `10-storage-security.md` / utils）。

### 注释规范

- **关键函数 / 复杂逻辑必须写注释**：讲清「意图 / 为什么这么做」，而非复述代码字面；公共 API、非直观算法、边界处理与临时兜底都要注释。
- **UI 代码注释保持简洁**：一句话点明这块 UI 的作用或某个不直观参数的原因即可（如 `// loading 时置空 onPressed：防重复提交`），不逐行解释布局。
- 公共类 / 方法用 `///` 文档注释；局部原因用 `//` 行内注释。注释随代码同步更新，删代码要删对应注释，不留失效 / 误导注释。

### 禁止魔法值（尺寸 / 字体 / 颜色）

> 项目**不允许**魔法数字、内联字体、硬编码颜色，一律用全局令牌。

- **尺寸 / 间距 / 圆角** → `HappySpacing` / `HappyRadius`，不写裸数值（`16`、`12`…）。
- **颜色** → `Theme.of(context).colorScheme`（组件层）或 `HappyColors`（仅供 `app_theme` 组装），禁止 `Color(0xFF...)` 散落各处。
- **文字样式** → `Theme.of(context).textTheme` 或 `HappyTextStyles` 令牌，禁止内联 `TextStyle(fontSize: ..., fontWeight: ...)`。

```dart
// ❌ 禁止：魔法字号 + 内联字体
textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// ✅ 用全局文字令牌
textStyle: Theme.of(context).textTheme.labelLarge,
```

## 快速决策表

| 场景 | 用什么 |
| --- | --- |
| 需要一个可变的、带异步加载的状态 | 手写 `AsyncNotifierProvider` + `class Xxx extends AsyncNotifier<T>` |
| 只读派生值 | 手写 `final xxxProvider = Provider<T>((ref) {...})` |
| 一次性依赖（如 Repository） | 手写 `final xxxRepositoryProvider = Provider<Xxx>((ref) => ...)` |
| 定义数据结构 | Freezed `abstract class` |
| 定义多态/状态机 | Freezed `sealed class` union |
| 页面跳转 | `context.goNamed` / `context.pushNamed` + `RouteName` 常量 |
| 调接口 | 通过 feature 的 `data/` Repository，内部用 `DioClient` |
