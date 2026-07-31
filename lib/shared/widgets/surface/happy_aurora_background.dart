import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";

/// 品牌极光背景。
///
/// 这是 HappyOS 的招牌视觉：近黑画布上两团缓慢呼吸的品牌色光斑
/// （左上紫罗兰、右下品红），把"深色 = 一片死黑"变成"深色 = 有光的夜"。
/// 用在需要氛围的页面（开屏、登录、故事阅读、空态），
/// 列表 / 表单这类信息密集页别用，会抢注意力。
///
/// 实现上只用两个 [RadialGradient]，不涉及 `BackdropFilter` 或 shader，
/// 开销约等于两次渐变填充；动效交给 `flutter_animate` 的无限往返，
/// 并遵守系统"减弱动态效果"设置。
class HappyAuroraBackground extends StatelessWidget {
  const HappyAuroraBackground({
    super.key,
    required this.child,
    this.animate = true,
    this.intensity = 1,
  });

  final Widget child;

  /// 是否让光斑缓慢漂移呼吸。系统开启"减弱动态效果"时会被强制关掉。
  final bool animate;

  /// 光强系数（0–1）。信息密集的页面调到 0.5 以下更稳妥。
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    // 尊重系统无障碍设置：开了"减弱动态效果"就静止，避免引发不适
    final shouldAnimate = animate && !MediaQuery.disableAnimationsOf(context);
    // 浅色模式下同样强度会显得脏，压到四成
    final isDark = theme.brightness == Brightness.dark;
    final effectiveIntensity = intensity * (isDark ? 0.38 : 0.16);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -size.height * 0.18,
            left: -size.width * 0.35,
            child: _AuroraBlob(
              color: HappyColors.violetBright,
              diameter: size.width * 1.15,
              intensity: effectiveIntensity,
              animate: shouldAnimate,
              driftY: 32,
            ),
          ),
          Positioned(
            bottom: -size.height * 0.12,
            right: -size.width * 0.4,
            child: _AuroraBlob(
              color: HappyColors.magentaBright,
              diameter: size.width * 1,
              intensity: effectiveIntensity * 0.85,
              animate: shouldAnimate,
              // 反向漂移，两团光才不会像同一块东西在整体平移
              driftY: -28,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// 单团光斑。
class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({
    required this.color,
    required this.diameter,
    required this.intensity,
    required this.animate,
    required this.driftY,
  });

  final Color color;
  final double diameter;
  final double intensity;
  final bool animate;
  final double driftY;

  @override
  Widget build(BuildContext context) {
    final blob = IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: HappyGradients.auroraBlob(color, intensity: intensity),
        ),
      ),
    );

    if (!animate) return blob;

    return blob
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          end: driftY,
          duration: HappyMotion.ambient,
          curve: HappyMotion.ambientCurve,
        )
        .scaleXY(
          begin: 1,
          end: 1.1,
          duration: HappyMotion.ambient,
          curve: HappyMotion.ambientCurve,
        );
  }
}
