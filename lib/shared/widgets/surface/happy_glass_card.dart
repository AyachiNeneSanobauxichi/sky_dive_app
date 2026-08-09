import "dart:ui";

import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 毛玻璃卡片。
///
/// 深色电影感基调里，玻璃层是表达"这块内容浮在氛围光之上"的主要手段——
/// 背后的极光透过模糊映上来，卡片才不像是硬贴在画布上的一块灰。
///
/// ⚠️ `BackdropFilter` 每帧都要重采样背景，是实打实的开销：
/// **只用在浮于 [HappyStarfieldBackground] 之上的少量元素**（一屏 1–3 个），
/// 普通内容卡请用 `Card`（已在主题里配好描边与圆角）。
class HappyGlassCard extends StatelessWidget {
  const HappyGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(HappySemanticSpacing.cardPadding),
    this.borderRadius = HappyRadius.card,
    this.blur = 18,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  /// 背景模糊半径。越大越"雾"，也越贵。
  final double blur;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        // 外层承载渐变描边：靠 1px 内边距 + 内层实心底"露出"一圈渐变，
        // 比自绘 BorderPainter 简单，也能正确参与圆角裁剪。
        child: Container(
          decoration: BoxDecoration(
            gradient: HappyGradients.glassSheen,
            borderRadius: radius,
          ),
          padding: const EdgeInsets.all(HappyBorderWidth.hairline),
          child: Material(
            color: isDark ? HappyColors.darkGlassFill : HappyColors.glassFill,
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
