import "package:freezed_annotation/freezed_annotation.dart";

part "track_entry.freezed.dart";

/// 一条人生轨迹：**时间 / 事件 / 感受 / 结果**。
///
/// 这四件是 story 改写爽文的原料——「事件」给骨架、「感受」给情绪、「结果」给爽点落点。
/// 缺了感受与结果，AI 只能写成大事记而不是故事，所以感受是必填、结果可空
/// （很多事当时还没有结果，那正是它值得被改写的原因）。
// TODO(track): 接口契约未定（agent/service/track/track.api.md 为空），字段先按记录
//   四要素假设。定稿后回来对齐并删除 data/mock/。
@freezed
abstract class TrackEntry with _$TrackEntry {
  const factory TrackEntry({
    required String id,

    /// 事件本身，一句话说清发生了什么。
    required String event,

    /// 发生时间。时间线按它倒序。
    required DateTime happenedAt,

    /// 当时的感受。
    required String feeling,

    /// 后来怎么了。为空表示"还没有结果"。
    String? outcome,

    required TrackTag tag,
  }) = _TrackEntry;
}

/// 轨迹标签。筛选栏里的「全部」不是标签，而是"不筛选"（用可空的 [TrackTag] 表达）。
enum TrackTag {
  /// 童年。
  childhood,

  /// 高光时刻。
  highlight,

  /// 低谷。
  lowPoint,

  /// 美好瞬间。
  goodMoment,
}
