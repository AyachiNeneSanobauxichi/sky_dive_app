# 02 · 架构分层（Clean Architecture · Feature-First）

## 分层职责

| 层 | 目录 | 职责 | 依赖 |
| --- | --- | --- | --- |
| Presentation | `screens/` `widgets/` | 渲染 UI、转发用户交互、`watch` 状态 | controllers |
| Application | `controllers/` `presentation/` | 表现逻辑、编排用例、持有 UI 状态 | domain |
| Domain | `domain/` | 业务实体、Repository 抽象、纯业务规则 | 无（最内层） |
| Data | `data/` | Repository 实现、DataSource、DTO ↔ Entity 映射 | domain, core/network |

> 依赖倒置：`domain` 定义接口，`data` 实现接口，`controllers` 依赖 `domain` 接口（通过 provider 注入实现）。

## ✅ 应该

- **Domain 纯净**：`domain` 里不出现 `dio`、`flutter`、`json` 等技术细节，只有实体与抽象。
- **DTO 与 Entity 分离**：`data/` 用 DTO 承接接口 JSON，映射为 `domain/` 的 Entity 后再向上传递。
- **Repository 抽象在 domain，实现在 data**，通过 Riverpod provider 绑定。
- **Controller 只做编排**：调用 repository、转换为 `AsyncValue` 状态、暴露操作方法。

## ❌ 避免

- ❌ 在 `screens/` 直接 `new Dio()` 或直接调用 DataSource。
- ❌ 把接口 JSON 结构（DTO）直接当作 UI 使用的 Entity 到处传。
- ❌ Controller 里写网络/序列化细节。
- ❌ domain 依赖 data。

## 📌 一个 feature 的标准装配（以 `todo` 为例）

**domain 抽象：**

```dart
// lib/features/todo/domain/todo_repository.dart
abstract interface class TodoRepository {
  Future<List<Todo>> fetchTodos();
  Future<Todo> create(String title);
}
```

**data 实现：**

```dart
// lib/features/todo/data/todo_repository_impl.dart
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._client);
  final DioClient _client;

  @override
  Future<List<Todo>> fetchTodos() async {
    final res = await _client.get<List<dynamic>>("/todos");
    return res.map((e) => TodoDto.fromJson(e as Map<String, dynamic>).toEntity()).toList();
  }

  @override
  Future<Todo> create(String title) async {
    final res = await _client.post<Map<String, dynamic>>("/todos", data: {"title": title});
    return TodoDto.fromJson(res).toEntity();
  }
}
```

**provider 绑定（依赖注入）：**

```dart
// lib/features/todo/data/todo_providers.dart（手写 provider）
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepositoryImpl(ref.watch(dioClientProvider)),
);
```

**controller 编排：**

```dart
// lib/features/todo/controllers/todo_list_controller.dart（手写 provider）
final todoListControllerProvider =
    AsyncNotifierProvider<TodoListController, List<Todo>>(
  TodoListController.new,
);

class TodoListController extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() => ref.watch(todoRepositoryProvider).fetchTodos();

  Future<void> add(String title) async {
    final repo = ref.read(todoRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.create(title);
      return repo.fetchTodos();
    });
  }
}
```

**screen 消费：**

```dart
// lib/features/todo/screens/todo_list_screen.dart
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListControllerProvider);
    return todos.when(
      data: (list) => TodoListView(items: list),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(message: e.toString()),
    );
  }
}
```

> 用例（UseCase）层为**可选**：简单 CRUD 直接在 controller 调 repository；复杂跨 repository 的业务规则时再引入 `domain/usecases/`。
