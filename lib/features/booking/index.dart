/// booking（预约）模块。
///
/// 职责：**客人的行程**——我预约了哪几条航线、取消预约、回看跳过的班次。
///
/// 预约在 v1 等于"在航线名单上占一个顾客位"，所以本模块消费 flight 的航线数据
/// （单向依赖：flight 不知道 booking 的存在）。
library;

export "controllers/index.dart";
export "screens/index.dart";
export "widgets/index.dart";
