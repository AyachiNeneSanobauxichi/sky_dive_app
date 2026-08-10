import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_generate/controllers/index.dart";
import "package:happy_os/features/story_generate/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/utils/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 生成页：把一句心愿变成一篇成稿的完整过程（`agent/service/story-generate/`）。
///
/// ## 为什么是时间线，不是左右气泡
/// 一次生成是一条**有先后的旅程**（心愿 → 反问 → 大纲 → 正文），不是两个人来回聊。
/// 左右气泡表达"谁说的"，时间线表达"到哪一步了"——后者才是用户在这一页真正关心的。
///
/// ## 四态
/// - 加载：首帧未到 → [GenerationStatusIndicator]（轮播阶段文案 + 已等待秒数，
///   这段窗口可能好几秒，没有明确且**在变化**的进行态用户就会反复触发）；
/// - 空：没带心愿进来（语音入口）→ 心愿输入引导；
/// - 错误：内联 [HappyRetryCard]，**已生成的内容保留在上方不清屏**；
/// - 有数据：时间线。
///
/// ## 防重复提交
/// 进行中时所有输入入口一律禁用（卡片按钮传 `enabled: false`），底部主行动变成
/// 「停止生成」。生成中返回会二次确认——退出就等于丢掉这次生成。
class StoryGenerateScreen extends ConsumerStatefulWidget {
  const StoryGenerateScreen({super.key, this.seed});

  /// 从故事页带来的心愿文本。有它就**自动开始生成**，不让用户再点一次；
  /// 没有则落到心愿输入态。
  final String? seed;

  @override
  ConsumerState<StoryGenerateScreen> createState() =>
      _StoryGenerateScreenState();
}

class _StoryGenerateScreenState extends ConsumerState<StoryGenerateScreen> {
  final ScrollController _scrollController = ScrollController();

  /// 上一帧的时间线长度与正文长度，用来判断"有没有新内容"决定要不要跟随滚动。
  int _lastEntryCount = 0;
  int _lastContentLength = 0;

  @override
  void initState() {
    super.initState();
    final seed = widget.seed?.trim() ?? "";
    if (seed.isEmpty) return;
    // 带着心愿进来就直接开跑。放到首帧之后：build 期间不能改 provider 状态。
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAfterEntry(seed));
  }

  /// 等入场转场落定，再发起请求。
  ///
  /// 不是为了动画好看：转场结束的那一刻 Overlay 会翻转前后两条路由的 `TickerMode`，
  /// 而请求若在此之前就失败，进行态（思考指示器的波点与流光文字、底部「停止生成」）
  /// 会**在同一帧被拆掉**。两件事撞在一起就会刷
  /// "Looking up a deactivated widget's ancestor is unsafe"。
  /// 等转场落定后再开始，所有状态切换都发生在稳定的树上。
  ///
  /// 代价是慢几百毫秒——相对一次几十秒的生成可以忽略，而且心愿卡片已经先渲染出来了，
  /// 用户看到的不是白屏。
  Future<void> _startAfterEntry(String seed) async {
    final animation = ModalRoute.of(context)?.animation;
    if (animation != null && !_isSettled(animation.status)) {
      final settled = Completer<void>();
      void onStatus(AnimationStatus status) {
        if (!_isSettled(status)) return;
        animation.removeStatusListener(onStatus);
        if (!settled.isCompleted) settled.complete();
      }

      animation.addStatusListener(onStatus);
      await settled.future;
    }
    if (!mounted) return;
    ref.read(storyGenerateControllerProvider.notifier).start(seed);
  }

  /// 转场是否已停下（到位或退回）。
  static bool _isSettled(AnimationStatus status) =>
      status == AnimationStatus.completed ||
      status == AnimationStatus.dismissed;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 跟随滚动到底部。
  ///
  /// 只在**有新内容**时滚，不是每帧都滚：否则用户往回翻看前面的澄清问答时会被
  /// 一直拽回底部。用 jumpTo 而不是 animateTo——流式增量每秒来很多次，
  /// 排队的动画会互相打断变成抖动。
  void _followBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _onStateChanged(StoryGenerateState state) {
    final contentLength = state.timeline
        .whereType<GenerationNovelEntry>()
        .fold<int>(0, (sum, entry) => sum + entry.content.length);
    final hasNew =
        state.timeline.length != _lastEntryCount ||
        contentLength != _lastContentLength;
    _lastEntryCount = state.timeline.length;
    _lastContentLength = contentLength;
    if (hasNew) _followBottom();
  }

  /// 生成中返回：二次确认，避免误触丢掉整次生成。
  Future<bool> _confirmLeave(AppLocalizations l10n) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.storyGenerateLeaveTitle),
        content: Text(l10n.storyGenerateLeaveBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.storyGenerateLeaveConfirm),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(storyGenerateControllerProvider);
    final controller = ref.read(storyGenerateControllerProvider.notifier);

    // 跟随滚动放在 listen 而不是 build 里：滚动是副作用，build 应当只描述 UI。
    ref.listen(storyGenerateControllerProvider, (_, next) {
      _onStateChanged(next);
    });

    return PopScope(
      // 生成中拦截返回；其余阶段正常返回。
      canPop: !state.isBusy,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // 先取出 navigator：await 之后再碰 context 会踩 use_build_context_synchronously。
        final navigator = Navigator.of(context);
        if (!await _confirmLeave(l10n)) return;
        if (!mounted) return;
        controller.stop();
        navigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            // 写完了就把标题换成故事名——它比"生成爽文"更值得占这一行。
            state.result?.title?.isNotEmpty ?? false
                ? state.result!.title!
                : l10n.storyGenerateTitle,
          ),
        ),
        // 关掉星野视差：这一页是长文（生成中逐段落地、生成完通读），
        // 背景跟着滚会一直牵着眼睛走，而读长文要的是静。
        body: HappyStarfieldBackground(
          parallax: false,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: state.phase == GenerationPhase.idle
                      ? _IdleView(
                          seed: widget.seed,
                          onSubmit: controller.start,
                          l10n: l10n,
                        )
                      : _Timeline(
                          state: state,
                          controller: controller,
                          scrollController: _scrollController,
                          l10n: l10n,
                          // 时间格式跟着 locale 走：中文 24 小时制、英文按系统习惯，
                          // 硬编码 "HH:mm" 在部分英文区会显得别扭。
                          timeFormat: DateFormat.Hm(
                            Localizations.localeOf(context).toLanguageTag(),
                          ),
                        ),
                ),
                _BottomBar(state: state, controller: controller, l10n: l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 空态：没带心愿进来时，先把话补上。
class _IdleView extends StatelessWidget {
  const _IdleView({
    required this.seed,
    required this.onSubmit,
    required this.l10n,
  });

  final String? seed;
  final ValueChanged<String> onSubmit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HappySemanticSpacing.itemGap,
        children: <Widget>[
          const SizedBox(height: HappySemanticSpacing.sectionGap),
          Text(l10n.storyGenerateIdleTitle, style: theme.textTheme.titleLarge),
          Text(
            l10n.storyGenerateIdleBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: HappySemanticSpacing.itemGap),
          WishComposer(
            hint: l10n.storyGenerateComposerHint,
            submitLabel: l10n.storyGenerateStart,
            enabled: true,
            initialText: seed,
            onSubmit: onSubmit,
            localeId: speechLocaleIdOf(context),
            listeningLabel: l10n.storyVoiceListening,
            voiceStartLabel: l10n.speechStart,
            voiceStopLabel: l10n.speechStop,
            onSpeechUnavailable: (availability) =>
                HappyToast.error(context, speechMessageOf(l10n, availability)),
            onSpeechEmpty: () =>
                HappyToast.info(context, l10n.storyVoiceNoResult),
          ),
        ],
      ),
    );
  }
}

/// 时间线本体。
class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.state,
    required this.controller,
    required this.scrollController,
    required this.l10n,
    required this.timeFormat,
  });

  final StoryGenerateState state;
  final StoryGenerateController controller;
  final ScrollController scrollController;
  final AppLocalizations l10n;

  /// 条目时间戳的格式化器。在页面层按 locale 建一次，不要每条目各建一个
  /// ——`DateFormat` 的构造要读 locale 数据，不便宜。
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    // 用 Column 而不是 ListView.separated：时间线最多十来条（长的是**单条**正文，
    // 不是很多条），懒加载省不到东西，却把带 ticker 的进行态组件交给 sliver 去回收
    // ——同一个下标上「思考指示器」换成「重试卡」时，那批 ticker 会在一帧里被拆掉，
    // 正是 "Looking up a deactivated widget's ancestor" 断言的来源之一。
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HappySemanticSpacing.itemGap,
        children: <Widget>[
          for (final (index, entry) in state.timeline.indexed)
            KeyedSubtree(key: ValueKey<int>(index), child: _entryView(entry)),
          // 进行态与失败卡各自带**固定 key**：两者在同一个位置交替出现，没有 key
          // 时 Flutter 会试图就地更新，带 ticker 的子树最容易在这一步出问题。
          if (state.phase == GenerationPhase.connecting)
            GenerationStatusIndicator(
              key: const ValueKey<String>("status-thinking"),
              phrases: waitingPhrasesFor(l10n, state.waitStage),
              elapsedLabel: l10n.storyGenerateElapsed,
            ),
          if (state.failure case final Failure failure)
            HappyRetryCard(
              key: const ValueKey<String>("status-retry"),
              message: state.canResume
                  ? l10n.storyGenerateResumeHint
                  : failure.displayMessage,
              retryLabel: state.canResume
                  ? l10n.storyGenerateResume
                  : l10n.commonRetry,
              onRetry: controller.retry,
              isRetrying: state.isBusy,
            ),
        ],
      ),
    );
  }

  Widget _entryView(GenerationEntry entry) => switch (entry) {
    GenerationWishEntry(:final text, :final createdAt) => WishEntryView(
      text: text,
      label: l10n.storyGenerateWishLabel,
      timeLabel: timeFormat.format(createdAt),
    ),
    GenerationClarificationEntry(
      :final card,
      :final answer,
      :final createdAt,
    ) =>
      ClarificationCardView(
        card: card,
        answer: answer,
        label: l10n.storyGenerateClarifyLabel,
        timeLabel: timeFormat.format(createdAt),
        // 只有"轮到用户作答"时才可交互：上一轮还在跑时禁用，防重复提交。
        enabled: state.isAwaitingUser,
        onSubmit: controller.answerClarification,
        submitLabel: l10n.storyGenerateClarifySubmit,
        answeredLabel: l10n.storyGenerateClarifyAnswered,
        customHint: l10n.storyGenerateClarifyCustomHint,
      ),
    GenerationOutlineEntry(
      :final outline,
      :final resolution,
      :final feedback,
      :final createdAt,
    ) =>
      OutlineCardView(
        outline: outline,
        resolution: resolution,
        feedback: feedback,
        timeLabel: timeFormat.format(createdAt),
        enabled: state.isAwaitingUser,
        onConfirm: controller.confirmOutline,
        onModify: controller.modifyOutline,
        title: l10n.storyGenerateOutlineTitle,
        endingLabel: l10n.storyGenerateOutlineEnding,
        emptyLabel: l10n.storyGenerateOutlineEmpty,
        confirmLabel: l10n.storyGenerateOutlineConfirm,
        modifyLabel: l10n.storyGenerateOutlineModify,
        feedbackHint: l10n.storyGenerateOutlineFeedbackHint,
        confirmedLabel: l10n.storyGenerateOutlineConfirmed,
        modifiedLabel: l10n.storyGenerateOutlineModified,
      ),
    GenerationNovelEntry(
      :final content,
      :final isStreaming,
      :final createdAt,
    ) =>
      NovelEntryView(
        content: content,
        isStreaming: isStreaming,
        label: l10n.storyGenerateNovelLabel,
        timeLabel: timeFormat.format(createdAt),
      ),
  };
}

/// 底部行动条。每个阶段只给**当下唯一该做的事**，不堆按钮。
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.state,
    required this.controller,
    required this.l10n,
  });

  final StoryGenerateState state;
  final StoryGenerateController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final child = switch (state.phase) {
      // 生成中：唯一的行动是叫停。
      GenerationPhase.connecting || GenerationPhase.streaming => HappyButton(
        label: l10n.storyGenerateStop,
        icon: LucideIcons.square,
        variant: HappyButtonVariant.secondary,
        onPressed: controller.stop,
      ),
      // 写完了：读全文（主）+ 再写一篇（次）。
      GenerationPhase.done => Row(
        spacing: HappySemanticSpacing.labelGap,
        children: <Widget>[
          Expanded(
            child: HappyButton(
              label: l10n.storyGenerateWriteAnother,
              icon: LucideIcons.rotateCcw,
              variant: HappyButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: HappyButton(
              label: l10n.storyGenerateReadFull,
              icon: LucideIcons.bookOpen,
              // 后端没落库就没有可读的正文，禁用而不是点了报错。
              // TODO(story-generate): 阅读页尚未开工，先给"即将上线"。页面就绪后
              //   改成带 `result.scriptId` 跳阅读页。
              onPressed: (state.result?.isPersisted ?? false)
                  ? () => HappyToast.info(context, l10n.commonComingSoon)
                  : null,
            ),
          ),
        ],
      ),
      // 停止后（failed 但没有 failure）唯一的出路在这里：内联重试卡只在**出错**时
      // 出现，主动停止不算错误、不该弹错误卡，但也不能让人卡在原地没法继续。
      GenerationPhase.failed when state.failure == null => HappyButton(
        label: l10n.storyGenerateContinue,
        icon: LucideIcons.play,
        onPressed: controller.retry,
      ),
      // 等用户作答时不放底部按钮：动作在卡片上，底部再放一个会让人不知道点哪个。
      // 出错时的重试入口也在时间线里（内联卡），这里保持空。
      GenerationPhase.idle ||
      GenerationPhase.awaitingUser ||
      GenerationPhase.failed => null,
    };

    if (child == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      child: child,
    );
  }
}
