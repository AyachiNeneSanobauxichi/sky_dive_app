import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 「记一笔」按钮：浮在时间线右下角的品牌渐变胶囊。
///
/// 用胶囊 + 文字而不是纯图标 FAB：这一页的主行动是"再记一条"，而一个光秃秃的
/// 加号在满屏卡片里辨识度太低。放右下角是因为拇指自然落点在那儿。
///
/// 不用 Material 的 `FloatingActionButton`：它给不了品牌渐变与光晕，
/// 而这颗要和语音圆钮、导航中键属于同一套视觉语言。
class TrackAddButton extends StatelessWidget {
  const TrackAddButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () {
          // 主行动点击给轻触感（和 HappyButton 的口径一致）。
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(HappyRadius.pill),
        child: Container(
          height: HappyControlSize.buttonMedium,
          padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s20),
          decoration: BoxDecoration(
            gradient: HappyGradients.brandFor(theme.brightness),
            borderRadius: BorderRadius.circular(HappyRadius.pill),
            boxShadow: HappyShadows.glow(scheme.primary),
          ),
          child: Row(
            // min：不写的话 Row 会吃满 FAB 槽位给的最大宽度，胶囊会铺满整屏（踩过）。
            mainAxisSize: MainAxisSize.min,
            spacing: HappySpacing.s8,
            children: <Widget>[
              Icon(
                LucideIcons.plus,
                size: HappyIconSize.md,
                color: scheme.onPrimary,
              ),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
