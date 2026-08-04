import "dart:math" as math;

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 档案头部：头像（外圈是档案完成度进度环）+ 昵称 + 一行说明。
///
/// 完成度做成头像外圈的环而不是只留一行小字：一行字容易被跳过，一个没画满的圈会
/// 一直提示"还差一点"，驱动力强得多。
///
/// ## 入场动画
/// 进入页面时环从 0 扫到实际完成度，副标题里的百分数**同步跳数**（所以副标题是
/// [subtitleBuilder] 而不是一个字符串——它每帧要用当前数字重新拼一次）。
/// 把"还差一点"演出来比静态显示 78% 更有推动力。
///
/// 只播一次：分支常驻挂载，切 tab 回来不会重建这个 State，也就不会重播；
/// 只有完成度真的变了（补完一个字段后刷新）才从当前值补一段动画到新值。
/// 系统开了"减弱动态效果"时直接显示终值。
///
/// **补涨是正反馈时刻**：完成度变高时除了补一段进度，还会给环一次
/// [HappyMotion.springy] 的轻弹 + 一次轻触感——"你刚推进了一格"要能被感觉到。
/// 数值本身仍走单调曲线：让百分数跟着回弹会先冲过头再退回来，读起来像数错了。
///
/// 100% 时环右下角亮一个对勾：满环和 97% 的环肉眼几乎一样，需要一个明确的"到了"。
///
/// 头像有网址就走 [CachedNetworkImage]（带占位与失败兜底，不出现裂图）；
/// 没有网址就退化成"昵称首字 + 品牌渐变"的字母头像——新建账号还没上传头像时
/// 也要有一个好看的身份符号，而不是一个灰色小人。
class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({
    super.key,
    required this.nickname,
    required this.subtitleBuilder,
    required this.completeness,
    this.avatarUrl,
    this.size = HappySpacing.s80,
  });

  final String nickname;

  /// 昵称下面那行说明。入参是**当前动画到的**完成度百分数（0–100）。
  final String Function(int percent) subtitleBuilder;

  /// 档案完成度 0–1，画成头像外圈的进度环。
  final double completeness;

  final String? avatarUrl;
  final double size;

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader>
    with TickerProviderStateMixin {
  /// 进度值的动画（单调，不回弹）。
  late final AnimationController _controller = AnimationController(
    duration: HappyMotion.story,
    vsync: this,
  );

  /// 补涨时给环的一次轻弹（只动尺寸，不动数值）。
  late final AnimationController _pulse = AnimationController(
    duration: HappyMotion.normal,
    vsync: this,
  );

  /// 轻弹的缩放曲线：先弹出去一点再落回原尺寸。
  late final Animation<double> _pulseScale =
      TweenSequence<double>(<TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1,
            end: _pulsePeak,
          ).chain(CurveTween(curve: HappyMotion.springy)),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _pulsePeak,
            end: 1,
          ).chain(CurveTween(curve: HappyMotion.standard)),
          weight: 1,
        ),
      ]).animate(_pulse);

  /// 动画起点：首次是 0（从空环扫出来），后续是上一次停住的值。
  double _from = 0;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(UserProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completeness == widget.completeness) return;

    // 完成度变了（补完字段后刷新）：从当前显示值补一段到新值，不要跳变。
    _from = _valueFor(oldWidget.completeness, _controller.value);
    _controller.forward(from: 0);

    // 变高才是正反馈：轻弹 + 轻触感。变低（理论上只会是数据修正）静静补过去。
    if (widget.completeness > oldWidget.completeness) {
      _pulse.forward(from: 0);
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulse.dispose();
    super.dispose();
  }

  /// 把动画进度换算成"当前该显示的完成度"。
  double _valueFor(double target, double t) {
    final eased = HappyMotion.entrance.transform(t);
    return _from + (target - _from) * eased;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 尊重系统"减弱动态效果"：直接显示终值。
    final animate = !MediaQuery.disableAnimationsOf(context);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_controller, _pulse]),
      builder: (context, _) {
        final shown = animate
            ? _valueFor(widget.completeness, _controller.value)
            : widget.completeness;

        return Row(
          children: <Widget>[
            // Skeleton.shade：骨架态下整个头像被骨架色盖住。不加的话渐变圆会原样
            // 亮着、中间还留一个首字的骨架点，看着像加载已经完成了一半。
            Skeleton.shade(
              child: Transform.scale(
                scale: animate ? _pulseScale.value : 1,
                child: _AvatarWithRing(
                  nickname: widget.nickname,
                  avatarUrl: widget.avatarUrl,
                  size: widget.size,
                  completeness: shown,
                ),
              ),
            ),
            const SizedBox(width: HappySemanticSpacing.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.nickname,
                    style: theme.textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: HappySpacing.s4),
                  Text(
                    widget.subtitleBuilder((shown * 100).round()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 头像 + 外圈完成度环。环与头像之间留一圈呼吸，避免糊成一个粗描边。
class _AvatarWithRing extends StatelessWidget {
  const _AvatarWithRing({
    required this.nickname,
    required this.avatarUrl,
    required this.size,
    required this.completeness,
  });

  final String nickname;
  final String? avatarUrl;
  final double size;
  final double completeness;

  /// 环与头像的间隙。
  static const double _gap = HappySpacing.s6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringSize = size + (_gap + HappyBorderWidth.thick) * 2;

    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: CustomPaint(
        painter: _CompletenessRingPainter(
          progress: completeness.clamp(0, 1),
          trackColor: theme.colorScheme.surfaceContainerHighest,
          gradient: HappyGradients.brandFor(theme.brightness),
          strokeWidth: HappyBorderWidth.thick,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Center(
              child: _Avatar(
                nickname: nickname,
                avatarUrl: avatarUrl,
                size: size,
              ),
            ),
            // 满环时才出现的"到了"确认。
            if (completeness >= 1)
              const Positioned(bottom: 0, right: 0, child: _CompleteBadge()),
          ],
        ),
      ),
    );
  }
}

/// 档案 100% 的完成徽标：环右下角一个对勾。
///
/// 满环和 97% 的环肉眼分不出来，所以"完成"需要一个独立符号而不是靠弧长。
class _CompleteBadge extends StatelessWidget {
  const _CompleteBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: HappySpacing.s20,
      height: HappySpacing.s20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primary,
        // 描一圈画布色：徽标压在环与头像之间时边界才清楚。
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: HappyBorderWidth.thick,
        ),
      ),
      child: Icon(
        LucideIcons.check,
        size: HappyIconSize.xs,
        color: scheme.onPrimary,
      ),
    );
  }
}

/// 完成度环：底圈是轨道，上面盖一段品牌渐变的进度弧，从 12 点顺时针起画。
class _CompletenessRingPainter extends CustomPainter {
  const _CompletenessRingPainter({
    required this.progress,
    required this.trackColor,
    required this.gradient,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Gradient gradient;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final circle = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(circle);
    // -90° 起点 = 12 点方向；顺时针扫过 progress 对应的角度。
    canvas.drawArc(circle, -math.pi / 2, math.pi * 2 * progress, false, arc);
  }

  @override
  bool shouldRepaint(_CompletenessRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.nickname,
    required this.avatarUrl,
    required this.size,
  });

  final String nickname;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = avatarUrl;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: HappyGradients.brandFor(theme.brightness),
        boxShadow: HappyShadows.glow(theme.colorScheme.primary),
      ),
      alignment: Alignment.center,
      child: url == null || url.isEmpty
          ? Text(
              // 首字当身份符号；昵称为空时退回一个中性符号，不让它变成空白圆。
              nickname.isEmpty ? "?" : nickname.characters.first,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            )
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                // 占位/失败都用渐变底兜着：不留白、不裂图。
                placeholder: (context, _) => const SizedBox.shrink(),
                errorWidget: (context, _, _) => Icon(
                  Icons.person_outline,
                  size: size * 0.5,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
    );
  }
}

/// 补涨轻弹的峰值缩放。只放大 6%——这是"推进了一格"的点头，不是庆祝动画。
const double _pulsePeak = 1.06;
