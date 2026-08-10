import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_generate/controllers/index.dart";
import "package:happy_os/features/story_history/controllers/index.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:happy_os/features/story_history/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 单篇爽文详情（`agent/service/story-history/story-history.md` v2）。
///
/// ## 这一页是用来「读」的
/// 所以：关掉星野视差（背景跟着滚会一直牵着眼睛走）、正文行高放宽、除了收藏星标
/// 之外不在正文区放任何按钮。元信息集中在顶部一次交代完，读起来不被打断。
///
/// ## 进页通常不发请求
/// 列表接口已经把全文带回来了，控制器优先用缓存那一份（见
/// [StoryScriptDetailController]）。只有深链接直达、或早期数据缺全文时才会转一下圈。
///
/// ## 「继续编辑」为什么要先等一下
/// 点下去先把那次创作的对话记录拉回来，确认真有东西可接，再跳生成页。
/// 直接跳过去的话，用户会先看到一个空白的生成页再等它加载——从"点了"到"看到东西"
/// 中间那段空白，出现在跳转之前比出现在跳转之后好受得多。
class StoryDetailScreen extends ConsumerStatefulWidget {
  const StoryDetailScreen({super.key, required this.scriptId});

  final String scriptId;

  @override
  ConsumerState<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends ConsumerState<StoryDetailScreen> {
  /// 正在为「继续编辑」拉对话记录。同时也是防重复点击的闸。
  bool _isOpening = false;

  Future<void> _toggleFavorite(AppLocalizations l10n) async {
    try {
      await ref
          .read(storyScriptDetailControllerProvider(widget.scriptId).notifier)
          .toggleFavorite();
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
    }
  }

  /// 继续编辑：先拉会话记录，成功后带着 conversationId 跳生成页。
  Future<void> _continueEditing(
    String conversationId,
    AppLocalizations l10n,
  ) async {
    if (_isOpening) return;
    setState(() => _isOpening = true);
    HapticFeedback.selectionClick();
    try {
      // await 的是生成页 watch 的**同一个** provider：那边拿到的是已经在手的数据，
      // 跳过去不会再转第二次圈。
      await ref.read(conversationReplayProvider(conversationId).future);
      if (!mounted) return;
      await context.pushNamed(
        RouteName.storyGenerate,
        queryParameters: <String, String>{
          RouteQuery.conversationId: conversationId,
        },
      );
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
  }

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.storyDetailLoadFailed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(
      storyScriptDetailControllerProvider(widget.scriptId),
    );
    final script = detail.value;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        // 标题拿到了就用故事名——它比"爽文详情"更值得占这一行。
        title: Text(
          switch (script?.title) {
            final String title when title.isNotEmpty => title,
            _ => l10n.storyDetailTitle,
          },
        ),
        actions: <Widget>[
          if (script != null)
            IconButton(
              tooltip: script.isFavorited
                  ? l10n.storyHistoryUnfavorite
                  : l10n.storyHistoryFavorite,
              icon: Icon(
                LucideIcons.star,
                color: script.isFavorited
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                _toggleFavorite(l10n);
              },
            ),
        ],
      ),
      body: HappyStarfieldBackground(
        parallax: false,
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: switch (detail) {
                  AsyncData(:final value) => _Body(
                    script: value,
                    l10n: l10n,
                    dateFormat: DateFormat.yMMMd(locale).add_Hm(),
                  ),
                  AsyncError(:final error) => _ErrorBody(
                    message: _messageOf(error, l10n),
                    retryLabel: l10n.commonRetry,
                    onRetry: () => ref.invalidate(
                      storyScriptDetailControllerProvider(widget.scriptId),
                    ),
                  ),
                  _ => Skeletonizer(
                    child: _Body(
                      script: _skeletonScript,
                      l10n: l10n,
                      dateFormat: DateFormat.yMMMd(locale).add_Hm(),
                    ),
                  ),
                },
              ),
              if (script != null)
                _ContinueBar(
                  conversationId: script.conversationId,
                  isBusy: _isOpening,
                  label: l10n.storyDetailContinue,
                  unavailableLabel: l10n.storyDetailContinueUnavailable,
                  onContinue: (id) => _continueEditing(id, l10n),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 骨架用的假数据：长度贴近真实内容，骨架条才不会短一截。
  static final StoryScript _skeletonScript = StoryScript(
    id: "skeleton",
    title: "标题占位文字",
    summary: "",
    createdAt: DateTime(2026, 8, 4),
    theme: "这里是心愿原文的占位，长度和真实内容差不多。",
    content: "正文占位。" * 40,
    length: StoryLength.medium,
  );
}

/// 正文区：元信息 → 心愿 → 全文。
class _Body extends StatelessWidget {
  const _Body({
    required this.script,
    required this.l10n,
    required this.dateFormat,
  });

  final StoryScript script;
  final AppLocalizations l10n;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final content = script.content?.trim() ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HappySemanticSpacing.itemGap,
        children: <Widget>[
          Text(
            script.title.isEmpty ? l10n.storyHistoryUntitled : script.title,
            style: theme.textTheme.headlineSmall,
          ),
          _MetaLine(
            lengthLabel: lengthLabelOf(l10n, script.length),
            style: script.style,
            timeLabel: dateFormat.format(script.createdAt),
          ),

          if (script.theme case final String wish when wish.isNotEmpty)
            _WishBlock(label: l10n.storyDetailWishLabel, text: wish),

          const SizedBox(height: HappySpacing.s8),

          if (content.isEmpty)
            Text(
              l10n.storyDetailEmptyContent,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            HappyMarkdownText(data: content),

          // 给底部留白：正文最后一行不该贴着「继续编辑」那条按钮。
          const SizedBox(height: HappySemanticSpacing.sectionGap),
        ],
      ),
    );
  }
}

/// 元信息一行：篇幅 · 文风 · 创建时间。缺的不占位。
class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.lengthLabel,
    required this.style,
    required this.timeLabel,
  });

  final String? lengthLabel;
  final String? style;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Wrap(
      spacing: HappySpacing.s12,
      runSpacing: HappySpacing.s6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        if (lengthLabel case final String label when label.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: HappySpacing.s8,
              vertical: HappySpacing.s2,
            ),
            decoration: BoxDecoration(
              color: scheme.tertiary.withValues(alpha: _badgeFillAlpha),
              borderRadius: BorderRadius.circular(HappyRadius.chip),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.tertiary,
              ),
            ),
          ),
        if (style case final String value when value.isNotEmpty)
          _IconLabel(
            icon: LucideIcons.palette,
            label: value,
            style: labelStyle,
          ),
        _IconLabel(
          icon: LucideIcons.clock3,
          label: timeLabel,
          style: labelStyle,
        ),
      ],
    );
  }
}

/// 图标 + 一行小字。
class _IconLabel extends StatelessWidget {
  const _IconLabel({required this.icon, required this.label, this.style});

  final IconData icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: HappySpacing.s4,
    children: <Widget>[
      Icon(
        icon,
        size: HappyIconSize.xs,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      Text(label, style: style),
    ],
  );
}

/// 心愿原文单独成块：它是这一篇的由来，和 AI 写的正文不是一回事，
/// 所以给它一个独立的容器而不是混在正文里。
class _WishBlock extends StatelessWidget {
  const _WishBlock({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: _wishFillAlpha),
        borderRadius: BorderRadius.circular(HappyRadius.card),
        border: Border(
          left: BorderSide(color: scheme.primary, width: HappyBorderWidth.thick),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HappySpacing.s6,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.primary),
          ),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: _wishLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部「继续编辑」。
///
/// 没有 `conversationId`（早期数据）时禁用，并把原因写在按钮下面——
/// 一个点了没反应的按钮比一个禁用的按钮更让人恼火。
class _ContinueBar extends StatelessWidget {
  const _ContinueBar({
    required this.conversationId,
    required this.isBusy,
    required this.label,
    required this.unavailableLabel,
    required this.onContinue,
  });

  final String? conversationId;
  final bool isBusy;
  final String label;
  final String unavailableLabel;
  final ValueChanged<String> onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = conversationId?.trim() ?? "";
    final available = id.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HappySpacing.s8,
        children: <Widget>[
          HappyButton(
            label: label,
            icon: LucideIcons.pencilLine,
            isLoading: isBusy,
            onPressed: available && !isBusy ? () => onContinue(id) : null,
          ),
          if (!available)
            Text(
              unavailableLabel,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// 加载失败：整页重试卡。
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
    children: <Widget>[
      const SizedBox(height: HappySpacing.s40),
      HappyRetryCard(
        message: message,
        retryLabel: retryLabel,
        onRetry: onRetry,
      ),
    ],
  );
}

/// 这一页的星野强度：读长文要的是安静。
const double _backgroundIntensity = 0.3;

/// 篇幅徽标的底色透明度。
const double _badgeFillAlpha = 0.16;

/// 心愿块的底色透明度与行高。
const double _wishFillAlpha = 0.4;
const double _wishLineHeight = 1.6;
