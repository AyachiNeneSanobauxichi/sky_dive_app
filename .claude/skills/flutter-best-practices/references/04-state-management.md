# 04 · 状态管理（Riverpod 3 · @riverpod 代码生成）

> 使用 `flutter_riverpod` 3.x + `riverpod_annotation` + `riverpod_generator`。
> **新代码统一用 `@riverpod` 注解生成 provider**，不再手写 `Provider(...)` / `NotifierProvider(...)`。
>
> ⚠️ **版本锁**：`pubspec.yaml` 里 `flutter_riverpod` 锁 `<3.3.0`、`riverpod_generator` 锁 `<4.0.6`。
> 这两个上限是刻意的，**不许改成 `^`，不许跑 `flutter pub upgrade`**。
> ⚠️ **无 `riverpod_lint`**（当前 Dart 3.10.1 装不上），用法错误没有静态检查兜底，只能靠 review。
> 原委与解锁路径见 `references/12-code-generation.md`。

## 三步走

1. 文件顶部 `import "package:riverpod_annotation/riverpod_annotation.dart";`
2. 声明 `part "<当前文件名>.g.dart";`
3. 改完跑 `dart run build_runner build`（开发期用 `watch`）

## Provider 选型

| 需求 | 写法 | 生成出的 provider |
| --- | --- | --- |
| 依赖注入（Repository、Service） | `@riverpod` + 返回实例的函数 | `xxxProvider` |
| 只读派生值 | `@riverpod` + 纯函数 | `xxxProvider` |
| 常驻不销毁 | `@Riverpod(keepAlive: true)` | `xxxProvider` |
| 带参数（旧 `family`） | 给函数 / `build` 加参数 | `xxxProvider(arg)` |
| 可变 + 同步状态（表单、计数） | `@riverpod class X extends _$X` + `int build()` | `xProvider` |
| 可变 + 异步状态（列表加载、CRUD） | `@riverpod class X extends _$X` + `Future<T> build()` | `xProvider` |

> 异步 / 同步由 `build` 的返回类型自动推断：返回 `Future<T>` 即 AsyncNotifier 形态，
> 类内可用 `state`、`future`、`ref`、`AsyncValue.guard`。

## ⚠️ keepAlive 陷阱（最容易错的一条）

**裸 `@riverpod` 默认是 autoDispose**（生成 `isAutoDispose: true`），监听者归零时 provider
被销毁，下次读取重新执行。**`@Riverpod(keepAlive: true)` 才是常驻**（`isAutoDispose: false`）。

这跟手写 `Provider(...)` 的默认行为**相反**——手写 `Provider` / `AsyncNotifierProvider` 本身就是
常驻的。所以把手写 provider 改成裸 `@riverpod` 会**静默改变生命周期**，编译与 analyze 都不会报错，
只在运行时表现为状态莫名丢失。

**凡是「全局单例 / 持有不可重建状态」的 provider 必须显式 `keepAlive: true`**：

| provider 类型 | 为什么必须 keepAlive |
| --- | --- |
| 内存态 token 持有者 | autoDispose 会丢掉 accessToken → 用户莫名登出 |
| 事件通道（`StreamController`） | 被 dispose 后广播中断，订阅方永远收不到 |
| `Dio` / HTTP 客户端 | 连接被反复关闭重建 |
| `GoRouter` | 重建后导航栈丢失 |
| 全局登录态 Controller | 重跑 `build()` 的启动刷新流程 → 登录态抖动 |
| Repository / DataSource | 无状态可以 autoDispose，但常驻更省重建开销 |

反之，**页面级、按参数取数的 provider 应当保持 autoDispose**（裸 `@riverpod`），
离开页面即释放，避免内存堆积和脏数据。

> 排查手段：生成的 `*.g.dart` 里直接看 `isAutoDispose:` 字段，比读注解更可靠。

## ✅ 应该

- **入口** `runApp` 外层包 `ProviderScope`。
- **provider 靠生成**：注解写在 feature 的 `controllers/` 或 `core/providers/`，
  生成的名字固定是「函数名 / 类名首字母小写 + `Provider`」，不要再手动声明同名变量。
- **函数式 provider 的第一个参数固定是 `Ref ref`**（不是 `XxxRef`——Riverpod 3 已统一为 `Ref`）。
- **Widget** 继承 `ConsumerWidget` / `ConsumerStatefulWidget`，用 `ref.watch` 订阅、`ref.read` 触发动作。
- **异步状态** 用 `AsyncValue<T>`，UI 用 `.when(data/loading/error)` 渲染。
- **修改异步状态** 用 `AsyncValue.guard`，自动把异常收成 `AsyncError`。
- **释放资源** 用 `ref.onDispose(...)`。
- **跨 provider 依赖** 用 `ref.watch(otherProvider)`。
- `*.g.dart` **提交进仓库**，但不手改（`analysis_options.yaml` 已把它排除在 lint 外）。

## ❌ 避免

- ❌ 再手写 `final xxxProvider = Provider<T>((ref) => ...)`——新代码一律走注解。
- ❌ 忘了 `part "xxx.g.dart";` 或忘了跑 `build_runner`（报「Target of URI hasn't been generated」）。
- ❌ 在 `build` 方法里 `ref.read`（应 `watch`；`read` 只用于回调 / 事件处理）。
- ❌ 在 Widget `build` 里做副作用（导航、Toast）——用 `ref.listen`。
- ❌ 用已废弃的 `StateProvider` / `StateNotifierProvider`——用 `Notifier` / `AsyncNotifier`。
- ❌ 把巨型对象塞一个 provider 导致过度重建——按关注点拆分。
- ❌ 用全局单例 / 静态变量代替 provider。
- ❌ 放宽 `pubspec.yaml` 里 riverpod 相关的版本上限。

## 📌 异步可变状态（AsyncNotifier）

```dart
// lib/features/flight/controllers/flight_list_controller.dart
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "flight_list_controller.g.dart";

/// build 返回 Future → 生成 AsyncNotifier 形态，provider 名为 flightListControllerProvider。
@riverpod
class FlightListController extends _$FlightListController {
  @override
  Future<List<Flight>> build() {
    return ref.watch(flightRepositoryProvider).fetchFlights();
  }

  Future<void> add(String title) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(flightRepositoryProvider).create(title);
      return ref.read(flightRepositoryProvider).fetchFlights();
    });
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
```

## 📌 函数式 provider（依赖注入 / 派生）

```dart
part "flight_providers.g.dart";

// 依赖注入：常驻，避免 Repository 被反复重建
@Riverpod(keepAlive: true)
FlightRepository flightRepository(Ref ref) =>
    FlightRepositoryImpl(ref.watch(dioClientProvider));

// 只读派生值
@riverpod
int draftCount(Ref ref) {
  final flights = ref.watch(flightListControllerProvider).valueOrNull ?? const [];
  return stories.where((s) => s.isDraft).length;
}
```

## 📌 带参数（旧 family）

```dart
// 函数式：加参数即可，生成 flightByIdProvider(String id)
@riverpod
Future<Flight> flightById(Ref ref, String id) =>
    ref.watch(flightRepositoryProvider).getById(id);
// 使用：ref.watch(flightByIdProvider("123"))

// Notifier 形态：参数加在 build 上，生成 scopedDraftProvider(String scope)
@riverpod
class ScopedDraft extends _$ScopedDraft {
  @override
  String build(String scope) => scope;

  void update(String v) => state = v;
}
// 使用：ref.watch(scopedDraftProvider("intro"))
```

## 📌 UI 中处理副作用（listen）

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // 副作用放 listen，不要写在 build 主体里
  ref.listen(flightListControllerProvider, (prev, next) {
    if (next case AsyncError(:final error)) {
      SkyToast.error(context, error.toString());
    }
  });
  final flights = ref.watch(flightListControllerProvider);
  return stories.when(
    data: (list) => FlightListView(items: list),
    // 页面级加载态用骨架屏，不用转圈（见 09-theming-ui.md）
    loading: () => const FlightListSkeleton(),
    error: (e, _) => ErrorView(message: e.toString()),
  );
}
```
