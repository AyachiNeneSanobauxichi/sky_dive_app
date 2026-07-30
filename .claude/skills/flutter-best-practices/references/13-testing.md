# 13 · 测试

> 测试放在 `test/`，镜像 `lib/` 目录结构。金字塔：**单元测试（多）> Widget 测试（中）> 集成测试（少）**。

## 目录约定

```text
test/
├── features/
│   └── todo/
│       ├── data/todo_repository_impl_test.dart
│       ├── controllers/todo_list_controller_test.dart
│       └── screens/todo_list_screen_test.dart
└── core/
    └── network/dio_client_test.dart
```

## ✅ 应该

- **命名**：被测文件 + `_test.dart`；测试镜像源码路径。
- **单元测试** 覆盖 Repository 映射逻辑、Failure 转换、纯函数/扩展。
- **Riverpod 测试** 用 `ProviderContainer` + `overrides` 注入 mock repository。
- **Widget 测试** 用 `ProviderScope(overrides: ...)` 包裹，验证渲染与交互。
- **AAA 结构**：Arrange / Act / Assert，一个测试只验证一件事。
- **mock 依赖** 边界（网络、存储），不 mock 被测对象自身。
- CI 跑 `flutter test --coverage`，核心业务逻辑覆盖率有下限要求。

## ❌ 避免

- ❌ 测试里打真实网络/真实后端。
- ❌ 一个 test 断言一堆无关点。
- ❌ 依赖测试执行顺序 / 共享可变全局状态。
- ❌ 只测 getter/setter 凑覆盖率。

## 📌 Controller 单元测试（override + mock）

```dart
class _FakeTodoRepo implements TodoRepository {
  @override
  Future<List<Todo>> fetchTodos() async => const [Todo(id: "1", title: "a")];
  @override
  Future<Todo> create(String title) async => Todo(id: "2", title: title);
}

void main() {
  test("build 返回仓库数据", () async {
    final container = ProviderContainer(overrides: [
      todoRepositoryProvider.overrideWithValue(_FakeTodoRepo()),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(todoListControllerProvider.future);
    expect(result, hasLength(1));
    expect(result.first.title, "a");
  });
}
```

## 📌 Widget 测试

```dart
testWidgets("空列表显示提示", (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(_EmptyRepo())],
      child: const MaterialApp(home: TodoListScreen()),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text("暂无待办"), findsOneWidget);
});
```
