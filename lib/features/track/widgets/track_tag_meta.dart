import "package:flutter/material.dart";
import "package:happy_os/features/track/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 标签的展示信息（文案 + 图标 + 强调色）。
///
/// 抽出来是因为筛选栏、时间线节点、卡片上的标签这三处都要用同一套映射，
/// 各写一遍 switch 迟早对不上。
class TrackTagMeta {
  const TrackTagMeta({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

/// 取某个标签的展示信息。
///
/// **图标承担主要区分**而不是颜色：高光与美好瞬间都用品牌主色（它们都是"亮"的事），
/// 只靠色相分不开，所以奖杯 / 太阳 / 小孩 / 阴雨四个图标才是真正的区分位。
/// 低谷刻意**不用错误色**——低谷不是错误，它是故事里最值钱的那一段，
/// 用中性色表达"沉下去"而不是"出问题了"。
TrackTagMeta trackTagMeta(
  AppLocalizations l10n,
  ColorScheme scheme,
  TrackTag tag,
) {
  return switch (tag) {
    TrackTag.childhood => TrackTagMeta(
      label: l10n.trackTagChildhood,
      icon: LucideIcons.baby,
      color: scheme.tertiary,
    ),
    TrackTag.highlight => TrackTagMeta(
      label: l10n.trackTagHighlight,
      icon: LucideIcons.trophy,
      color: scheme.primary,
    ),
    TrackTag.lowPoint => TrackTagMeta(
      label: l10n.trackTagLowPoint,
      icon: LucideIcons.cloudRain,
      color: scheme.onSurfaceVariant,
    ),
    TrackTag.goodMoment => TrackTagMeta(
      label: l10n.trackTagGoodMoment,
      icon: LucideIcons.sun,
      color: scheme.primary,
    ),
  };
}
