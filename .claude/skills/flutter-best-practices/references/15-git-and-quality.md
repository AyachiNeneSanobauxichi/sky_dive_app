# 15 · Git 工作流与质量门禁

## 提交信息（Conventional Commits）

```text
<type>(<scope>): <subject>

[body]
```

| type | 含义 |
| --- | --- |
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `refactor` | 重构（无行为变化） |
| `perf` | 性能优化 |
| `style` | 格式（不影响逻辑） |
| `test` | 测试 |
| `docs` | 文档 |
| `build` / `chore` | 构建/杂项（依赖、脚手架） |

示例：`feat(todo): 支持按截止日期排序`、`fix(auth): 修复 401 未刷新 token`

## 分支

- `main`：可发布。
- `feature/<desc>`、`fix/<desc>`：从 `main` 切出，PR 合回。
- 小步提交，一个 PR 聚焦一件事。

## ✅ 提交前检查清单（本地）

```bash
dart format .                                   # 1. 格式化
dart run build_runner build --delete-conflicting-outputs  # 2. 若改了注解，重新生成
flutter analyze                                 # 3. 静态分析必须零告警
flutter test                                    # 4. 测试通过
```

- Barrel `index.dart` 是否补齐导出。
- 无 `print`、无 `TODO` 遗漏、无注释掉的死代码。
- 无敏感信息（token、密钥、`.env`）入库。

## ❌ 避免

- ❌ 带 lint 告警/格式未化提交。
- ❌ 一次提交混多个不相关改动。
- ❌ 提交 `.env`、密钥、个人 IDE 配置。
- ❌ 大段注释代码留在库里。

## 质量门禁（建议 CI）

1. `dart format --set-exit-if-changed .`
2. `flutter analyze`
3. `flutter test --coverage`
4. （可选）生成产物一致性校验：重跑 build_runner 后 `git diff` 应为空。

## .gitignore 关注点

确保忽略：`.env`、`.env.*`（保留 `.env.example`）、`build/`、`.dart_tool/`、`coverage/`、IDE 私有配置。
