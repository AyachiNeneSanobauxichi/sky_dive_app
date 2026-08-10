import "dart:async";

import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_generate/controllers/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 按当前所处的创作步骤取一组等待文案。
///
/// 分池而不是共用一个大池：等大纲时冒出一句"在琢磨开头第一句"是**假进度**——
/// 文案一旦和实际进度对不上，用户下次就不再信它了。
///
/// TODO(story-generate): 后端 `status` 事件的 `stage` 取值尚未定义
///   （见 `agent/service/story-generate/story-generate.api.md`）。定下来之后
///   改为优先按 stage 选词，本地推断退化为兜底。
List<String> waitingPhrasesFor(
  AppLocalizations l10n,
  GenerationWaitStage stage,
) => switch (stage) {
  GenerationWaitStage.understanding => <String>[
    l10n.storyGenerateWaitReading,
    l10n.storyGenerateWaitFeeling,
    l10n.storyGenerateWaitAngle,
    l10n.storyGenerateWaitQuestion,
  ],
  GenerationWaitStage.outlining => <String>[
    l10n.storyGenerateWaitFrame,
    l10n.storyGenerateWaitBeats,
    l10n.storyGenerateWaitTwist,
    l10n.storyGenerateWaitEnding,
  ],
  GenerationWaitStage.writing => <String>[
    l10n.storyGenerateWaitOpening,
    l10n.storyGenerateWaitScene,
    l10n.storyGenerateWaitLines,
    l10n.storyGenerateWaitPolish,
  ],
};

/// 生成等待态：三点波浪 + 轮播的阶段文案 + 已等待时长。
///
/// ## 为什么要轮播，而不是一句话挂到底
/// 这段窗口可能长达几十秒。一句不动的"正在读你的经历…"看三秒就失去信息量，用户会
/// 开始怀疑是不是卡住了（然后返回、重试、投诉）。文案每隔几秒换一句，**换的动作本身
/// 就是"它还活着"的证据**，而且顺带把 AI 到底在忙什么讲清楚——等待才有了内容。
///
/// 文案池由调用方按当前步骤传入（理解 / 搭大纲 / 动笔各有各的说法），
/// 全部来自 `AppLocalizations`（红线 #9）。
///
/// ## 为什么还要显示秒数
/// 未知的等待最难熬。一个在走的秒数把"不知道要多久"变成"已经等了 12 秒"，
/// 用户对进度有了量感就不会反复触发。前 [_elapsedRevealSeconds] 秒不显示：
/// 秒表一上来就跳会把"这很慢"这件事提前暗示给用户。
class GenerationStatusIndicator extends StatefulWidget {
  const GenerationStatusIndicator({
    super.key,
    required this.phrases,
    required this.elapsedLabel,
  });

  /// 轮播文案池。按顺序循环，不随机——同一场生成里再看到同一句时，
  /// 顺序一致会让人觉得是有节奏的进度，随机则像是在抽奖。
  final List<String> phrases;

  /// 已等待时长的文案模板（接收秒数）。
  final String Function(int seconds) elapsedLabel;

  @override
  State<GenerationStatusIndicator> createState() =>
      _GenerationStatusIndicatorState();
}

class _GenerationStatusIndicatorState extends State<GenerationStatusIndicator> {
  Timer? _timer;

  /// 已经过的秒数。组件的生命周期就是**这一轮等待**的生命周期（上层只在
  /// connecting 阶段挂它），所以从 initState 起算即可，不必把起始时刻塞进状态。
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!mounted) return;
    setState(() => _seconds++);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  /// 当前该显示哪句。秒数 ÷ 停留时长再对文案数取模，一个计时器同时驱动两件事。
  String get _phrase {
    if (widget.phrases.isEmpty) return "";
    final index = (_seconds ~/ _phraseHoldSeconds) % widget.phrases.length;
    return widget.phrases[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phrase = _phrase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Row(
          spacing: HappySpacing.s12,
          children: <Widget>[
            // 三点波浪：文案在换的间隙里，它是"还在跑"的连续证据。
            const HappyThinkingIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: HappyMotion.normal,
                switchInCurve: HappyMotion.entrance,
                switchOutCurve: HappyMotion.exit,
                // 淡入淡出叠一点上移：换句子是"翻页"不是"闪一下"，
                // 纯 fade 在流光文字上容易被误读成渲染抖动。
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, _switchSlideOffset),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: HappyShimmerText(
                  // key 带上文案本身：没有它 AnimatedSwitcher 会认为是同一个子树，
                  // 直接原地换字、转场根本不触发。
                  key: ValueKey<String>(phrase),
                  text: phrase,
                ),
              ),
            ),
          ],
        ),
        if (_seconds >= _elapsedRevealSeconds)
          Text(
            widget.elapsedLabel(_seconds),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              // 等宽数字：秒数跳动时这一行不会左右抖。
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
      ],
    );
  }
}

/// 单句停留时长。太短像走马灯读不完，太长又回到"一句挂到底"的老问题。
const int _phraseHoldSeconds = 4;

/// 等多久才开始显示秒数。
const int _elapsedRevealSeconds = 5;

/// 换句子时的上移距离（相对文字高度）。
const double _switchSlideOffset = 0.35;
