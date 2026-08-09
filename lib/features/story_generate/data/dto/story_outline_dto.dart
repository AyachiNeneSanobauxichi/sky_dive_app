import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

part "story_outline_dto.freezed.dart";
part "story_outline_dto.g.dart";

/// `outline_created` 事件里的 `payload.outline`（`story-generate.api.md` v1）。
@freezed
abstract class StoryOutlineDto with _$StoryOutlineDto {
  const StoryOutlineDto._();

  const factory StoryOutlineDto({
    String? title,
    String? logline,
    @Default(<OutlineBeatDto>[]) List<OutlineBeatDto> beats,
    String? ending,
  }) = _StoryOutlineDto;

  factory StoryOutlineDto.fromJson(Map<String, dynamic> json) =>
      _$StoryOutlineDtoFromJson(json);

  StoryOutline toEntity() => StoryOutline(
    title: title,
    logline: logline,
    // 丢掉标题与摘要都空的节拍：渲染出来是一个只有序号的空行。
    beats: beats
        .where((beat) => beat.hasContent)
        .map((beat) => beat.toEntity())
        .toList(),
    ending: ending,
  );
}

/// 大纲里的一个节拍。
@freezed
abstract class OutlineBeatDto with _$OutlineBeatDto {
  const OutlineBeatDto._();

  const factory OutlineBeatDto({int? order, String? title, String? summary}) =
      _OutlineBeatDto;

  factory OutlineBeatDto.fromJson(Map<String, dynamic> json) =>
      _$OutlineBeatDtoFromJson(json);

  bool get hasContent =>
      (title?.isNotEmpty ?? false) || (summary?.isNotEmpty ?? false);

  OutlineBeat toEntity() =>
      OutlineBeat(order: order, title: title, summary: summary);
}
