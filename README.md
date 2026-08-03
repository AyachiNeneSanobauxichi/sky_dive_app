# happy_os

HappyOS 是一个 AI 驱动的应用，基于用户自己的人生经历生成个性化的故事。采用 **feature-first + Clean Architecture** 分层架构，遵循企业级工程规范。

> 完整开发规范见 Claude skill [`.claude/skills/flutter-best-practices/`](./.claude/skills/flutter-best-practices/SKILL.md) 与 Cursor 规则 `.cursor/rules/*.mdc`（同一套规范的两种表达）。

## 技术栈

| 领域     | 技术                                              | 版本           | 说明                                                                                               |
| -------- | ------------------------------------------------- | -------------- | -------------------------------------------------------------------------------------------------- |
| 框架     | Flutter / Dart                                    | Dart `^3.10.1` | 现代语法（records / patterns / sealed / switch 表达式）                                            |
| 状态管理 | `flutter_riverpod` + `riverpod_annotation`        | 3.1.x / 4.0.x  | `@riverpod` 注解 + 代码生成；⚠️ 版本上限锁死，见下方 [Riverpod 版本锁](#riverpod-版本锁勿放宽) |
| 网络     | `dio` + `pretty_dio_logger` + `connectivity_plus` | 5.10.x         | 统一 `DioClient` + 拦截器 + 断网检测                                                               |
| 安全存储 | `flutter_secure_storage`                          | 9.2.x          | token 等敏感数据（Keychain/Keystore）                                                              |
| 数据模型 | `freezed` + `json_serializable` + `*_annotation`  | 3.2.x / 6.11.x | 不可变模型 + JSON 序列化                                                                           |
| 表单校验 | `form_builder_validators`                         | 11.3.x         | 复用校验规则（邮箱/必填/长度等）                                                                   |
| 路由     | `go_router`                                       | 17.3.x         | 声明式路由 + 鉴权守卫                                                                              |
| 配置     | `flutter_dotenv`                                  | 6.0.x          | `.env` 环境变量                                                                                    |
| 日志     | `logger`                                          | 2.7.x          | 统一 `AppLogger`                                                                                   |
| 国际化   | `flutter_localizations` + `intl`（gen-l10n）      | SDK / 0.20.x   | 中英双语、随系统切换；`AppLocalizations` 由 `lib/l10n/*.arb` 生成                                  |
| 图片     | `cached_network_image`                            | 3.4.x          | 网络图缓存                                                                                         |
| 代码生成 | `build_runner` + `freezed` + `json_serializable` + `riverpod_generator` | 2.15.x / 4.0.x | 生成 `*.freezed.dart` / `*.g.dart`                                            |
| 静态检查 | `flutter_lints`                                   | 6.0.x          | 基线 lint 规则；⚠️ 无 `riverpod_lint`（当前 SDK 装不上）                                            |

## 项目结构

```text
lib/
├── main.dart          # 入口（加载 .env、ProviderScope、runApp）
├── app/               # 应用装配（MaterialApp、router）
├── core/              # 跨功能基础设施（network / error / storage / config / theme）
├── features/          # 业务功能（feature-first：data/domain/controllers/screens/widgets）
├── l10n/              # 国际化：*.arb 文案源（AppLocalizations 为生成产物，不入库）
└── shared/            # 业务无关可复用（widgets / utils）
```

## 环境要求

- Flutter SDK —— **已验证组合：Flutter 3.38.3 / Dart 3.10.1**
- 已配置 iOS / Android 开发环境（Xcode / Android Studio + 模拟器或真机）

> 升级到带 Dart ≥ 3.12.0 的 Flutter 可解开 Riverpod 版本锁并启用 `riverpod_lint`，
> 但当前 Flutter 是**全局 git checkout**，升级会影响本机所有项目；如需仅本项目升级请先引入 `fvm`。
> 详见下方 [Riverpod 版本锁](#riverpod-版本锁勿放宽)。

验证环境：

```bash
flutter --version
flutter doctor
```

## 启动方法

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 配置环境变量

复制模板 `.env.example` 为 `.env`，按需修改（读取封装见 `lib/core/config/env.dart`）：

```bash
cp .env.example .env
```

```env
API_BASE_URL=https://api.example.com
ENABLE_LOGGING=true
```

> `.env` / `.env.*` 已在 `.gitignore` 中忽略（保留 `.env.example`），请勿提交真实密钥。

### 3. 生成代码（Freezed / JSON / Riverpod）

**首次 clone 后必须先跑一次**，否则编译报「Target of URI hasn't been generated」。
之后修改了下列任一注解也要重跑：

| 注解 | 产物 | 位置 |
| --- | --- | --- |
| `@freezed` | `*.freezed.dart` | 与源文件同目录 |
| `@JsonSerializable` / `fromJson` | `*.g.dart` | 与源文件同目录 |
| `@riverpod` / `@Riverpod(...)` | `*.g.dart` | 与源文件同目录 |

```bash
dart run build_runner build
```

开发期可用监听模式自动生成：

```bash
dart run build_runner watch
```

> 产物（`*.freezed.dart` / `*.g.dart`）**入库但不手改**，`analysis_options.yaml` 已将其排除在 lint 之外。
> （注意：gen-l10n 的产物策略相反，**不入库**，见下一节。）
> `build_runner` 2.15+ 已移除 `--delete-conflicting-outputs`，传了只会警告并忽略；要清缓存用 `dart run build_runner clean`。

#### Riverpod 版本锁（勿放宽）

`pubspec.yaml` 里这两个上限是**刻意锁死**的，改成 `^` 或跑 `flutter pub upgrade` 都会让依赖解算立刻失败：

```yaml
flutter_riverpod: ">=3.0.0 <3.3.0"   # 解析为 3.1.0
riverpod_generator: <4.0.6           # 解析为 4.0.0+1
```

根因：`riverpod_generator` ≥ 4.0.6 与 `riverpod_lint` ≥ 3.1.6 都要求 **Dart SDK ≥ 3.12.0**，
当前是 3.10.1；退到低版本后又与 Freezed 3 的 `build ^3.0.0` 冲突，只能把 riverpod 压到 3.1.0。
因此 **`riverpod_lint` 未安装**——provider 用法错误没有静态检查兜底，只能靠 code review。

完整分析与解锁路径（升级 Flutter SDK / 引入 fvm）见规范模块
[`references/12-code-generation.md`](./.claude/skills/flutter-best-practices/references/12-code-generation.md) 的「🔒 Riverpod 版本锁」一节。

### 4. 生成国际化（i18n）

用户文案维护在 `lib/l10n/app_en.arb`（模板）与 `lib/l10n/app_zh.arb`，由 gen-l10n 生成 `AppLocalizations`。

**首次 clone 后必须先跑一次**，否则 `flutter analyze` / IDE 会报「`AppLocalizations` 上不存在 xxx」：

```bash
flutter gen-l10n
```

改了 `.arb` 之后同样要重跑。`flutter run` / `flutter build` 因 `pubspec.yaml` 的 `flutter: generate: true` 会自动生成，但 **`flutter analyze` 与 `flutter test` 不会**。

> ⚠️ **产物不入库**：`lib/l10n/app_localizations*.dart` 已在 `.gitignore` 中忽略，与 `*.freezed.dart` / `*.g.dart` 的策略**相反**。
>
> 原因：入库会要求「改 `.arb` 必须紧跟一次 gen-l10n 并把产物一起提交」，任何一半的回滚或合并冲突都会让产物与 `.arb` 脱钩——表现是 `.arb` 里明明有 key，代码里 `l10n.xxx` 却报未定义，而 diff 里看不出任何异常。本项目真实踩过一次。改成本地生成后，唯一的真源就是 `.arb`。

> 加新文案：先在 `app_en.arb` 加 `key` + `@key`（description），再在 `app_zh.arb` 加对应中文（两个文件 key 必须一一对应），然后重新生成。缺翻译会写进 `l10n_untranslated.txt`（也不入库）。

### 5. 运行应用

```bash
flutter run                 # 运行到默认设备
flutter devices             # 查看可用设备
flutter run -d <device_id>  # 指定设备运行
```

## 常用命令

```bash
dart format .                    # 代码格式化
flutter analyze                  # 静态分析（提交前需零告警）
flutter test                     # 运行测试
dart run build_runner build      # 改了 @freezed / @JsonSerializable / @riverpod 后重新生成
dart run build_runner watch      # 开发期自动生成
dart run build_runner clean      # 清理生成缓存
flutter gen-l10n                 # clone 后 / 改了 lib/l10n/*.arb 后生成 AppLocalizations（产物不入库）
flutter build apk                # 构建 Android 包
flutter build ios                # 构建 iOS 包
```

## 开发规范

同一套规范以两种 AI 原生格式维护（内容等价）：

- **Claude — skill**：[`.claude/skills/flutter-best-practices/`](./.claude/skills/flutter-best-practices/SKILL.md)（`SKILL.md` + `references/00..17`，按需加载）
- **Claude 入口**：[`.claude/CLAUDE.md`](./.claude/CLAUDE.md)（自动加载的红线，指向上述 skill）
- **Claude 团队配置**：[`.claude/settings.json`](./.claude/settings.json)（共享命令权限白名单；个人覆盖写 `.claude/settings.local.json`）
- **Cursor — rules**：`.cursor/rules/*.mdc`（每条规则自包含，按 `globs` 自动生效）

> **规范同步**：Cursor rules 与 Claude skill 是同一套规范的两种表达。改规范或新增领域时两处都要更新，领域↔文件对照见 [`.cursor/rules/sync.mdc`](./.cursor/rules/sync.mdc)。

提交前请确保：`dart format` 已执行、`flutter analyze` 零告警、`flutter test` 通过。
