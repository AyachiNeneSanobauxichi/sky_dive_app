import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/controllers/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/features/story/widgets/index.dart";
import "package:happy_os/features/story_history/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/utils/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// story 模块主页（v2）：创作入口 + 生成历史。首页第 1 个 tab，产品主路径。
///
/// 自上而下三段，对应"先给话头 → 再开口 → 回头看"：
/// 1. **灵感一下**：三条具体的句子 + 换一换。放在最前面是因为"不知道写什么"才是
///    真正的门槛——先让人看到能直接下笔的开头，再把输入入口递过去；
/// 2. **创作入口**（[StoryComposer]）：居中突出的语音圆钮（按住说话）+ 文本入口，
///    两条路径都通向对话页。挨着灵感放，挑中一条的下一秒就能开口；
/// 3. **生成历史**：只露最近几条 + 「查看全部」进全量页。这一屏的主角是创作，
///    历史是"回头看一眼"；铺满一屏会把创作入口挤到屏幕外。数据来自
///    `features/story_history`（全应用唯一的历史数据源）。
///
/// 没有 AppBar：第一屏留给"今天想写什么"这句招呼，再顶一行"我的故事"是重复信息。
///
/// 打字时**把灵感区折叠起来**：已经在写了就不需要话头，收起来能把输入区顶到屏幕
/// 中部、把右下角的生成键完整露出来。点页面空白处（或向下拖）失焦收键盘——
/// 输入区在页面中部，没有这两条用户想看下面的历史时得先找收起键。
///
/// 四态齐全（历史列表）：加载=骨架屏 / 空=引导去用上面的灵感 / 错误=内联重试卡 /
/// 有数据=列表。灵感区自己也有加载骨架。
class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  /// 输入框是否正在被编辑（决定灵感区折不折叠）。
  bool _isComposing = false;

  /// 首页那几条历史读的是「全部」这一格——和历史页的第一个分类**共用同一份数据**，
  /// 点进去是秒开的，两处的收藏/删除结果也天然一致。
  static final _historyProvider = storyHistoryControllerProvider(
    StoryScriptFilter.all,
  );

  void _onComposerFocusChanged(bool hasFocus) {
    if (_isComposing == hasFocus) return;
    setState(() => _isComposing = hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(_historyProvider);
    final inspirations = ref.watch(inspirationControllerProvider);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      body: SafeArea(
        // 底部不留：外壳的导航条自己会让出手势条高度。
        bottom: false,
        // 点空白处收键盘：translucent 让空白区也能接到点击，
        // 而按钮/输入框自己会赢下手势竞争，不受影响。
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: RefreshIndicator(
            onRefresh: () => ref.read(_historyProvider.notifier).reload(),
            child: ListView(
              // 往下拖也收键盘：想看下面的历史时不必先找收起键。
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: HappySemanticSpacing.screenPadding,
                right: HappySemanticSpacing.screenPadding,
                top: HappySemanticSpacing.cardPadding,
                bottom: HappySemanticSpacing.sectionGap,
              ),
              children: <Widget>[
                // 招呼与历史入口同排：入口常驻右上角，不必滚到页面底部的「查看全部」。
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.storyGreeting,
                        style: theme.textTheme.displaySmall,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          context.pushNamed(RouteName.storyHistory),
                      icon: const Icon(
                        LucideIcons.history,
                        size: HappyIconSize.sm,
                      ),
                      label: Text(l10n.storyHistoryEntry),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HappySpacing.s8),
                Text(
                  l10n.storyGreetingBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                // 打字时折叠：AnimatedSize 把高度平滑收到 0，不是"啪"一下消失。
                AnimatedSize(
                  duration: HappyMotion.normal,
                  curve: HappyMotion.standard,
                  alignment: Alignment.topCenter,
                  child: _isComposing
                      ? const SizedBox(width: double.infinity)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: HappySemanticSpacing.sectionGap,
                            ),
                            _InspirationBlock(
                              state: inspirations,
                              onShuffle: () => ref
                                  .read(inspirationControllerProvider.notifier)
                                  .shuffle(),
                              // 把选中的那句灵感**当心愿带过去**：点了灵感却落到
                              // 空输入页，等于让人自己再抄一遍。
                              onSelect: (prompt) =>
                                  _openGenerate(context, seed: prompt.text),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: HappySemanticSpacing.sectionGap),
                StoryComposer(
                  hint: l10n.storyComposerHint,
                  holdHint: l10n.storyVoiceHoldHint,
                  releaseHint: l10n.storyVoiceReleaseHint,
                  listeningHint: l10n.storyVoiceListening,
                  cancelHint: l10n.storyVoiceCancelHint,
                  cancelReleaseHint: l10n.storyVoiceCancelReleaseHint,
                  submitLabel: l10n.storyComposerSubmit,
                  submitHint: l10n.storyComposerSubmitHint,
                  remainingLabel: l10n.storyComposerRemaining,
                  localeId: speechLocaleIdOf(context),
                  onFocusChanged: _onComposerFocusChanged,
                  onSubmit: (text) => _openGenerate(context, seed: text),
                  // 语音说完文字就落在输入框里，不再直接跳页：识别会出错，
                  // 得让用户先看一眼、能改，再自己点生成。
                  onSpeechUnavailable: (availability) => HappyToast.error(
                    context,
                    speechMessageOf(l10n, availability),
                  ),
                  onSpeechEmpty: () =>
                      HappyToast.info(context, l10n.storyVoiceNoResult),
                  // 短按不开麦，先把"要按住"这个手势教给用户。
                  onVoiceTapped: () =>
                      HappyToast.info(context, l10n.storyVoiceHoldHint),
                ),
                const SizedBox(height: HappySemanticSpacing.sectionGap),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.storyHistoryTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    // 首页只露最近几条，全量翻阅去历史页。
                    TextButton.icon(
                      onPressed: () =>
                          context.pushNamed(RouteName.storyHistory),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(
                        LucideIcons.chevronRight,
                        size: HappyIconSize.sm,
                      ),
                      label: Text(l10n.storyHistoryViewAll),
                    ),
                  ],
                ),
                const SizedBox(height: HappySpacing.s8),
                _HistoryBlock(
                  state: history,
                  onRetry: () =>
                      ref.read(_historyProvider.notifier).reload(showSkeleton: true),
                  onEmptyAction: () => _openGenerate(context),
                  onOpenStory: (script) => _openDetail(context, script.id),
                  onToggleFavorite: _toggleFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 收藏 / 取消收藏。乐观更新在控制器里做，这里只负责把失败讲给用户听——
  /// 星标已经被回滚了，不给提示的话用户只会看到它自己弹回去。
  Future<void> _toggleFavorite(StoryScript script) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(_historyProvider.notifier).toggleFavorite(script.id);
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(
        context,
        e is Failure ? e.displayMessage : l10n.storyHistoryLoadFailed,
      );
    }
  }

  /// 进生成页。[seed] 是心愿文本（用户打的那段话，或选中的那条灵感），带过去就
  /// 直接开跑；不带（语音入口）则由生成页先请用户补一句。
  void _openGenerate(BuildContext context, {String? seed}) {
    context.pushNamed(
      RouteName.storyGenerate,
      queryParameters: <String, String>{
        if (seed != null && seed.isNotEmpty) RouteQuery.generateSeed: seed,
      },
    );
  }

  /// 进爽文详情。首页预览卡和历史全量页走同一条详情路由。
  void _openDetail(BuildContext context, String scriptId) {
    context.pushNamed(
      RouteName.storyHistoryDetail,
      queryParameters: <String, String>{RouteQuery.scriptId: scriptId},
    );
  }
}

/// 灵感区的三态：加载=骨架（三张占位卡）/ 有数据=真提示 / 出错=直接不显示这一区。
///
/// 灵感是"锦上添花"的区块：它挂了不该拦住用户去用上面的输入区，所以错误态选择
/// **静默降级**（不占位、不报错），而不是给一张让人分心的错误卡。
class _InspirationBlock extends StatelessWidget {
  const _InspirationBlock({
    required this.state,
    required this.onShuffle,
    required this.onSelect,
  });

  final AsyncValue<List<InspirationPrompt>> state;
  final VoidCallback onShuffle;
  final ValueChanged<InspirationPrompt> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget section(List<InspirationPrompt> prompts) => StoryInspirationSection(
      title: l10n.storyInspirationTitle,
      shuffleLabel: l10n.storyInspirationShuffle,
      prompts: prompts,
      onShuffle: onShuffle,
      onSelect: onSelect,
    );

    return switch (state) {
      AsyncData(:final value) => section(value),
      AsyncError() => const SizedBox.shrink(),
      _ => Skeletonizer(child: section(_skeletonPrompts)),
    };
  }

  /// 骨架用的占位提示：长度贴近真实句子，骨架条才不会明显短一截。
  static const List<InspirationPrompt> _skeletonPrompts = <InspirationPrompt>[
    InspirationPrompt(id: "sk1", text: "一次被当众否定，后来我怎么翻回来的"),
    InspirationPrompt(id: "sk2", text: "那个看不起我的人，后来求我帮忙"),
    InspirationPrompt(id: "sk3", text: "我一个人扛下了所有人都说做不到的事"),
  ];
}

/// 生成历史的四态。
///
/// 数据来自 `features/story_history`，和历史全量页**共用同一个控制器**：这里点星标
/// 收藏，进去看到的也是收藏的；从这里点进去还是秒开，不会再转一次圈。
class _HistoryBlock extends StatelessWidget {
  const _HistoryBlock({
    required this.state,
    required this.onRetry,
    required this.onEmptyAction,
    required this.onOpenStory,
    required this.onToggleFavorite,
  });

  final AsyncValue<StoryScriptPage> state;
  final VoidCallback onRetry;
  final VoidCallback onEmptyAction;
  final ValueChanged<StoryScript> onOpenStory;
  final ValueChanged<StoryScript> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    Widget list(List<StoryScript> scripts, {bool isSkeleton = false}) => Column(
      children: <Widget>[
        // 首页只露最近几条：这一屏的主角是创作入口，历史是"回头看一眼"。
        // 想翻完整清单走「查看全部」进历史页。
        for (final script in scripts.take(homePreviewCount))
          Padding(
            padding: const EdgeInsets.only(
              bottom: HappySemanticSpacing.itemGap,
            ),
            child: StoryScriptCard(
              script: script,
              timeLabel: storyRelativeTimeOf(
                l10n,
                script.createdAt,
                locale: locale,
              ),
              emptyTitleLabel: l10n.storyHistoryUntitled,
              favoriteLabel: script.isFavorited
                  ? l10n.storyHistoryUnfavorite
                  : l10n.storyHistoryFavorite,
              lengthLabel: lengthLabelOf(l10n, script.length),
              // 骨架上的按钮点了没有意义，但也不能真的可点——骨架期用户看到的是
              // 假数据，点中"某一篇"会收藏到一个不存在的 id 上。
              onTap: isSkeleton ? _noop : () => onOpenStory(script),
              onToggleFavorite: isSkeleton
                  ? _noop
                  : () => onToggleFavorite(script),
            ),
          ),
      ],
    );

    return switch (state) {
      AsyncData(:final value) when value.scripts.isEmpty => _HistoryEmpty(
        onAction: onEmptyAction,
      ),
      AsyncData(:final value) => list(value.scripts),
      AsyncError(:final error) => HappyRetryCard(
        message: error is Failure
            ? error.displayMessage
            : l10n.storyHistoryLoadFailed,
        retryLabel: l10n.commonRetry,
        onRetry: onRetry,
      ),
      // 骨架：两张卡就够表达"这里将有一个列表"，铺满一屏反而像真内容。
      _ => Skeletonizer(child: list(_skeletonScripts, isSkeleton: true)),
    };
  }

  static void _noop() {}

  static final List<StoryScript> _skeletonScripts = <StoryScript>[
    StoryScript(
      id: "sk1",
      title: "标题占位文字",
      summary: "这里是正文摘要的占位文字，长度和真实内容差不多，骨架条才不会短一截。",
      createdAt: DateTime(2026, 8, 4),
    ),
    StoryScript(
      id: "sk2",
      title: "标题占位文字",
      summary: "这里是正文摘要的占位文字，长度和真实内容差不多，骨架条才不会短一截。",
      createdAt: DateTime(2026, 8, 3),
    ),
  ];
}

/// 历史为空：不是兜底而是引导位——指向上面的灵感区，让用户有个能直接下笔的开头。
class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty({required this.onAction});

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  LucideIcons.bookOpen,
                  size: HappyIconSize.md,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: HappySpacing.s8),
                Text(
                  l10n.storyHistoryEmptyTitle,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: HappySpacing.s6),
            Text(
              l10n.storyHistoryEmptyBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HappySemanticSpacing.itemGap),
            HappyButton(
              label: l10n.storyHistoryEmptyAction,
              size: HappyButtonSize.small,
              isFullWidth: false,
              icon: LucideIcons.lightbulb,
              onPressed: onAction,
            ),
          ],
        ),
      ),
    );
  }
}
