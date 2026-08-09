/// **story-generate 模块：把一句心愿变成一篇成稿的完整生成过程。**
///
/// story 模块负责创作入口与历史管理，本模块只负责「生成中」这段旅程：
/// 心愿 → 澄清问答 → 大纲确认/修改 → 流式正文 → 落库，全程走 SSE 多轮会话。
/// 需求文档：`agent/service/story-generate/story-generate.md`（页面）/
/// `story-generate.api.md`（接口）。
library;

export "controllers/index.dart";
export "data/index.dart";
export "domain/index.dart";
export "screens/index.dart";
export "widgets/index.dart";
