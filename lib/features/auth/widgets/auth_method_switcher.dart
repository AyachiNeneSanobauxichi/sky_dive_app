import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 登录方式切换（邮箱密码 / 手机验证码）。
///
/// ## 为什么最后落在"下划线 tab"而不是分段控件
/// 试过两版分段控件，都败在**它坐在天幕渐变上**这件事上：
/// 1. 第一版给滑块套品牌渐变 + 光晕 → 和主按钮「登录」同一档重量，抢走了 CTA 的位置；
/// 2. 第二版换成"托盘 + 白色滑块"（iOS 那种）→ 托盘色 `#F2F7FD` 和白滑块 `#FFFFFF`
///    在浅色下差了不到 2%，压在本来就是浅蓝的天幕上整块糊掉，看不出是个控件。
///
/// 分段控件的前提是**有一块纯净的浅灰底**可以挖槽；这个页面没有。
/// 所以改成不带任何填充的下划线 tab：文字 + 一根 3px 的品牌渐变短条，
/// 底色是什么都不影响它的可读性。
///
/// 指示条**占满该 tab 的整宽**（即整行的 50%），不是居中的一小截：
/// 两个 tab 之间没有分隔物，短条只能标出"选中的大概在这一侧"，
/// 满宽才把这一半明确划成一个可点区域，边界一眼可见。
class AuthMethodSwitcher extends StatelessWidget {
  const AuthMethodSwitcher({
    super.key,
    required this.method,
    required this.onChanged,
    this.enabled = true,
  });

  final AuthMethod method;
  final ValueChanged<AuthMethod> onChanged;

  /// 提交中置 false：请求在途时不允许换登录方式（换了等于把在途请求的结果作废）。
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: _labelRowHeight,
          child: Row(
            children: <Widget>[
              for (final value in AuthMethod.values)
                Expanded(
                  child: _Segment(
                    icon: value.isEmail
                        ? LucideIcons.mail
                        : LucideIcons.messageSquare,
                    label: value.isEmail
                        ? l10n.authMethodEmail
                        : l10n.authMethodPhone,
                    isSelected: value == method,
                    onTap: enabled && value != method
                        ? () {
                            HapticFeedback.selectionClick();
                            onChanged(value);
                          }
                        : null,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: _indicatorHeight,
          child: Stack(
            children: <Widget>[
              // 贯穿整宽的发丝线：让两个 tab 站在同一条基线上，
              // 没有它的话下划线会读成"某个词底下画了道杠"。
              // 用 outline 而不是 outlineVariant——后者在天幕上直接消失。
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: SkyBorderWidth.hairline,
                  color: theme.colorScheme.outline,
                ),
              ),
              AnimatedAlign(
                alignment: method.isEmail
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                duration: SkyMotion.normal,
                curve: SkyMotion.emphasized,
                // 不套 Center：让它撑满 FractionallySizedBox 的整个宽度。
                child: FractionallySizedBox(
                  widthFactor: 1 / AuthMethod.values.length,
                  child: Container(
                    height: _indicatorHeight,
                    decoration: BoxDecoration(
                      gradient: SkyGradients.brandFor(theme.brightness),
                      borderRadius: BorderRadius.circular(_indicatorHeight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;

  /// null = 已选中或整体禁用。已选中项不可点是合理的（点了什么也不会变），
  /// 且下划线已经把"选中"表达清楚，不会让人以为坏了。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 选中项用品牌色，与底部导航栏选中态一致。
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SkyRadius.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 图标颜色跟着下划线一起过渡：下划线在滑、颜色却硬切的话，
            // 会看到"字先变色、条后到位"两段脱节的动作。
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: color),
              duration: SkyMotion.normal,
              curve: SkyMotion.standard,
              builder: (context, value, _) =>
                  Icon(icon, size: SkyIconSize.sm, color: value ?? color),
            ),
            const SizedBox(width: SkySpacing.s6),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: SkyMotion.normal,
                curve: SkyMotion.standard,
                style:
                    theme.textTheme.labelLarge?.copyWith(
                      color: color,
                      // 选中项加一档字重：颜色差在小字号上不够用，
                      // 字重差才是一眼能分辨的那一下。
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ) ??
                    TextStyle(color: color),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 文字行高度。整行都是热区，已过 44 的下限。
const double _labelRowHeight = 46;

/// 下划线厚度。宽度不在这里定——它跟着 tab 走（整行的 1/N）。
const double _indicatorHeight = 3;
