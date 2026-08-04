/// **user 模块：用户设定。**
///
/// 账号信息与生成偏好（昵称 / 头像 / 成长指标 / 个人档案），相当于
/// `features/story` 生成时的"作者设定"；退出登录入口也在这里。首页第 3 个 tab。
/// 需求文档：`agent/service/user/user.md` / `user.api.md`。
library;

export "controllers/index.dart";
export "domain/index.dart";
export "screens/index.dart";
export "widgets/index.dart";
