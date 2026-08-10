import "package:freezed_annotation/freezed_annotation.dart";

part "conversation_message_dto.freezed.dart";
part "conversation_message_dto.g.dart";

/// `MessageResponse`（`story-generate.api.md` v4）。
///
/// 除 [id] 外全部可空：这条会话是被好几个版本的服务端先后写进去的，
/// 缺字段是常态，少一个不该让整段回放打不开。
@freezed
abstract class ConversationMessageDto with _$ConversationMessageDto {
  const ConversationMessageDto._();

  const factory ConversationMessageDto({
    @Default("") String id,

    /// 正文 / 澄清卡 JSON / 大纲 JSON，随 [type] 而定。
    String? content,
    String? type,
    String? sender,

    /// 会话内序号，回放按它升序。
    @JsonKey(fromJson: _orderFromJson) @Default(0) int messageOrder,
    String? createTime,
  }) = _ConversationMessageDto;

  factory ConversationMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationMessageDtoFromJson(json);

  bool get isFromUser => sender?.trim().toLowerCase() == _senderUser;

  String get normalizedType => type?.trim().toLowerCase() ?? "";
}

/// 服务端字段是 `Long`。JSON 里它可能是数字，也可能被序列化成字符串
/// （雪花号那套配置会把长整型转成字符串以免前端丢精度，这里跟着一起变过）。
/// 认不出就当 0——排序退化成"按接口给的顺序"，比整页崩掉强。
int _orderFromJson(Object? raw) => switch (raw) {
  final int value => value,
  final num value => value.toInt(),
  final String value => int.tryParse(value) ?? 0,
  _ => 0,
};

/// 消息类型。取值见 `story-generate.api.md` v4 的对应表。
abstract final class ConversationMessageType {
  static const String chat = "chat";
  static const String clarificationQuestion = "clarification_question";
  static const String clarificationAnswer = "clarification_answer";
  static const String outline = "outline";
  static const String script = "script";
}

const String _senderUser = "user";
