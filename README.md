# SkyDive

日本跳伞运营商的 **C 端 app**：挑航线（drop zone / 机型 / 高度）→ 看天气窗口 → 下预约 → 管理自己的跳伞记录。

Flutter · Riverpod 3 · Freezed 3 · go_router · Material 3。UI 与交互是本项目的第一优先级。

---

## 现在能跑什么

| 模块 | 状态 |
| --- | --- |
| **认证**（登录 / 注册 / 会话 / 登出） | ✅ 完整链路（走 mock 假后端） |
| **主题**（白昼晴空 / 暮色高空 + 跟随系统） | ✅ 完整 design token 体系 |
| **国际化**（日本語 / English / 中文 + 跟随系统） | ✅ |
| **账号页**（身份卡 / 外观 / 语言 / 登出） | ✅ |
| **航线 tab** | 🚧 骨架（页头 + 空态），待业务文档 |
| **预约 tab** | 🚧 骨架（页头 + 空态），待业务文档 |

### 演示账号（mock 期间）

后端尚未就绪，认证走 `lib/features/auth/data/mock/`。登录页底部有一条演示账号提示条，支持一键填入：

```
邮箱：demo@skydive.jp
密码：skydive2026
```

短信登录：任意日本手机号（`070/080/090` + 8 位，如 `09012345678`），验证码固定 `123456`。

> ⚠️ 账号存在**进程内存**里：热重启 / 杀进程后注册的账号会消失，这是刻意的——mock 不该假装自己是数据库。

---

## 快速开始

```bash
flutter pub get
flutter gen-l10n                # .arb 产物不入库，clone 后必须先跑一次
dart run build_runner build     # freezed / json / @riverpod 产物
flutter run
```

日常开发：

```bash
dart run build_runner watch     # 改注解时挂着
dart format .
flutter analyze                 # 提交前必须零告警
```

⚠️ **不要跑 `flutter pub upgrade`**：`flutter_riverpod` 与 `riverpod_generator` 的版本上限是锁死的（当前 Dart 3.10.1 的解算边界），放宽会立刻无解。原委见 `.claude/skills/flutter-best-practices/references/12-code-generation.md`。

---

## 目录结构

```
lib/
├─ main.dart              # 只做初始化：dotenv、全局错误兜底、预读偏好、ProviderScope
├─ app/                   # 应用装配：MaterialApp、路由表、守卫、启动页、设置切换过渡
├─ core/                  # 基础设施（业务无关）
│  ├─ config/             # Env：.env 的唯一读取入口
│  ├─ error/              # AppException（技术） → Failure（面向 UI）
│  ├─ network/            # DioClient + 三个拦截器（鉴权 / 解包信封 / 错误映射）
│  ├─ providers/          # 全局单例 provider（storage / token / dio）
│  ├─ settings/           # 深浅色与语言偏好
│  ├─ storage/            # SecureStorage（refreshToken 与用户快照）
│  └─ theme/              # design token：色 / 渐变 / 阴影 / 间距 / 字体 / 动效
├─ features/              # 业务模块，各自 data / domain / controllers / screens / widgets
│  ├─ auth/               # 登录 · 注册 · 会话（含 data/mock/ 假后端）
│  ├─ home/               # 外壳：天空背景 + 底部 tab + 分支容器（不是业务模块）
│  ├─ flight/             # 航线 🚧
│  ├─ booking/            # 预约 🚧
│  └─ account/            # 账号
├─ l10n/                  # app_en.arb（模板）+ app_ja.arb + app_zh.arb
└─ shared/                # 跨 feature 复用：Sky* 全局组件 + 工具
```

每个目录都有 `index.dart` barrel，对外只经 barrel 引用。

---

## 设计系统

**基调：高空 · 深浅双主场。** 核心画面是从万米高空跃出——头顶平流层蓝、脚下云海、伞衣张开时那一抹朱橙。

- **浅色 = 白昼晴空**（白天挑航线、看天气、下预约，主流场景）
- **深色 = 暮色高空**（黄昏跳与夜间查看行程，天幕压暗、地平线留一道余晖）

两套都是一等设计目标，都按 WCAG AA（正文 ≥ 4.5:1）逐色校过对比度。默认跟随系统昼夜。

| 令牌 | 类 | 管什么 |
| --- | --- | --- |
| `app_colors.dart` | `SkyColors` | 原始色值（业务层禁止直接引用） |
| `app_theme.dart` | `SkyTheme` | `light` / `dark` 两套 `ThemeData`，逐角色显式指定，不用 `fromSeed` |
| `app_text_styles.dart` | `SkyFonts` / `SkyTextStyles` | 单一字体族（Inter）+ CJK 回退链 + 完整 `TextTheme` |
| `app_spacing.dart` | `SkySpacing` / `SkyRadius` / `SkyIconSize` … | 间距 / 圆角 / 描边 / 图标 / 控件尺寸 |
| `app_gradients.dart` | `SkyGradients` | 品牌光带、天幕、云带、光晕、地平线余晖 |
| `app_shadows.dart` | `SkyShadows` | 阴影与品牌光晕（按 `Brightness` 分支） |
| `app_motion.dart` | `SkyMotion` | 时长与缓动曲线 |

**禁止魔法值**：颜色走 `colorScheme`、文字走 `textTheme`、其余取上表令牌。

全局组件在 `lib/shared/widgets/`，一律 `Sky` 前缀：`SkyButton` / `SkyToast` / `SkyOtpField` / `SkyEmptyState` / `SkyBrandMark` / `SkyBackground` / `SkyGlassCard` / `SkyRetryCard` / `SkyCheckbox`。

---

## 规范

工程规范是**唯一权威来源**，有两种表达，内容一致：

- Claude Code → skill `.claude/skills/flutter-best-practices/`（入口 `references/00-overview.md`）
- Cursor → `.cursor/rules/*.mdc`

改规范时**两处都要更新**（见 `.cursor/rules/sync.mdc`）。

写任何 UI 之前必读两篇：`09-theming-ui.md`（视觉令牌）+ `17-ux-interaction.md`（交互体验）。

业务需求以 `agent/` 下的文档为准：

- `agent/infra/base.md` — 产品定位与全局取向
- `agent/service/<feature>/<feature>.md` — 页面与交互
- `agent/service/<feature>/<feature>.api.md` — 接口与数据契约

---

## 接真后端时要改什么

认证链路已按"随时可切"设计，改动点只有三处：

1. `lib/features/auth/controllers/auth_controller.dart` 里的 `authDataSource` provider —— 换回 `AuthRemoteDataSource(ref.watch(dioClientProvider))`；
2. 删除 `lib/features/auth/data/mock/` 整个目录；
3. 上一步会让登录页的演示账号提示条编译报错（`kAuthMockEnabled`），把那个分支和 `screens/login/widgets/mock_credentials_hint.dart` 一并删掉。

`.env` 里配 `BASE_URL` 与 `API_PREFIX`（见 `.env.example`）。

---

## 已知边界

- **原生工程标识未改名**：`android/` 的 `applicationId` 与 `ios/` 的 bundle id 仍是上一个项目的值。改这两处会影响签名与已装应用的升级路径，留给人工决定。
- **字体回退日文优先**：`SkyFonts.textFallback` 把日文字体排在中文之前（主市场是日本），代价是简中界面下共用汉字会显示日文字形。取舍与解法写在 `app_text_styles.dart` 的 TODO 里。
- **本项目不写自动化测试**（无 `test/` 目录），质量靠 `flutter analyze` 零告警 + 人工验证兜。
