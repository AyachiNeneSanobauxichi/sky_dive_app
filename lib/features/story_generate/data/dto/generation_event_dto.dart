import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_generate/data/dto/clarification_card_dto.dart";
import "package:happy_os/features/story_generate/data/dto/story_outline_dto.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

part "generation_event_dto.freezed.dart";
part "generation_event_dto.g.dart";

/// SSE 帧里 `data:` 的那个 JSON 对象（事件的公共外壳）。
///
/// 契约来源：`story-generate.api.md` v1（type / session_id / payload）
/// + `sory-generate-new.api.md` v1（新增同级的 `timestamp`）。
///
/// 所有字段都可空：这是外部服务下发的数据，任何一个字段缺失都不该让整条生成断掉。
@freezed
abstract class GenerationEventDto with _$GenerationEventDto {
  const GenerationEventDto._();

  const factory GenerationEventDto({
    @Default("") String type,

    /// 注意是 snake_case，且与 `type` **同级**、不在 payload 内。
    @JsonKey(name: "session_id") String? sessionId,

    @Default(<String, dynamic>{}) Map<String, dynamic> payload,

    /// 服务端事件时间（RFC3339，纳秒精度，如 `2026-08-10T13:12:58.675533211Z`）。
    ///
    /// 刻意存**原始字符串**而不是让 json_serializable 直接反序列化成 `DateTime`：
    /// 后者遇到一个格式不对的时间戳会抛 `FormatException`，而仓库层正是靠捕获
    /// 这个异常来跳过脏帧的——于是一个坏时间戳会让一整帧好事件被丢掉。
    /// 解析交给 [occurredAt]，失败就只是没有时间，事件本身照样送到。
    String? timestamp,
  }) = _GenerationEventDto;

  factory GenerationEventDto.fromJson(Map<String, dynamic> json) =>
      _$GenerationEventDtoFromJson(json);

  /// 解析后的事件时间；缺失或格式不对时为 null。
  ///
  /// Dart 的 `DateTime.tryParse` 接受纳秒并自行截断到微秒，够用。
  DateTime? get occurredAt {
    final raw = timestamp;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// 事件类型的 wire 值。集中在这里，避免各处散落字符串字面量。
  static const String typeStatus = "status";
  static const String typeClarification = "clarification_card";
  static const String typeOutline = "outline_created";
  static const String typeNovelStart = "novel_start";
  static const String typeNovelDelta = "novel_delta";
  static const String typeNovelDone = "novel_done";
  static const String typeError = "error";

  /// 映射成领域事件。
  ///
  /// sessionId 优先取外层，取不到再退到 `payload.session_id`——首次 `status` 事件在
  /// 两个位置都可能出现，小程序侧就因为只读 payload 漏过第一个澄清卡。
  GenerationEvent toEntity() {
    final id = _resolveSessionId();

    return switch (type) {
      typeStatus => GenerationEvent.status(
        sessionId: id,
        stage: _string("stage"),
      ),
      typeClarification => GenerationEvent.clarification(
        sessionId: id,
        card: _card(),
      ),
      typeOutline => GenerationEvent.outline(
        sessionId: id,
        outline: _outline(),
      ),
      typeNovelStart => GenerationEvent.novelStart(sessionId: id),
      typeNovelDelta => GenerationEvent.delta(
        sessionId: id,
        text: _string("delta") ?? "",
      ),
      typeNovelDone => GenerationEvent.done(
        sessionId: id,
        fullText: _string("full_text"),
        title: _string("title"),
        scriptId: _string("scriptId"),
        conversationId: _string("conversationId"),
        currentVersionMessageId: _string("currentVersionMessageId"),
      ),
      typeError => GenerationEvent.failed(
        sessionId: id,
        code: _string("code"),
        message: _string("message"),
      ),
      _ => GenerationEvent.unknown(sessionId: id, type: type),
    };
  }

  String _resolveSessionId() {
    final outer = sessionId;
    if (outer != null && outer.isNotEmpty) return outer;
    return _string("session_id") ?? "";
  }

  /// 取字符串字段。非字符串（数字等）也转成字符串——id 类字段偶尔会以数字下发。
  String? _string(String key) {
    final value = payload[key];
    if (value == null) return null;
    final text = value is String ? value : value.toString();
    return text.isEmpty ? null : text;
  }

  ClarificationCard _card() {
    final raw = payload["card"];
    if (raw is! Map<String, dynamic>) {
      // 缺 card 的澄清事件没法作答，退化成一张只有问题的空卡由 UI 兜底展示。
      return const ClarificationCard(question: "");
    }
    return ClarificationCardDto.fromJson(raw).toEntity();
  }

  StoryOutline _outline() {
    final raw = payload["outline"];
    if (raw is! Map<String, dynamic>) return const StoryOutline();
    return StoryOutlineDto.fromJson(raw).toEntity();
  }
}
