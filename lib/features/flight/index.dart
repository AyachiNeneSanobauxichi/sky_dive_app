/// flight（航线）模块。
///
/// 见 `.claude/skills/flutter-best-practices/references/01-project-structure.md`
/// 的业务模块地图。
///
/// 职责：**航线（load）排班**——某个跳伞地点、某个时刻、某架飞机的一次爬升，
/// 连同顾客与摄影师的名额与名单。客人在这里看有什么可跳、还剩几位；
/// 运营方在这里排班（新建 / 编辑 / 删除航线、给航线排人）。
///
/// 产出可预约的航线给 booking 模块。
library;

export "controllers/index.dart";
export "data/index.dart";
export "domain/index.dart";
export "screens/index.dart";
export "widgets/index.dart";
