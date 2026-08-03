# 01 · 项目结构

## 目录总览

```text
lib/
├── main.dart                 # 入口：仅做 bootstrap（加载 .env、ProviderScope、runApp）
├── app/                      # 应用级装配
│   ├── app.dart              # MaterialApp.router、主题、locale 装配
│   └── router/               # go_router 配置
│       ├── app_router.dart   # GoRouter 实例（provider 暴露）
│       ├── routes.dart       # RouteBase 列表
│       ├── route_name.dart   # 路由名/路径常量
│       ├── route_guard.dart  # 重定向/鉴权守卫
│       └── index.dart
├── core/                     # 跨功能基础设施（无业务）
│   ├── config/env.dart       # 环境变量读取封装
│   ├── constants/            # 全局常量
│   ├── error/                # AppException / Failure
│   ├── extensions/           # 通用扩展方法
│   ├── network/              # DioClient / ApiResult / 拦截器
│   ├── providers/            # 核心级 provider（dio、connectivity 等）
│   ├── storage/              # 安全存储 / 本地缓存
│   └── theme/                # app_colors / app_spacing / app_text_styles / app_theme
├── features/                 # 业务功能（feature-first）
│   └── <feature>/            # 例：auth、todo
│       ├── data/             # DataSource + Repository 实现 + DTO
│       ├── domain/           # 实体(Entity) + Repository 抽象 + 用例(可选)
│       ├── controllers/      # Riverpod Notifier/Provider（表现逻辑）
│       ├── presentation/     # 状态类/ViewState（可选，与 controller 配套）
│       ├── screens/          # 页面级 Widget（路由目标）
│       ├── widgets/          # 该 feature 私有组件
│       └── index.dart
├── l10n/                     # gen-l10n 产物（app_localizations*.dart，源自 lib/l10n/*.arb）
└── shared/                   # 可复用的业务无关资产
    ├── widgets/              # 全局通用 UI 组件（button / checkbox…）
    └── utils/                # 业务无关工具（logger 等）
```

## 🗺️ 业务模块地图（写代码前先对号入座）

产品由四个业务模块构成，**职责不重叠**；拿不准新代码该放哪个模块时按这张表判断，别就近塞。

| 模块 | 位置 | 职责 | 与其它模块的关系 |
| --- | --- | --- | --- |
| **auth** | `features/auth/` | 手机号 + 短信验证码登录、全局登录态、令牌与会话 | 其余模块都在登录后才可达 |
| **story** | `features/story/` | **生成并管理用户生成的爽文**：与 AI 聊天调试生成、保存、再编辑、列表管理。产品主路径 | 消费 track 的轨迹作素材，读 user 的风格设定 |
| **track** | `features/track/` | **用户的成长轨迹**：记录真实经历（时间 / 事件 / 感受 / 结果）。条目是生成爽文的 **key**（真实骨架的来源） | 产出素材给 story |
| **user** | `features/user/` | **用户设定**：账号信息与生成偏好（昵称 / 头像 / 故事风格 / 语气强度 / 内容边界），即"作者设定"；含退出登录 | 提供设定给 story |

`features/home/` 不是业务模块，只是**外壳**：底部导航 + `IndexedStack`，承载 story / track / user 三个 tab（顺序即上表顺序）。各 tab 页面自带 `Scaffold` 与 AppBar，便于日后原样升级成独立路由。

> 每个模块的需求以文档为准：`agent/service/<模块>/<模块>.md`（页面）+ `<模块>.api.md`（接口契约），见 `16-agent-workflow.md`。代码侧每个 `features/<模块>/index.dart` 顶部也写了同样的职责说明。

## ✅ 应该

- **新功能** 一律在 `lib/features/<feature>/` 下新建，按 `data/domain/controllers/screens/widgets` 分层。
- **每个目录维护 `index.dart` barrel**，`export "xxx.dart";`（双引号），对外只通过 barrel 引用。
- **跨功能复用** 的东西才下沉到 `core/`（基础设施）或 `shared/`（业务无关 UI/模型）。
- **`main.dart` 保持精简**：只负责初始化，不写业务。

## ❌ 避免

- ❌ feature 之间**直接互相 import 内部文件**（应通过各自 `index.dart`，或把公共部分提到 `shared/`）。
- ❌ 在 `core/` 里写任何具体业务逻辑。
- ❌ 把页面、模型、网络代码堆在同一文件。
- ❌ 绕过 barrel 直接深路径 import 其他 feature 的实现细节。

## 📌 依赖方向（严格单向）

```text
screens/widgets  →  controllers  →  domain(repository 抽象)  ←  data(实现)
                                        ↑
                        core(network/error/storage/...) 被各层复用
```

- 上层可依赖下层，**下层禁止依赖上层**。
- `domain` 不依赖 `data`；`data` 实现 `domain` 定义的抽象（依赖倒置）。

## 📌 新增 feature 检查清单

1. 建目录 `lib/features/<feature>/{data,domain,controllers,presentation,screens,widgets}`。
2. 每个子目录建 `index.dart`，feature 根建 `index.dart` 汇总导出。
3. `domain` 定义 Entity（Freezed）与 `XxxRepository` 抽象。
4. `data` 定义 DTO、DataSource、`XxxRepositoryImpl`，用 `DioClient`。
5. `controllers` 用 `@riverpod` 注解声明 `Notifier`/`AsyncNotifier` 暴露状态，provider 由 `riverpod_generator` 生成。
6. `screens` 建页面并在 `app/router/routes.dart` 注册。
