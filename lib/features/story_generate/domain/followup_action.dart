/// `POST /shortNovel/followup` 的 `action` 取值（`story-generate.api.md` v1）。
///
/// 每个 action 的 `payload` 形状不同，由 [buildPayload] 统一构造——把"哪个 action
/// 配哪种 payload"这条契约收在一处，调用方不用记。
enum FollowupAction {
  /// 回答澄清卡。
  answerClarification("answer_clarification"),

  /// 确认大纲，开始写正文。
  confirmOutline("confirm_outline"),

  /// 提出大纲修改意见。
  modifyOutline("modify_outline"),

  /// 恢复上次中断的会话。
  retry("retry");

  const FollowupAction(this.wireName);

  /// 传给后端的字符串值。
  final String wireName;

  /// 构造该 action 对应的 `payload`。
  ///
  /// [text] 是用户输入：`answerClarification` 时是那句回答、`modifyOutline` 时是
  /// 修改意见；另外两个 action 契约要求 payload 为 null（不是空对象）。
  Map<String, dynamic>? buildPayload(String? text) => switch (this) {
    FollowupAction.answerClarification => <String, dynamic>{"answer": text},
    FollowupAction.modifyOutline => <String, dynamic>{"feedback": text},
    FollowupAction.confirmOutline || FollowupAction.retry => null,
  };
}
