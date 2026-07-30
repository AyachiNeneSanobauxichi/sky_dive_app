# happy_os

一个基于 Flutter 的待办事项应用，采用 **feature-first + Clean Architecture** 分层架构，遵循企业级工程规范。

> 完整开发规范见 Claude skill [`.claude/skills/flutter-best-practices/`](./.claude/skills/flutter-best-practices/SKILL.md) 与 Cursor 规则 `.cursor/rules/*.mdc`（同一套规范的两种表达）。

## 技术栈

| 领域     | 技术                                              | 版本           | 说明                                                                                               |
| -------- | ------------------------------------------------- | -------------- | -------------------------------------------------------------------------------------------------- |
| 框架     | Flutter / Dart                                    | Dart `^3.10.1` | 现代语法（records / patterns / sealed / switch 表达式）                                            |
| 状态管理 | `flutter_riverpod`                                | 3.3.x          | **手写 Provider**（工具链不支持 `riverpod_generator`，见 `agent/study/riverpod-codegen-issue.md`） |
| 网络     | `dio` + `pretty_dio_logger` + `connectivity_plus` | 5.10.x         | 统一 `DioClient` + 拦截器 + 断网检测                                                               |
| 安全存储 | `flutter_secure_storage`                          | 9.2.x          | token 等敏感数据（Keychain/Keystore）                                                              |
| 数据模型 | `freezed` + `json_serializable` + `*_annotation`  | 3.2.x / 6.11.x | 不可变模型 + JSON 序列化                                                                           |
| 表单校验 | `form_builder_validators`                         | 11.3.x         | 复用校验规则（邮箱/必填/长度等）                                                                   |
| 路由     | `go_router`                                       | 17.3.x         | 声明式路由 + 鉴权守卫                                                                              |
| 配置     | `flutter_dotenv`                                  | 6.0.x          | `.env` 环境变量                                                                                    |
| 日志     | `logger`                                          | 2.7.x          | 统一 `AppLogger`                                                                                   |
| 国际化   | `flutter_localizations` + `intl`（gen-l10n）      | SDK / 0.20.x   | 中英双语、随系统切换；`AppLocalizations` 由 `lib/l10n/*.arb` 生成                                  |
| 图片     | `cached_network_image`                            | 3.4.x          | 网络图缓存                                                                                         |
| 代码生成 | `build_runner`                                    | 2.15.x         | freezed / json（**不含 riverpod**，provider 手写）                                                 |
| 静态检查 | `flutter_lints`                                   | 6.0.x          | 基线 lint 规则                                                                                     |

## 项目结构

```text
lib/
├── main.dart          # 入口（加载 .env、ProviderScope、runApp）
├── app/               # 应用装配（MaterialApp、router）
├── core/              # 跨功能基础设施（network / error / storage / config / theme）
├── features/          # 业务功能（feature-first：data/domain/controllers/screens/widgets）
├── l10n/              # 国际化：*.arb 文案源 + 生成的 AppLocalizations
└── shared/            # 业务无关可复用（widgets / utils）
```

## 环境要求

- Flutter SDK（Dart `^3.10.1`，建议使用最新 stable）
- 已配置 iOS / Android 开发环境（Xcode / Android Studio + 模拟器或真机）

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

### 3. 生成代码（Freezed / JSON）

首次运行或修改了带注解（`@freezed` / `@JsonSerializable`）的文件后执行（⚠️ Riverpod provider 手写，无需生成；原因见 `agent/study/riverpod-codegen-issue.md`）：

```bash
dart run build_runner build --delete-conflicting-outputs
```

开发期可用监听模式自动生成：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. 生成国际化（i18n）

用户文案维护在 `lib/l10n/app_en.arb`（模板）与 `lib/l10n/app_zh.arb`，由 gen-l10n 生成 `AppLocalizations`。因 `pubspec.yaml` 配了 `flutter: generate: true`，`flutter run` / `flutter build` 会**自动生成**；改了 `.arb` 想立即拿到新文案可手动执行：

```bash
flutter gen-l10n
```

> 加新文案：先在 `app_en.arb` 加 `key` + `@key`（description），再在 `app_zh.arb` 加对应中文（两个文件 key 必须一一对应），然后重新生成。

### 5. 运行应用

```bash
flutter run                 # 运行到默认设备
flutter devices             # 查看可用设备
flutter run -d <device_id>  # 指定设备运行
```

## 常用命令

```bash
dart format .        # 代码格式化
flutter analyze      # 静态分析（提交前需零告警）
flutter test         # 运行测试
flutter build apk    # 构建 Android 包
flutter build ios    # 构建 iOS 包
```

## 开发规范

同一套规范以两种 AI 原生格式维护（内容等价）：

- **Claude — skill**：[`.claude/skills/flutter-best-practices/`](./.claude/skills/flutter-best-practices/SKILL.md)（`SKILL.md` + `references/00..16`，按需加载）
- **Claude 入口**：[`.claude/CLAUDE.md`](./.claude/CLAUDE.md)（自动加载的红线，指向上述 skill）
- **Claude 团队配置**：[`.claude/settings.json`](./.claude/settings.json)（共享命令权限白名单；个人覆盖写 `.claude/settings.local.json`）
- **Cursor — rules**：`.cursor/rules/*.mdc`（每条规则自包含，按 `globs` 自动生效）

> **规范同步**：Cursor rules 与 Claude skill 是同一套规范的两种表达。改规范或新增领域时两处都要更新，领域↔文件对照见 [`.cursor/rules/sync.mdc`](./.cursor/rules/sync.mdc)。

提交前请确保：`dart format` 已执行、`flutter analyze` 零告警、`flutter test` 通过。
