# 04 · 状态管理（Riverpod 3 · 手写 Provider）

> 使用 `flutter_riverpod` 3.x。**⚠️ 本仓库 provider/notifier 一律手写**（`Provider` / `NotifierProvider` / `AsyncNotifierProvider` 等），**不用 `@riverpod` 注解与代码生成**——当前 Flutter SDK 工具链无法运行 `riverpod_generator`（analyzer/meta 版本冲突）。原因、报错细节与「注解 vs 手写」对照见 `agent/study/riverpod-codegen-issue.md`。运行时用法（`ref.watch/read/listen`、`AsyncValue`）与注解写法完全一致。

## Provider 选型

| 需求 | 写法（手写） |
| --- | --- |
| 依赖注入（Repository、Service） | `final xxxProvider = Provider<Xxx>((ref) => ...);` |
| 只读派生值 | `final xxxProvider = Provider<T>((ref) { ... });` |
| 可变 + 异步状态（列表加载、CRUD） | `AsyncNotifierProvider<C, T>(C.new)` + `class C extends AsyncNotifier<T>` |
| 可变 + 同步状态（表单） | `NotifierProvider<C, T>(C.new)` + `class C extends Notifier<T>` |
| 需要参数 | `Provider.family<T, Arg>(...)` / `AsyncNotifierProvider.family<...>(...)` |

## ✅ 应该

- **入口** `runApp` 外层包 `ProviderScope`。
- **provider 手写声明**：`final xxxProvider = ...;` 放在 feature 的 `controllers/` 或 `core/providers/`，命名统一 `xxxProvider`。
- **Widget** 继承 `ConsumerWidget` / `ConsumerStatefulWidget`，用 `ref.watch` 订阅、`ref.read` 触发动作。
- **异步状态** 用 `AsyncValue<T>`，在 UI 用 `.when(data/loading/error)` 渲染。
- **修改异步状态** 用 `AsyncValue.guard`，自动捕获异常为 `AsyncError`。
- **释放资源** 用 `ref.onDispose(...)`。
- **跨 provider 依赖** 用 `ref.watch(otherProvider)`。

## ❌ 避免

- ❌ 使用 `@riverpod` 注解 / `part "xxx.g.dart"` / `extends _$Xxx`（本仓库无生成器，编译不过）。
- ❌ 在 `build` 方法里 `ref.read`（应 `watch`，`read` 只用于回调/事件处理）。
- ❌ 在 Widget `build` 里做副作用（导航、SnackBar）——用 `ref.listen`。
- ❌ 用已废弃的 `StateProvider` / `StateNotifierProvider` 表达可变状态——用 `Notifier` / `AsyncNotifier`。
- ❌ 把整个巨型对象放一个 provider 导致过度重建——按关注点拆分。
- ❌ 用全局单例/静态变量代替 provider。

## 📌 AsyncNotifier（异步可变状态）

```dart
// lib/features/todo/controllers/todo_list_controller.dart
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/features/todo/domain/index.dart";

// 手写 provider：AsyncNotifierProvider<Notifier 类型, 状态类型>(构造引用)
final todoListControllerProvider =
    AsyncNotifierProvider<TodoListController, List<Todo>>(
  TodoListController.new,
);

class TodoListController extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() {
    return ref.watch(todoRepositoryProvider).fetchTodos();
  }

  Future<void> add(String title) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).create(title);
      return ref.read(todoRepositoryProvider).fetchTodos();
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
// 依赖注入
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepositoryImpl(ref.watch(dioClientProvider)),
);

// 只读派生值
final uncompletedCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todoListControllerProvider).valueOrNull ?? const [];
  return todos.where((t) => !t.completed).length;
});
```

## 📌 UI 中处理副作用（listen）

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(todoListControllerProvider, (prev, next) {
    if (next case AsyncError(:final error)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  });
  final todos = ref.watch(todoListControllerProvider);
  return todos.when(
    data: (list) => TodoListView(items: list),
    loading: () => const LoadingView(),
    error: (e, _) => ErrorView(message: e.toString()),
  );
}
```

## 📌 带参数（family）

```dart
final todoDetailProvider = Provider.family<Future<Todo>, String>(
  (ref, id) => ref.watch(todoRepositoryProvider).getById(id),
);
// 使用：ref.watch(todoDetailProvider("123"))
```
