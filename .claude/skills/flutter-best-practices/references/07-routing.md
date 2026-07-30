# 07 · 路由（go_router 17）

> 使用 `go_router` 声明式路由；`GoRouter` 由 provider 暴露；路由名/路径集中在 `route_name.dart`；鉴权用 `redirect`。

## ✅ 应该

- **路由名与路径** 集中定义为常量（`RouteName`），页面跳转只用 `goNamed/pushNamed` + 常量，不写裸字符串。
- **GoRouter 由 provider 提供**，便于依赖鉴权状态做 `refreshListenable` / `redirect`。
- **`app.dart`** 用 `MaterialApp.router(routerConfig: ...)` 装配。
- **参数** 用 `pathParameters` / `queryParameters` / `extra` 传递；`extra` 只传运行期对象，不用于深链接必需数据。
- **鉴权守卫** 集中在 `route_guard.dart` 的 `redirect` 中。
- **错误路由** 提供 `errorBuilder`。

## ❌ 避免

- ❌ 到处 `Navigator.push(MaterialPageRoute(...))` 绕过 go_router。
- ❌ 硬编码路径字符串 `context.go("/todos/123")`。
- ❌ 把鉴权判断分散写在各个页面 `initState`。
- ❌ 用 `extra` 传递深链接/刷新后必须恢复的数据。

## 📌 路由常量

```dart
// lib/app/router/route_name.dart
abstract final class RouteName {
  static const login = "login";
  static const todos = "todos";
  static const todoDetail = "todoDetail";
}

abstract final class RoutePath {
  static const login = "/login";
  static const todos = "/todos";
  static const todoDetail = "/todos/:id";
}
```

## 📌 路由表

```dart
// lib/app/router/routes.dart
final List<RouteBase> appRoutes = [
  GoRoute(
    name: RouteName.login,
    path: RoutePath.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RouteName.todos,
    path: RoutePath.todos,
    builder: (context, state) => const TodoListScreen(),
    routes: [
      GoRoute(
        name: RouteName.todoDetail,
        path: ":id",
        builder: (context, state) =>
            TodoDetailScreen(id: state.pathParameters["id"]!),
      ),
    ],
  ),
];
```

## 📌 GoRouter provider + 鉴权 redirect

```dart
// lib/app/router/app_router.dart（手写 provider）
final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: RoutePath.todos,
    routes: appRoutes,
    redirect: (context, state) => guardRedirect(auth, state),
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
```

```dart
// lib/app/router/route_guard.dart
String? guardRedirect(AuthState auth, GoRouterState state) {
  final loggingIn = state.matchedLocation == RoutePath.login;
  final loggedIn = auth is Authenticated;
  if (!loggedIn && !loggingIn) return RoutePath.login;
  if (loggedIn && loggingIn) return RoutePath.todos;
  return null;
}
```

## 📌 装配到 App

```dart
// lib/app/app.dart
class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
```

## 📌 跳转写法

```dart
context.goNamed(RouteName.todos);                       // 替换栈
context.pushNamed(RouteName.todoDetail, pathParameters: {"id": todo.id}); // 入栈
```
