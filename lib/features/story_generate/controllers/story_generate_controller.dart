import "dart:async";

import "package:dio/dio.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/story_generate/controllers/story_generate_state.dart";
import "package:happy_os/features/story_generate/data/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "story_generate_controller.g.dart";

/// story-generate 仓库 DI。
@Riverpod(keepAlive: true)
StoryGenerateRepository storyGenerateRepository(Ref ref) =>
    StoryGenerateRepository(
      StoryGenerateRemoteDataSource(ref.watch(dioClientProvider)),
    );

/// 生成会话编排器：把多轮 SSE 拼成一条时间线。
///
/// ## 一次生成是**多条流**，不是一条
/// 每轮（发起 / 回答澄清 / 确认大纲）都是一次独立的 SSE 请求，服务端在这一轮该说的
/// 话说完就关流。所以**流正常结束不等于生成结束**——结束时该处于什么状态由这一轮
/// 最后收到的事件决定（澄清卡 → 等作答；`novel_done` → 完成）。只有"什么都没收到
/// 就断了"才是真的失败（[_finishRound]）。
///
/// ## 失败不清屏
/// 失败时只写 [StoryGenerateState.failure]，timeline 原样保留。用户等了几十秒的
/// 半篇故事，不能因为一次网络抖动就没了。
@riverpod
class StoryGenerateController extends _$StoryGenerateController {
  StreamSubscription<GenerationEvent>? _subscription;
  CancelToken? _cancelToken;

  /// 本轮是否收到过任何事件。用来区分「服务端正常收尾」和「一声不吭就断了」。
  bool _receivedAnyEvent = false;

  @override
  StoryGenerateState build() {
    // 页面销毁时必须断流：SSE 是长连接，留着会一直占着连接和回调。
    ref.onDispose(_disposeStream);
    return const StoryGenerateState();
  }

  /// 发起生成。[query] 是用户的心愿文本。
  ///
  /// 幂等：正在进行中时直接忽略，避免"点两下发两次"。
  void start(String query) {
    final text = query.trim();
    if (text.isEmpty || state.isBusy) return;

    state = StoryGenerateState(
      timeline: <GenerationEntry>[GenerationEntry.wish(text: text)],
      phase: GenerationPhase.connecting,
      originalQuery: text,
    );

    _listen(
      ref
          .read(storyGenerateRepositoryProvider)
          .start(query: text, cancelToken: _newCancelToken()),
    );
  }

  /// 回答澄清卡。
  void answerClarification(String answer) {
    final text = answer.trim();
    if (text.isEmpty || !state.isAwaitingUser) return;

    // 先把卡片收起为"已回答"，再发请求：用户点了提交就该立刻看到卡片定格，
    // 而不是等网络回来才有反应。
    state = state.copyWith(
      timeline: _resolveLastClarification(text),
      phase: GenerationPhase.connecting,
      failure: null,
      errorCode: null,
    );
    _sendFollowup(FollowupAction.answerClarification, text: text);
  }

  /// 确认大纲，开始写正文。
  void confirmOutline() {
    if (!state.isAwaitingUser) return;
    state = state.copyWith(
      timeline: _resolveLastOutline(OutlineResolution.confirmed, null),
      phase: GenerationPhase.connecting,
      failure: null,
      errorCode: null,
    );
    _sendFollowup(FollowupAction.confirmOutline);
  }

  /// 提交大纲修改意见，让 AI 重出大纲。
  void modifyOutline(String feedback) {
    final text = feedback.trim();
    if (text.isEmpty || !state.isAwaitingUser) return;
    state = state.copyWith(
      timeline: _resolveLastOutline(OutlineResolution.modified, text),
      phase: GenerationPhase.connecting,
      failure: null,
      errorCode: null,
    );
    _sendFollowup(FollowupAction.modifyOutline, text: text);
  }

  /// 失败后重试。
  ///
  /// 有 sessionId 就走 `retry` 恢复这场会话（后端当天只允许一场，重开会被拒）；
  /// 没有则说明连第一帧都没拿到，整场重发。
  void retry() {
    if (state.isBusy) return;
    final sessionId = state.sessionId;
    final query = state.originalQuery;

    if ((sessionId ?? "").isNotEmpty) {
      state = state.copyWith(
        phase: GenerationPhase.connecting,
        failure: null,
        errorCode: null,
      );
      _sendFollowup(FollowupAction.retry);
      return;
    }

    if (query == null || query.isEmpty) return;
    start(query);
  }

  /// 用户主动停止生成。
  ///
  /// 停止**不是失败**：断流后停在"等用户处理"的状态，已生成的内容留着，
  /// 底部给重试入口。所以这里不写 failure。
  void stop() {
    if (!state.isBusy) return;
    _disposeStream();
    state = state.copyWith(
      timeline: _freezeStreamingNovel(),
      phase: GenerationPhase.failed,
      stage: null,
    );
  }

  // ───────────────────────── 流的生命周期 ─────────────────────────

  CancelToken _newCancelToken() {
    _cancelToken = CancelToken();
    return _cancelToken!;
  }

  void _sendFollowup(FollowupAction action, {String? text}) {
    final sessionId = state.sessionId;
    // 没有 sessionId 就没法推进会话——这是内部状态错误，不该发出去被后端拒。
    if ((sessionId ?? "").isEmpty) {
      state = state.copyWith(
        phase: GenerationPhase.failed,
        failure: const Failure.unknown(),
      );
      return;
    }

    _listen(
      ref
          .read(storyGenerateRepositoryProvider)
          .followup(
            sessionId: sessionId!,
            action: action,
            // 后端靠它在 novel_done 时落库，每轮都要带。
            originalQuery: state.originalQuery ?? "",
            text: text,
            cancelToken: _newCancelToken(),
          ),
    );
  }

  void _listen(Stream<GenerationEvent> source) {
    _disposeStream();
    _receivedAnyEvent = false;
    _subscription = source.listen(
      _onEvent,
      onError: _onError,
      onDone: _finishRound,
      cancelOnError: true,
    );
  }

  /// 断开当前流。取消 token 会让 Dio 主动关连接，而不是留着慢慢超时。
  void _disposeStream() {
    _subscription?.cancel();
    _subscription = null;
    _cancelToken?.cancel();
    _cancelToken = null;
  }

  void _onEvent(GenerationEvent event) {
    _receivedAnyEvent = true;
    // sessionId 在任何事件上都可能带，见一次记一次（首帧 status 常常是唯一来源）。
    final sessionId = event.sessionId.isNotEmpty
        ? event.sessionId
        : state.sessionId;

    switch (event) {
      case GenerationStatusEvent(:final stage):
        state = state.copyWith(sessionId: sessionId, stage: stage);

      case GenerationClarificationEvent(:final card):
        state = state.copyWith(
          sessionId: sessionId,
          timeline: <GenerationEntry>[
            ...state.timeline,
            GenerationEntry.clarification(card: card),
          ],
          phase: GenerationPhase.awaitingUser,
          stage: null,
        );

      case GenerationOutlineEvent(:final outline):
        state = state.copyWith(
          sessionId: sessionId,
          timeline: <GenerationEntry>[
            ...state.timeline,
            GenerationEntry.outline(outline: outline),
          ],
          phase: GenerationPhase.awaitingUser,
          stage: null,
        );

      case GenerationNovelStartEvent():
        state = state.copyWith(
          sessionId: sessionId,
          timeline: <GenerationEntry>[
            ...state.timeline,
            const GenerationEntry.novel(content: ""),
          ],
          phase: GenerationPhase.streaming,
          stage: null,
        );

      case GenerationDeltaEvent(:final text):
        state = state.copyWith(
          sessionId: sessionId,
          timeline: _appendDelta(text),
          phase: GenerationPhase.streaming,
          stage: null,
        );

      case GenerationDoneEvent():
        _onDone(event, sessionId);

      case GenerationFailedEvent(:final code, :final message):
        state = state.copyWith(
          sessionId: sessionId,
          timeline: _freezeStreamingNovel(),
          phase: GenerationPhase.failed,
          stage: null,
          errorCode: code,
          // 后端给了文案就用后端的（它更具体），否则按未知失败兜底。
          // 用 server 而不是 business：`error` 事件不带业务码，只有一句人话，
          // 硬凑一个 code 会让 Failure.business 的语义失真。
          failure: message == null || message.isEmpty
              ? const Failure.unknown()
              : Failure.server(message: message),
        );

      // 上游新增的、我们还不认识的事件类型：忽略，不打断生成。
      case GenerationUnknownEvent():
        break;
    }
  }

  void _onDone(GenerationDoneEvent event, String? sessionId) {
    final timeline = _freezeStreamingNovel();
    // 全文优先用后端的 full_text；它没带就用累加的增量兜底（服务端自己也是这个策略）。
    final streamed = timeline.whereType<GenerationNovelEntry>().lastOrNull;
    final content = (event.fullText?.isNotEmpty ?? false)
        ? event.fullText!
        : (streamed?.content ?? "");

    state = state.copyWith(
      sessionId: sessionId,
      // 用 full_text 覆盖流式累加的结果：两者偶有出入时以后端落库的那份为准。
      timeline: _replaceLastNovel(timeline, content),
      phase: GenerationPhase.done,
      stage: null,
      failure: null,
      errorCode: null,
      result: GeneratedStory(
        content: content,
        title: event.title,
        scriptId: event.scriptId,
        conversationId: event.conversationId,
        currentVersionMessageId: event.currentVersionMessageId,
      ),
    );
  }

  void _onError(Object error, StackTrace stackTrace) {
    state = state.copyWith(
      timeline: _freezeStreamingNovel(),
      phase: GenerationPhase.failed,
      stage: null,
      // Repository 抛的是 Failure；其余情况按未知兜底。
      failure: error is Failure ? error : const Failure.unknown(),
    );
  }

  /// 一轮流正常关闭时的收尾。
  ///
  /// 服务端每轮说完就关流，所以"关了"通常是正常的：此时状态已由最后一个事件
  /// 决定（等作答 / 已完成）。唯一要处理的是**一个事件都没收到就关了**——那是
  /// 静默失败，不兜住的话页面会永远停在"思考中"。
  void _finishRound() {
    _subscription = null;
    if (_receivedAnyEvent) {
      // 收到过事件但仍停在 connecting/streaming：服务端提前收尾，按失败处理，
      // 否则进行态转圈不会停。
      if (state.isBusy) {
        state = state.copyWith(
          timeline: _freezeStreamingNovel(),
          phase: GenerationPhase.failed,
          stage: null,
          failure: const Failure.unknown(),
        );
      }
      return;
    }
    // 连上了却一帧都没解析出来。**这不是网络问题**——网络断了 `postSse` 会抛
    // AppException 走 _onError。走到这里说明服务端确实回了东西，只是不是 SSE
    // （多半是一个普通 JSON 错误体，被解码器当成无效字段全丢了）。
    // 报成"网络不可用"会让用户白折腾 WiFi，所以归到 server。
    state = state.copyWith(
      phase: GenerationPhase.failed,
      stage: null,
      failure: const Failure.server(),
    );
  }

  // ───────────────────────── timeline 变换 ─────────────────────────

  /// 把增量追加到最后一条正文上。没有正文条目时补一条——上游偶尔会跳过
  /// `novel_start` 直接发 delta，不兜住就整篇内容无处可放。
  List<GenerationEntry> _appendDelta(String delta) {
    if (delta.isEmpty) return state.timeline;
    final timeline = List<GenerationEntry>.of(state.timeline);
    final index = timeline.lastIndexWhere(
      (entry) => entry is GenerationNovelEntry,
    );

    if (index < 0) {
      timeline.add(GenerationEntry.novel(content: delta));
      return timeline;
    }
    final current = timeline[index] as GenerationNovelEntry;
    timeline[index] = current.copyWith(content: current.content + delta);
    return timeline;
  }

  /// 把最后一条正文的流式态关掉（生成结束/失败/停止时用），光标随之消失。
  List<GenerationEntry> _freezeStreamingNovel() {
    final timeline = List<GenerationEntry>.of(state.timeline);
    final index = timeline.lastIndexWhere(
      (entry) => entry is GenerationNovelEntry,
    );
    if (index < 0) return timeline;
    timeline[index] = (timeline[index] as GenerationNovelEntry).copyWith(
      isStreaming: false,
    );
    return timeline;
  }

  List<GenerationEntry> _replaceLastNovel(
    List<GenerationEntry> source,
    String content,
  ) {
    if (content.isEmpty) return source;
    final timeline = List<GenerationEntry>.of(source);
    final index = timeline.lastIndexWhere(
      (entry) => entry is GenerationNovelEntry,
    );
    if (index < 0) {
      timeline.add(GenerationEntry.novel(content: content, isStreaming: false));
      return timeline;
    }
    timeline[index] = (timeline[index] as GenerationNovelEntry).copyWith(
      content: content,
      isStreaming: false,
    );
    return timeline;
  }

  /// 把最后一张未作答的澄清卡标记为已回答。
  List<GenerationEntry> _resolveLastClarification(String answer) {
    final timeline = List<GenerationEntry>.of(state.timeline);
    final index = timeline.lastIndexWhere(
      (entry) => entry is GenerationClarificationEntry && entry.answer == null,
    );
    if (index < 0) return timeline;
    timeline[index] = (timeline[index] as GenerationClarificationEntry)
        .copyWith(answer: answer);
    return timeline;
  }

  /// 把最后一张未决的大纲卡标记为已处置。
  List<GenerationEntry> _resolveLastOutline(
    OutlineResolution resolution,
    String? feedback,
  ) {
    final timeline = List<GenerationEntry>.of(state.timeline);
    final index = timeline.lastIndexWhere(
      (entry) => entry is GenerationOutlineEntry && entry.resolution == null,
    );
    if (index < 0) return timeline;
    timeline[index] = (timeline[index] as GenerationOutlineEntry).copyWith(
      resolution: resolution,
      feedback: feedback,
    );
    return timeline;
  }
}
