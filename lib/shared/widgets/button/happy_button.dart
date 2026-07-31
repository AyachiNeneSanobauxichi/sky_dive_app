import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";

/// 按钮语义变体。
enum HappyButtonVariant {
  /// 主行动。品牌渐变填充 + 光晕，一屏最多一个。
  primary,

  /// 次要行动。抬升表面 + 描边，可与 [primary] 并列。
  secondary,

  /// 弱行动。无底无边，只有文字，用于"跳过""稍后再说"。
  ghost,

  /// 破坏性行动（删除、退出登录）。
  danger,
}

/// 按钮尺寸。
enum HappyButtonSize { small, medium, large }

/// 全局主按钮。
///
/// 相比直接用 `FilledButton`，这里多做三件 C 端产品必须有、Material 默认没有的事：
/// 1. **品牌渐变 + 光晕**——深色画布上纯色块会闷住，渐变和光晕才撑得起主行动；
/// 2. **按下缩放**——`HappyMotion.pressScale` 的即时反馈，是"精致"最廉价的来源；
/// 3. **触感反馈**——点击时轻震，移动端缺了它会明显"发木"。
class HappyButton extends StatefulWidget {
  const HappyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = HappyButtonVariant.primary,
    this.size = HappyButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  final String label;

  /// 传 `null` 表示禁用。
  final VoidCallback? onPressed;

  final HappyButtonVariant variant;
  final HappyButtonSize size;

  /// 可选前置图标。
  final IconData? icon;

  /// 忙碌态：置为 true 时按钮不可点，内容换成转圈。
  ///
  /// 页面级加载一律用骨架屏，**按钮内联忙碌态是规范里明确的例外**——
  /// 提交类操作必须在按钮本体上给出反馈，否则用户会重复点击。
  final bool isLoading;

  final bool isFullWidth;

  @override
  State<HappyButton> createState() => _HappyButtonState();
}

class _HappyButtonState extends State<HappyButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = _resolveVisual(theme);
    final height = _resolveHeight();
    final radius = BorderRadius.circular(HappyRadius.button);

    final button = AnimatedScale(
      scale: _pressed ? HappyMotion.pressScale : 1,
      duration: HappyMotion.instant,
      curve: HappyMotion.standard,
      child: AnimatedContainer(
        duration: HappyMotion.fast,
        curve: HappyMotion.standard,
        height: height,
        decoration: BoxDecoration(
          gradient: visual.gradient,
          color: visual.fill,
          borderRadius: radius,
          border: visual.border,
          // 按下时收掉光晕，配合缩放形成"被按进去"的整体感
          boxShadow: _pressed ? HappyShadows.none : visual.shadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _enabled ? _handleTap : null,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            borderRadius: radius,
            splashColor: visual.foreground.withValues(alpha: 0.12),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _resolvePadding()),
              child: _buildContent(theme, visual),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: widget.isFullWidth
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }

  Widget _buildContent(ThemeData theme, _ButtonVisual visual) {
    if (widget.isLoading) {
      return Center(
        child: SizedBox.square(
          dimension: HappyIconSize.md,
          child: CircularProgressIndicator(
            strokeWidth: HappyBorderWidth.thick,
            color: visual.foreground,
          ),
        ),
      );
    }

    final textStyle = (widget.size == HappyButtonSize.small
        ? theme.textTheme.labelMedium
        : theme.textTheme.labelLarge);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: HappySpacing.s8,
      children: <Widget>[
        if (widget.icon != null)
          Icon(widget.icon, size: HappyIconSize.md, color: visual.foreground),
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle?.copyWith(color: visual.foreground),
          ),
        ),
      ],
    );
  }

  double _resolveHeight() => switch (widget.size) {
    HappyButtonSize.small => HappyControlSize.buttonSmall,
    HappyButtonSize.medium => HappyControlSize.buttonMedium,
    HappyButtonSize.large => HappyControlSize.buttonLarge,
  };

  double _resolvePadding() => switch (widget.size) {
    HappyButtonSize.small => HappySpacing.s12,
    HappyButtonSize.medium => HappySpacing.s20,
    HappyButtonSize.large => HappySpacing.s24,
  };

  /// 把"变体 × 启用态"解析成一组具体的绘制参数。
  _ButtonVisual _resolveVisual(ThemeData theme) {
    final scheme = theme.colorScheme;

    if (!_enabled) {
      // 禁用态统一长相：不保留品牌色，避免用户以为还能点
      return _ButtonVisual(
        fill: widget.variant == HappyButtonVariant.ghost
            ? Colors.transparent
            : scheme.onSurface.withValues(alpha: 0.08),
        foreground: scheme.onSurface.withValues(alpha: 0.38),
        shadow: HappyShadows.none,
      );
    }

    return switch (widget.variant) {
      HappyButtonVariant.primary => _ButtonVisual(
        gradient: HappyGradients.brandFor(theme.brightness),
        foreground: scheme.onPrimary,
        shadow: HappyShadows.glow(scheme.primary),
      ),
      HappyButtonVariant.secondary => _ButtonVisual(
        fill: scheme.surfaceContainerHigh,
        foreground: scheme.onSurface,
        border: Border.all(
          color: scheme.outline,
          width: HappyBorderWidth.hairline,
        ),
        shadow: HappyShadows.none,
      ),
      HappyButtonVariant.ghost => _ButtonVisual(
        fill: Colors.transparent,
        foreground: scheme.primary,
        shadow: HappyShadows.none,
      ),
      HappyButtonVariant.danger => _ButtonVisual(
        fill: scheme.error,
        foreground: scheme.onError,
        shadow: HappyShadows.glow(scheme.error, intensity: 0.28),
      ),
    };
  }
}

/// 按钮一次绘制所需的全部视觉参数。抽出来是为了让 [_resolveVisual] 的
/// switch 保持"一个分支一行结果"，不用在 build 里散落一堆三元表达式。
class _ButtonVisual {
  const _ButtonVisual({
    required this.foreground,
    required this.shadow,
    this.gradient,
    this.fill,
    this.border,
  });

  final Color foreground;
  final List<BoxShadow> shadow;
  final Gradient? gradient;
  final Color? fill;
  final BoxBorder? border;
}
