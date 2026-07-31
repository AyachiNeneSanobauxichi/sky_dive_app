/// 一个 SSE（Server-Sent Events）事件帧。
///
/// 只表达协议本身，**不含任何业务约定**——`[DONE]` 之类的哨兵值是各家 LLM 网关
/// 自己的约定，由 feature 的 DataSource 去识别，core 不做假设。
class SseEvent {
  const SseEvent({required this.event, required this.data, this.id});

  /// 事件名（`event:` 字段）。协议规定缺省为 `message`。
  final String event;

  /// 数据载荷（`data:` 字段）。多行 `data:` 已用 `\n` 拼好。
  final String data;

  /// 事件 id（`id:` 字段）。断线重连时可作 `Last-Event-ID` 回传，实现续传。
  final String? id;

  /// 协议规定的缺省事件名。
  static const String defaultEvent = "message";

  @override
  String toString() => "SseEvent(event: $event, id: $id, data: $data)";
}
