import "dart:async";

import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 登录页的示例故事卡：给"这个 app 到底产出什么"一个看得见的答案。
///
/// 一句价值文案只说明了意图，用户仍然不知道改写出来长什么样；给一段真实质感的
/// 片段，转化说服力比形容词强。用 [HappyGlassCard] 浮在极光上，同时也是
/// 产品视觉基调的第一次示范（全页仅此一处玻璃层，符合 1–3 个封顶的约束）。
///
/// **可滑动 + 自动轮播**：单条看久了像一张死图，还会让人以为只能改这一类经历；
/// 多条轮播传达"什么经历都能改"。两条交互约束：
/// 1. **用户一旦手动滑动，自动轮播就永久停掉**——主动操作优先于自动播放，
///    否则手划到第 2 条、6 秒后被系统抢走翻到第 3 条，是很恼人的体验；
/// 2. 自动轮播属环境动效，系统开「减弱动态效果」时不起定时器（仍可手滑）。
///
// TODO(product): 示例片段目前是 mock 文案，待产品 / 内容定稿后替换；
//   后续若改为服务端下发（按语言随机取几条），这里要接真实数据源。
class LoginSampleStory extends StatefulWidget {
  const LoginSampleStory({super.key});

  @override
  State<LoginSampleStory> createState() => _LoginSampleStoryState();
}

class _LoginSampleStoryState extends State<LoginSampleStory> {
  /// 片段展示行数上限：这是"尝一口"，不是让人在登录页读完一篇。
  static const int _maxLines = 3;

  final _pageController = PageController();

  Timer? _rotation;
  int _index = 0;

  /// 用户已经手动滑过：不再自动轮播。
  bool _userTookOver = false;

  /// 依赖 MediaQuery（是否减弱动效），所以在这里而不是 initState 里配置定时器。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldRotate =
        !_userTookOver && !MediaQuery.disableAnimationsOf(context);
    if (shouldRotate) {
      _rotation ??= Timer.periodic(HappyMotion.ambient, (_) => _advance());
    } else {
      _stopRotation();
    }
  }

  @override
  void dispose() {
    _rotation?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _stopRotation() {
    _rotation?.cancel();
    _rotation = null;
  }

  void _advance() {
    if (!mounted || !_pageController.hasClients) return;
    final total = _sampleCount(context);
    _pageController.animateToPage(
      (_index + 1) % total,
      duration: HappyMotion.slow,
      curve: HappyMotion.standard,
    );
  }

  /// 用户开始拖动就交出控制权。
  void _onUserScroll(ScrollStartNotification notification) {
    if (notification.dragDetails == null) return; // 程序化滚动不算接管
    if (_userTookOver) return;
    _userTookOver = true;
    _stopRotation();
  }

  int _sampleCount(BuildContext context) => _samplesOf(context).length;

  List<String> _samplesOf(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return <String>[
      l10n.loginSampleStory1,
      l10n.loginSampleStory2,
      l10n.loginSampleStory3,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final samples = _samplesOf(context);
    final bodyStyle = theme.textTheme.bodyMedium;

    // 视口高度按"字号 × 行高 × 行数"推出来，而不是写死一个像素值——
    // 这样系统放大字体时卡片跟着长高，文字不会被裁掉。
    final fontSize = MediaQuery.textScalerOf(
      context,
    ).scale(bodyStyle?.fontSize ?? HappyIconSize.xs);
    final viewportHeight = fontSize * (bodyStyle?.height ?? 1.5) * _maxLines;

    return HappyGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HappySemanticSpacing.labelGap,
        children: <Widget>[
          Row(
            spacing: HappySpacing.s6,
            children: <Widget>[
              Icon(
                LucideIcons.sparkles,
                size: HappyIconSize.xs,
                color: theme.colorScheme.primary,
              ),
              Text(
                l10n.loginSampleLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: viewportHeight,
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (notification) {
                _onUserScroll(notification);
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: samples.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) => Text(
                  samples[index],
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: bodyStyle,
                ),
              ),
            ),
          ),
          _PageDots(count: samples.length, activeIndex: _index),
        ],
      ),
    );
  }
}

/// 页码指示点：告诉用户"还有几条"以及可以滑。
class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: HappySpacing.s6,
      children: <Widget>[
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: HappyMotion.fast,
            curve: HappyMotion.standard,
            height: HappyBorderWidth.thick + HappySpacing.s2,
            // 当前页拉长成一小段，而不是只靠颜色区分——弱视觉下也能分辨。
            width: i == activeIndex ? HappySpacing.s12 : HappySpacing.s4,
            decoration: BoxDecoration(
              color: i == activeIndex ? scheme.primary : scheme.outlineVariant,
              borderRadius: BorderRadius.circular(HappyRadius.pill),
            ),
          ),
      ],
    );
  }
}
