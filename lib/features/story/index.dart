/// **story 模块：创作入口。**
///
/// 招呼语、灵感推荐、心愿输入（文字 / 语音）归本模块；素材来自 `features/track`
/// 的成长轨迹，风格取自 `features/user` 的设定。产品主路径（首页第 1 个 tab）。
///
/// 生成过程归 `features/story_generate/`，写完之后的成稿归
/// `features/story_history/`——首页那几条"最近"也读的是后者，全应用只有一份历史数据源。
/// 需求文档：`agent/service/story/story.md`（页面）/ `story.api.md`（接口）。
library;

export "controllers/index.dart";
export "domain/index.dart";
export "screens/index.dart";
export "widgets/index.dart";
