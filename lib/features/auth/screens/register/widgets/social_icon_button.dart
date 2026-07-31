import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";

/// 第三方登录的圆形图标按钮。
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  /// 直径。取 [HappyControlSize.buttonMedium] 保证热区达标且与主按钮同高。
  static const double _diameter = HappyControlSize.buttonMedium;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHigh,
      shape: CircleBorder(
        side: BorderSide(
          color: scheme.outlineVariant,
          width: HappyBorderWidth.hairline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: SizedBox.square(
          dimension: _diameter,
          child: Icon(icon, size: HappyIconSize.md, color: scheme.onSurface),
        ),
      ),
    );
  }
}
