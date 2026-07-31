import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/controllers/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "widgets/index.dart";

/// 故事生成页：写下一段真实经历 → 流式改写成惊险故事。
///
/// 这一页是整套流式基建的落地样板，重点解决三个流式 UI 的必修题：
/// 1. **首字之前的空窗**用 [HappyThinkingIndicator] 占住，否则用户会重复点生成；
/// 2. **失败不清屏**：已生成的半篇留在原地，重试卡内联在下方；
/// 3. **自动滚动但不抢滚动条**：用户手动往上翻看前文时，不要把他拽回底部。
class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  final _experienceController = TextEditingController();
  final _scrollController = ScrollController();

  /// 已提交的经历。与输入框内容分开保存：生成期间用户可能改了输入框，
  /// 但当前这篇故事对应的仍是提交那一刻的文本。
  String _submittedExperience = "";

  /// 距底部小于这个距离就认为"用户在追着看最新内容"，可以自动滚。
  static const double _pinToBottomThreshold = 80;

  @override
  void dispose() {
    _experienceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onGenerate() {
    final experience = _experienceController.text.trim();
    if (experience.isEmpty) return;
    setState(() => _submittedExperience = experience);
    // 收起键盘，把整屏让给故事
    FocusScope.of(context).unfocus();
    ref.read(storyGenerationControllerProvider.notifier).generate(experience);
  }

  void _onEditExperience() {
    ref.read(storyGenerationControllerProvider.notifier).reset();
    setState(() => _submittedExperience = "");
  }

  /// 内容增长时贴底滚动。
  ///
  /// 判定在**状态更新之前**做（此时 position 还是旧布局的），
  /// 这样"用户是否在底部"反映的是他看新内容前的真实意图。
  void _autoScrollIfPinned() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final pinned =
        position.maxScrollExtent - position.pixels < _pinToBottomThreshold;
    if (!pinned) return;

    // 等新内容布局完再滚，否则 maxScrollExtent 还是旧值
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(storyGenerationControllerProvider);

    // 只在流式推进时触发自动滚动
    ref.listen<StoryGenerationState>(storyGenerationControllerProvider, (
      previous,
      next,
    ) {
      if (next is StoryStreaming) _autoScrollIfPinned();
    });

    return Scaffold(
      body: HappyAuroraBackground(
        intensity: 0.7,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(l10n.storyTitle)),
          body: SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: HappySemanticSpacing.screenPadding,
                      vertical: HappySpacing.s12,
                    ),
                    child: _buildContent(context, l10n, state),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    HappySemanticSpacing.screenPadding,
                  ),
                  child: _buildActions(l10n, state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 滚动区内容：按状态切换。
  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    StoryGenerationState state,
  ) {
    if (state is StoryIdle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HappySemanticSpacing.itemGap,
        children: <Widget>[
          Text(l10n.storyComposerTitle, style: _titleStyle(context)),
          Text(
            l10n.storyComposerSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: HappySpacing.s4),
          ExperienceComposer(
            controller: _experienceController,
            hint: l10n.storyComposerHint,
          ),
        ],
      ).animate().fadeIn(duration: HappyMotion.normal);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySemanticSpacing.sectionGap,
      children: <Widget>[
        ExperienceChip(
          experience: _submittedExperience,
          label: l10n.storyExperienceLabel,
          editTooltip: l10n.storyEditExperience,
          // 生成中不允许改经历：改了会和正在流的这篇对不上
          onEdit: state.isBusy ? null : _onEditExperience,
        ),
        if (state is StoryThinking)
          HappyThinkingIndicator(label: l10n.storyThinking)
        else
          HappyStreamingText(
            text: state.currentText,
            isStreaming: state is StoryStreaming,
          ),
        if (state is StoryCompleted && state.stoppedByUser)
          Text(l10n.storyStopped, style: _mutedLabelStyle(context)),
        if (state is StoryFailed)
          HappyRetryCard(
            message: state.failure.displayMessage,
            retryLabel: l10n.commonRetry,
            onRetry: () =>
                ref.read(storyGenerationControllerProvider.notifier).retry(),
          ),
        // 底部留白：让最后一行不贴着操作条
        const SizedBox(height: HappySpacing.s24),
      ],
    );
  }

  /// 底部操作条：按状态给出唯一的下一步。
  Widget _buildActions(AppLocalizations l10n, StoryGenerationState state) {
    final notifier = ref.read(storyGenerationControllerProvider.notifier);

    if (state.isBusy) {
      return HappyButton(
        label: l10n.storyStop,
        icon: LucideIcons.circleStop,
        variant: HappyButtonVariant.secondary,
        size: HappyButtonSize.large,
        onPressed: notifier.stop,
      );
    }

    if (state is StoryIdle) {
      // 输入为空时禁用：比点了之后弹校验错误更省事
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: _experienceController,
        builder: (context, value, _) => HappyButton(
          label: l10n.storyGenerate,
          icon: LucideIcons.sparkles,
          size: HappyButtonSize.large,
          onPressed: value.text.trim().isEmpty ? null : _onGenerate,
        ),
      );
    }

    // 已完成 / 已失败
    return Row(
      spacing: HappySemanticSpacing.itemGap,
      children: <Widget>[
        Expanded(
          child: HappyButton(
            label: l10n.storyNewStory,
            icon: LucideIcons.filePlus,
            variant: HappyButtonVariant.ghost,
            onPressed: _onEditExperience,
          ),
        ),
        Expanded(
          child: HappyButton(
            label: l10n.storyRegenerate,
            icon: LucideIcons.rotateCcw,
            onPressed: notifier.retry,
          ),
        ),
      ],
    );
  }

  TextStyle? _titleStyle(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall;

  TextStyle? _mutedLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium;
}
