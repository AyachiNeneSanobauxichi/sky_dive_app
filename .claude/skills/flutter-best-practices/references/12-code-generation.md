# 12 · 代码生成（build_runner / gen-l10n）

> Freezed / json_serializable 依赖 `build_runner`；国际化依赖 `gen-l10n`。⚠️ Riverpod **不参与**代码生成——本仓库 provider/notifier 一律手写（工具链无法运行 `riverpod_generator`，见 `04-state-management.md` 与 `agent/study/riverpod-codegen-issue.md`）。生成文件（`*.g.dart` / `*.freezed.dart` / `app_localizations*.dart`）**不手改、不入 review 关注点，但需入库**（保证 CI/他人可编译）。

## 🚦 新增「需命令生成」的工具包 → 必须写进 README

引入任何**装了还不能直接用、要额外跑命令才产出可用代码/资源**的包（`build_runner` 系、`intl` 的 gen-l10n、未来的图标/资源生成器等），**必须**同步在项目 `README.md` 补齐开发者步骤：

- 判断标准：该包会产出 `*.g.dart` / `*.freezed.dart` / `AppLocalizations` 等**中间产物**，`flutter pub get` 之后仍需再跑命令。
- README 至少写清：**装依赖 → 生成命令（含常用 flag）→ 触发时机**（改了哪些注解/文件要重跑）→ 产物位置与是否入库。
- 目标：新人 `clone` 后照 README 一步步能跑通、能编译。
- 命令有变动：本模块与 README **两处同步**更新。

## 何时需要重新生成

- 新增/修改带 `@freezed` 的类。
- 新增/修改带 `@JsonSerializable` / `fromJson` 的类。
- （provider/notifier 手写，改动**无需**重新生成。）

## 常用命令

```bash
# 一次性生成（推荐加 --delete-conflicting-outputs 清理旧产物）
dart run build_runner build --delete-conflicting-outputs

# 开发期监听自动生成
dart run build_runner watch --delete-conflicting-outputs

# 清理生成缓存
dart run build_runner clean

# 国际化：根据 lib/l10n/*.arb 生成 AppLocalizations（改了 arb 后重跑）
flutter gen-l10n
```

> `pubspec.yaml` 里 `flutter: generate: true` 时，`flutter run`/`flutter build` 会自动跑一次 gen-l10n；改完 arb 想立即拿到新 `AppLocalizations` 可手动 `flutter gen-l10n`。

## ✅ 应该

- 每个使用注解的文件顶部声明对应 `part`：
  - Freezed：`part "xxx.freezed.dart";`
  - JSON：`part "xxx.g.dart";`
  - （Riverpod 手写，无 `part` / 无 `.g.dart`。）
- 改完注解**立即** `build_runner build` 再继续，避免编译报错误导。
- 生成产物**提交入库**（CI 环境可直接编译，减少构建时长与不确定性）。
- 遇到冲突/幽灵错误：`build_runner clean` 后重跑。

## ❌ 避免

- ❌ 手改 `*.g.dart` / `*.freezed.dart`。
- ❌ 忘记加 `part` 导致找不到 `_$Xxx`。
- ❌ 在一个文件同时缺失 freezed 与 json 的 `part` 声明。
- ❌ 把生成产物加入 `.gitignore`（除非团队约定 CI 生成）。

## 📌 一个文件的完整注解头示例

```dart
import "package:freezed_annotation/freezed_annotation.dart";

part "todo_dto.freezed.dart";
part "todo_dto.g.dart";

@freezed
abstract class TodoDto with _$TodoDto {
  const factory TodoDto({required String id, required String title}) = _TodoDto;
  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);
}
```
