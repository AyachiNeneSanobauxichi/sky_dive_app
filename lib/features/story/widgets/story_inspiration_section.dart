import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 「灵感一下」区块：几条提示词 + 换一换。
///
/// 这一区是给"想写但不知道从哪开口"的人用的——空着的输入框是最高的门槛，
/// 三条具体的句子比任何引导文案都有效。
///
/// 换一换时旧的一组**向左滑出**、新的一组**从右滑入**（见 [_PromptSwap]）：
/// 换出来的是三行长得差不多的句子，横向位移和"换"这个动作同向，比原地淡入更能
/// 说清"这是新的一批"。
class StoryInspirationSection extends StatelessWidget {
  const StoryInspirationSection({
    super.key,
    required this.title,
    required this.shuffleLabel,
    required this.prompts,
    required this.onShuffle,
    required this.onSelect,
  });

  final String title;
  final String shuffleLabel;
  final List<InspirationPrompt> prompts;
  final VoidCallback onShuffle;
  final ValueChanged<InspirationPrompt> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              LucideIcons.lightbulb,
              size: HappyIconSize.md,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: HappySpacing.s6),
            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            // 换一换：图标 + 文字，热区由 TextButton 主题撑到 44。
            Skeleton.keep(
              child: _ShuffleButton(label: shuffleLabel, onShuffle: onShuffle),
            ),
          ],
        ),
        const SizedBox(height: HappySpacing.s8),
        _PromptSwap(prompts: prompts, onSelect: onSelect),
      ],
    );
  }
}

/// 换一换按钮：点一下图标转一整圈，转完之前不能再点。
///
/// 这一圈不是装饰——换出来的是**同样三行长得差不多的句子**，没有转动的话用户分不清
/// "换过了"还是"点没生效"。图标转完，新的一组也刚滑入完，两件事对上。
///
/// **转动期间禁用**：连点会打断上一圈从头再转，读起来像卡住了。
///
/// 系统开了「减弱动态效果」就不转（换还是照换、也不禁用），触感照给。
class _ShuffleButton extends StatefulWidget {
  const _ShuffleButton({required this.label, required this.onShuffle});

  final String label;
  final VoidCallback onShuffle;

  @override
  State<_ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<_ShuffleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: HappyMotion.normal,
    vsync: this,
  );

  /// 转动曲线用 `standard`（快出慢收）：末端慢下来才像"停在了新的一组上"。
  late final Animation<double> _turns = _controller.drive(
    CurveTween(curve: HappyMotion.standard),
  );

  /// 是否转动中。用状态监听而不是每帧重建：一次点击只需要两次 rebuild。
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    final spinning = status == AnimationStatus.forward;
    if (spinning == _isSpinning || !mounted) return;
    setState(() => _isSpinning = spinning);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    // 换一换是"切换"语义，用 selectionClick 而不是 impact。
    HapticFeedback.selectionClick();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
    widget.onShuffle();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _isSpinning ? null : _onPressed,
      icon: RotationTransition(
        turns: _turns,
        child: const Icon(LucideIcons.refreshCw, size: HappyIconSize.sm),
      ),
      label: Text(widget.label),
    );
  }
}

/// 提示词列表的换组动画：旧的一组左滑淡出、新的一组右滑淡入。
///
/// 为什么自己写而不用 `AnimatedSwitcher`：`AnimatedSwitcher` 对进出两个 child 用
/// **同一个** transitionBuilder（出场只是把动画倒放），做不出"一个往左、一个往右"
/// 这种方向相反的进出。这里自己持一份"上一组"，两组各走各的方向。
///
/// 卡片本身无状态，所以同时挂两组不会丢任何东西（和外壳的分支容器不同——
/// 那里必须保住 State，所以坚决不能换 child）。
class _PromptSwap extends StatefulWidget {
  const _PromptSwap({required this.prompts, required this.onSelect});

  final List<InspirationPrompt> prompts;
  final ValueChanged<InspirationPrompt> onSelect;

  @override
  State<_PromptSwap> createState() => _PromptSwapState();
}

class _PromptSwapState extends State<_PromptSwap>
    with SingleTickerProviderStateMixin {
  /// ⚠️ 必须在 [initState] 里建，不能写成 `late final … = AnimationController(…)`。
  /// 这条动画只有"换过一组"才会跑：从没换过就被移除时（骨架换成真数据、或打字
  /// 折叠灵感区），`dispose()` 里的 `_controller.dispose()` 会成为**第一次访问**，
  /// 于是在 element 已经 unmount 之后才去建 Ticker——`vsync` 要查 `TickerMode`
  /// 祖先，直接抛 "Looking up a deactivated widget's ancestor is unsafe"。
  late final AnimationController _controller;

  late final Animation<double> _progress = _controller.drive(
    CurveTween(curve: HappyMotion.standard),
  );

  /// 上一组提示。换组动画期间和新的一组同时在树上。
  List<InspirationPrompt>? _outgoing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: HappyMotion.normal,
      vsync: this,
      // 首帧就位：进页面时不该演一次"换组"。
      value: 1,
    );
  }

  @override
  void didUpdateWidget(_PromptSwap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_sameIds(oldWidget.prompts, widget.prompts)) return;
    _outgoing = oldWidget.prompts;
    _controller.forward(from: 0);
  }

  /// 两组是不是同一批（按 id 逐项比）。骨架→数据、以及每次换一换都会变。
  bool _sameIds(List<InspirationPrompt> a, List<InspirationPrompt> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = !MediaQuery.disableAnimationsOf(context);
    final outgoing = _outgoing;

    final incoming = _PromptColumn(
      prompts: widget.prompts,
      onSelect: widget.onSelect,
    );
    if (!animate || outgoing == null || _controller.isCompleted) {
      return incoming;
    }

    return ClipRect(
      // 裁掉滑出屏外的部分，卡片不会画到相邻区块上去。
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          final t = _progress.value;
          return Stack(
            children: <Widget>[
              // 旧的一组：往左滑出并淡掉。
              Opacity(
                opacity: 1 - t,
                child: FractionalTranslation(
                  translation: Offset(-t, 0),
                  child: _PromptColumn(
                    prompts: outgoing,
                    onSelect: widget.onSelect,
                    // 正在离场，别再接手势。
                    interactive: false,
                  ),
                ),
              ),
              // 新的一组：从右滑入。
              Opacity(
                opacity: t,
                child: FractionalTranslation(
                  translation: Offset(1 - t, 0),
                  child: incoming,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 一组提示词（竖排三张卡）。
class _PromptColumn extends StatelessWidget {
  const _PromptColumn({
    required this.prompts,
    required this.onSelect,
    this.interactive = true,
  });

  final List<InspirationPrompt> prompts;
  final ValueChanged<InspirationPrompt> onSelect;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !interactive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final prompt in prompts)
            Padding(
              padding: const EdgeInsets.only(
                bottom: HappySemanticSpacing.itemGap,
              ),
              child: _PromptCard(
                key: ValueKey<String>(prompt.id),
                text: prompt.text,
                onTap: () => onSelect(prompt),
              ),
            ),
        ],
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HappySemanticSpacing.cardPadding,
            vertical: HappySpacing.s12,
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
              const SizedBox(width: HappySpacing.s8),
              // 箭头明示"点了会走"，而不是一张只能看的卡。
              Icon(
                LucideIcons.arrowRight,
                size: HappyIconSize.sm,
                color: scheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
