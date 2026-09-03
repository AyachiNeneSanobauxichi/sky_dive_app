import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:toastification/toastification.dart";

/// 轻提示语义类型。
enum SkyToastType { success, error, warning, info }

/// 全局轻提示（toast）统一入口。
///
/// 业务层的用户提示一律走这里，**不**直接调 `toastification` 或
/// `ScaffoldMessenger`，以保证样式 / 位置 / 时长一致。
/// 需 app 根挂载 `ToastificationWrapper`（见 `app.dart`）。
///
/// 这里用 `showCustom` 而不是内置样式：内置的 `flatColored` 是一整块高饱和色卡，
/// 在近黑画布上像贴了张便利贴；换成"深色卡片 + 语义色图标胶囊"后能融进画布，
/// 同时靠图标和左侧色块保留语义可辨识度。
abstract final class SkyToast {
  static const Duration _duration = Duration(seconds: 3);

  /// 带行动（撤销）的提示的停留时长。
  static const Duration _actionDuration = Duration(seconds: 6);
  static const AlignmentGeometry _alignment = Alignment.topCenter;

  /// 成功提示。带轻震反馈。
  ///
  /// [actionLabel] / [onAction] 用于**可撤销**的操作（如把人移出名单）：
  /// 可逆的动作用"先做 + 给撤销"比"先弹窗问一遍"少一次打断，
  /// 连续操作时差别尤其明显。不可逆的动作（删除航线）仍然要二次确认。
  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    HapticFeedback.lightImpact();
    _show(
      context,
      message,
      SkyToastType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// 错误提示。失败场景默认用它，带较重的震动提醒。
  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    HapticFeedback.mediumImpact();
    _show(
      context,
      message,
      SkyToastType.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// 警告提示。
  static void warning(BuildContext context, String message) =>
      _show(context, message, SkyToastType.warning);

  /// 中性信息提示。
  static void info(BuildContext context, String message) =>
      _show(context, message, SkyToastType.info);

  static void _show(
    BuildContext context,
    String message,
    SkyToastType type, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    toastification.showCustom(
      context: context,
      alignment: _alignment,
      // 带行动的提示多给几秒：3 秒够读完一句话，不够"读完 + 决定 + 点撤销"。
      autoCloseDuration: onAction == null ? _duration : _actionDuration,
      animationDuration: SkyMotion.normal,
      builder: (builderContext, item) => _SkyToastCard(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: () => toastification.dismiss(item),
      ),
    );
  }
}

/// toast 卡片本体。
class _SkyToastCard extends StatelessWidget {
  const _SkyToastCard({
    required this.message,
    required this.type,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final SkyToastType type;
  final VoidCallback onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = _accentColor(scheme);
    final action = actionLabel;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SkySemanticSpacing.screenPadding,
          vertical: SkySpacing.s8,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // 点一下即关：轻提示不该拦着用户。
            // 有行动按钮时整卡仍可点关闭——按钮自己吃掉自己的点击。
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(SkyRadius.toast),
            child: Container(
              padding: const EdgeInsets.all(SkySpacing.s12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(SkyRadius.toast),
                border: Border.all(
                  color: scheme.outlineVariant,
                  width: SkyBorderWidth.hairline,
                ),
                boxShadow: SkyShadows.lifted(theme.brightness),
              ),
              child: Row(
                spacing: SkySpacing.s12,
                children: <Widget>[
                  // 语义色只出现在图标胶囊上，不铺满整张卡
                  Container(
                    padding: const EdgeInsets.all(SkySpacing.s6),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(SkyRadius.xs),
                    ),
                    child: Icon(_icon, size: SkyIconSize.sm, color: accent),
                  ),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (action != null)
                    _SkyToastAction(
                      label: action,
                      color: accent,
                      onPressed: () {
                        // 先收起提示再执行：撤销往往会立刻再弹一条新提示，
                        // 两条叠在一起用户读不过来。
                        onDismiss();
                        onAction?.call();
                      },
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
    SkyToastType.success =>
      scheme.brightness == Brightness.dark
          ? SkyColors.darkSuccess
          : SkyColors.success,
    SkyToastType.warning =>
      scheme.brightness == Brightness.dark
          ? SkyColors.darkWarning
          : SkyColors.warning,
    SkyToastType.error => scheme.error,
    SkyToastType.info => scheme.primary,
  };

  IconData get _icon => switch (type) {
    SkyToastType.success => LucideIcons.circleCheck,
    SkyToastType.warning => LucideIcons.triangleAlert,
    SkyToastType.error => LucideIcons.circleAlert,
    SkyToastType.info => LucideIcons.info,
  };
}

/// toast 上的行动按钮（撤销 / 重试）。
class _SkyToastAction extends StatelessWidget {
  const _SkyToastAction({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onPressed();
        },
        borderRadius: BorderRadius.circular(SkyRadius.xs),
        child: Container(
          // 热区 ≥44：toast 是限时的，点不中就等于没有这个功能。
          constraints: const BoxConstraints(
            minHeight: SkyControlSize.minTapTarget,
            minWidth: SkyControlSize.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s8),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
