import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";

/// 品牌 logo 标记的资源路径：透明底的"伞降者"，与桌面图标同一张画。
const String _markAsset = "assets/images/logo_mark.png";

/// 品牌标记：品牌渐变的圆角方块 + 光晕 + 中心图形。
///
/// 用在开屏、登录/注册页头、空态这些需要"这是谁家产品"的位置。
///
/// ## 两种形态，靠 [icon] 分叉
/// - **不传 [icon]（默认）**——放真正的品牌标记，和用户桌面上那个图标是同一张脸。
///   登录页头顶着它，等于把"你刚点的那个图标"原样接住，这是最便宜的品牌确认。
/// - **传 [icon]**——放一枚 Lucide 图标。空态用它区分模块（航班 / 预约 / 账号），
///   这时方块只是容器，不承担品牌识别。
class SkyBrandMark extends StatelessWidget {
  const SkyBrandMark({super.key, this.size = 72, this.icon});

  /// 方块边长。
  final double size;

  /// 中心图标；为空时改放品牌 logo 标记。
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glyph = icon;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: SkyGradients.brandFor(theme.brightness),
        // 圆角随尺寸缩放，保持"超椭圆"观感而不是固定圆角贴大方块
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: SkyShadows.glow(theme.colorScheme.primary, intensity: 0.45),
      ),
      child: glyph != null
          ? Icon(glyph, size: size * 0.45, color: theme.colorScheme.onPrimary)
          : Padding(
              // 与 app icon 同一档留白（12%），两处并排出现时不会一大一小。
              padding: EdgeInsets.all(size * 0.12),
              child: Image.asset(
                _markAsset,
                fit: BoxFit.contain,
                // 位图要缩到 72dp 上下，默认的 low 会把伞绳锯成毛边。
                filterQuality: FilterQuality.medium,
                // 纯装饰：它旁边永远跟着标题或文案，读屏再念一遍是噪音。
                excludeFromSemantics: true,
              ),
            ),
    );
  }
}
