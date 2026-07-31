import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:toastification/toastification.dart";

/// 轻提示语义类型。
enum HappyToastType { success, error, warning, info }

/// 全局轻提示（toast）统一入口。
///
/// 业务层的用户提示一律走这里，**不**直接调 `toastification` 或
/// `ScaffoldMessenger`，以保证样式 / 位置 / 时长一致。
/// 需 app 根挂载 `ToastificationWrapper`（见 `app.dart`）。
///
/// 这里用 `showCustom` 而不是内置样式：内置的 `flatColored` 是一整块高饱和色卡，
/// 在近黑画布上像贴了张便利贴；换成"深色卡片 + 语义色图标胶囊"后能融进画布，
/// 同时靠图标和左侧色块保留语义可辨识度。
abstract final class HappyToast {
  static const Duration _duration = Duration(seconds: 3);
  static const AlignmentGeometry _alignment = Alignment.topCenter;

  /// 成功提示。带轻震反馈。
  static void success(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    _show(context, message, HappyToastType.success);
  }

  /// 错误提示。失败场景默认用它，带较重的震动提醒。
  static void error(BuildContext context, String message) {
    HapticFeedback.mediumImpact();
    _show(context, message, HappyToastType.error);
  }

  /// 警告提示。
  static void warning(BuildContext context, String message) =>
      _show(context, message, HappyToastType.warning);

  /// 中性信息提示。
  static void info(BuildContext context, String message) =>
      _show(context, message, HappyToastType.info);

  static void _show(BuildContext context, String message, HappyToastType type) {
    toastification.showCustom(
      context: context,
      alignment: _alignment,
      autoCloseDuration: _duration,
      animationDuration: HappyMotion.normal,
      builder: (builderContext, item) => _HappyToastCard(
        message: message,
        type: type,
        onDismiss: () => toastification.dismiss(item),
      ),
    );
  }
}

/// toast 卡片本体。
class _HappyToastCard extends StatelessWidget {
  const _HappyToastCard({
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  final String message;
  final HappyToastType type;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = _accentColor(scheme);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HappySemanticSpacing.screenPadding,
          vertical: HappySpacing.s8,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // 点一下即关：轻提示不该拦着用户
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(HappyRadius.toast),
            child: Container(
              padding: const EdgeInsets.all(HappySpacing.s12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(HappyRadius.toast),
                border: Border.all(
                  color: scheme.outlineVariant,
                  width: HappyBorderWidth.hairline,
                ),
                boxShadow: HappyShadows.lifted(theme.brightness),
              ),
              child: Row(
                spacing: HappySpacing.s12,
                children: <Widget>[
                  // 语义色只出现在图标胶囊上，不铺满整张卡
                  Container(
                    padding: const EdgeInsets.all(HappySpacing.s6),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(HappyRadius.xs),
                    ),
                    child: Icon(_icon, size: HappyIconSize.sm, color: accent),
                  ),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(ColorScheme scheme) => switch (type) {
    HappyToastType.success =>
      scheme.brightness == Brightness.dark
          ? HappyColors.darkSuccess
          : HappyColors.success,
    HappyToastType.warning =>
      scheme.brightness == Brightness.dark
          ? HappyColors.darkWarning
          : HappyColors.warning,
    HappyToastType.error => scheme.error,
    HappyToastType.info => scheme.primary,
  };

  IconData get _icon => switch (type) {
    HappyToastType.success => LucideIcons.circleCheck,
    HappyToastType.warning => LucideIcons.triangleAlert,
    HappyToastType.error => LucideIcons.circleAlert,
    HappyToastType.info => LucideIcons.info,
  };
}
