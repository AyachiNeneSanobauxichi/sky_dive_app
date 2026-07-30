# 03 · 命名规范

## 文件与目录

| 类型 | 规则 | 示例 |
| --- | --- | --- |
| 文件名 | `snake_case.dart` | `todo_list_controller.dart` |
| 目录名 | `snake_case`（单数领域名） | `features/todo/` |
| Barrel | 固定 `index.dart` | `data/index.dart` |
| 测试文件 | 被测文件名 + `_test.dart` | `todo_repository_impl_test.dart` |
| 生成文件 | `*.g.dart` / `*.freezed.dart` | 由 build_runner 生成，勿手改 |

## 标识符

| 类型 | 规则 | 示例 |
| --- | --- | --- |
| 类 / 枚举 / 扩展 / typedef | `UpperCamelCase` | `TodoRepository`, `AppException` |
| 变量 / 方法 / 参数 | `lowerCamelCase` | `fetchTodos`, `isLoading` |
| 常量 | `lowerCamelCase`（`const`） | `defaultTimeout` |
| 私有成员 | 前缀 `_` | `_client`, `_parse()` |
| 布尔量 | `is/has/can/should` 前缀 | `isEnabled`, `hasError` |
| Riverpod 生成 provider | 由类/函数名派生 | `TodoListController` → `todoListControllerProvider` |

## 组件命名约定（按角色后缀）

| 角色 | 后缀 | 示例 |
| --- | --- | --- |
| 路由页面 | `Screen` | `LoginScreen`, `TodoListScreen` |
| 抽象仓库 | `Repository` | `AuthRepository` |
| 仓库实现 | `RepositoryImpl` | `AuthRepositoryImpl` |
| 远程/本地数据源 | `RemoteDataSource` / `LocalDataSource` | `TodoRemoteDataSource` |
| 数据传输对象 | `Dto` | `TodoDto` |
| 领域实体 | 无后缀（纯名词） | `Todo`, `User` |
| 控制器/状态机 | `Controller` 或 `Notifier` | `TodoListController` |
| UI 状态类 | `State` | `LoginState` |
| 全局通用组件 | `Happy` 前缀 + 语义名词 | `HappyButton`, `HappyCheckbox` |

## 项目专有约定（本仓库 · Happy 体系）

> 从现有代码反向沉淀的约定，新增代码须遵循。

| 场景 | 约定 | 示例 |
| --- | --- | --- |
| 全局复用 UI 组件 | 类名加 `Happy` 前缀；文件 `happy_*.dart`；放 `lib/shared/widgets/<组件类别>/` 子目录 | `HappyButton`（`widgets/button/happy_button.dart`）、`HappyCheckbox`、`HappyCheckboxFormField` |
| 全局主题令牌类 | `HappyApp<角色>` | `HappyColors`、`HappyTheme`、`HappyTextStyles`、`HappySpacing`、`HappyRadius` |
| feature 私有组件 | **不加** `Happy`；语义 `UpperCamelCase`；文件 `snake_case.dart`；放该 feature 的 `widgets/` | `AuthInput`（`features/auth/widgets/auth_input.dart`）、`SocialIconButton` |
| 布尔入参 | `is` 前缀 | `isLoading`、`isFullWidth`、`isError` |
| 事件回调入参 | `on` 前缀 | `onPressed`、`onChanged`、`onTap` |

- `Happy` 前缀 = “**全局可复用**”的标志：只有下沉到 `lib/shared/widgets/` 的通用组件才用；feature 内部组件不要用，避免误当作可跨 feature 复用。
- 全局组件按“组件类别”建子目录（`widgets/button/`、`widgets/checkbox/`），并在 `widgets/index.dart` barrel 汇总导出。

## ✅ 应该

- 命名**表达意图**，宁长勿含糊：`unreadCount` 优于 `cnt`。
- 同一概念**全项目用同一个词**（如统一用 `todo` 而非混用 `task/item`）。
- 事件回调用 `on` 前缀：`onTap`、`onSubmit`。

## ❌ 避免

- ❌ 缩写含糊：`usr`、`btn`、`tmp`。
- ❌ 用类型名做变量名：`String string`。
- ❌ 一个文件里塞多个不相关的顶层类（一个文件一个主要公共类为宜）。
