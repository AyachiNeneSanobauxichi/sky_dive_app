import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 品牌标记：品牌渐变的圆角方块 + 图标 + 光晕。
///
/// 用在开屏、登录/注册页头、空态这些需要"这是谁家产品"的位置。
/// 目前用图标占位，等品牌 logo 定稿后换成 `SvgPicture.asset`，
/// 调用方无需改动。
// TODO(brand): logo 定稿后把内部的 Icon 换成 SVG 资产。
class HappyBrandMark extends StatelessWidget {
  const HappyBrandMark({
    super.key,
    this.size = 72,
    this.icon = LucideIcons.sparkles,
  });

  /// 方块边长。
  final double size;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: HappyGradients.brandFor(theme.brightness),
        // 圆角随尺寸缩放，保持"超椭圆"观感而不是固定圆角贴大方块
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: HappyShadows.glow(
          theme.colorScheme.primary,
          intensity: 0.45,
        ),
      ),
      child: Icon(icon, size: size * 0.45, color: theme.colorScheme.onPrimary),
    );
  }
}
