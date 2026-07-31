import "package:freezed_annotation/freezed_annotation.dart";

part "story_delta_dto.freezed.dart";
part "story_delta_dto.g.dart";

/// 流式生成中单个 SSE `data:` 帧的结构。
///
/// 约定的帧格式：
/// ```
/// event: delta
/// data: {"delta": "走廊的灯一盏接一盏"}
///
/// event: done
/// data: [DONE]
/// ```
///
// TODO(story): 后端 /story/generate 的 SSE 帧格式定稿后校准字段名。
//   当前按「OpenAI 兼容网关」最常见的形态假设：增量在 `delta`，
//   结束用 `event: done` 或 `data: [DONE]` 哨兵。
@freezed
abstract class StoryDeltaDto with _$StoryDeltaDto {
  const factory StoryDeltaDto({
    /// 本帧的文本增量。心跳帧可能为空串。
    @Default("") String delta,
  }) = _StoryDeltaDto;

  factory StoryDeltaDto.fromJson(Map<String, dynamic> json) =>
      _$StoryDeltaDtoFromJson(json);
}
