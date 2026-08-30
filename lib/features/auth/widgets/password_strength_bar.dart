import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 密码强度条：四格 + 一句评价。
///
/// ## 它不是校验
/// 安全底线由 `AuthRules.isValidPassword` 兜（提交时报错）。强度条只回答
/// "还能更好吗"——给的是**方向**而不是判决，所以哪怕密码已经合法，
/// 也照样显示"一般"，而不是变成一个绿勾就完事。
///
/// ## 为什么留着空态
/// 没输入时四格全灰、不显示评价文字。让它在"还没开始"和"很弱"之间有区别，
/// 否则用户点进密码框就先看到一条红杠，像是被指责。
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.strength});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = _colorOf(theme.colorScheme);
    final label = _labelOf(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (var i = 0; i < _barCount; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: SkySpacing.s4),
              Expanded(
                child: AnimatedContainer(
                  duration: SkyMotion.normal,
                  curve: SkyMotion.standard,
                  height: _barHeight,
                  decoration: BoxDecoration(
                    color: i < strength.filledBars
                        ? color
                        : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(_barHeight),
                  ),
                ),
              ),
            ],
          ],
        ),
        // 高度用 AnimatedSize 过渡：评价文字出现/消失时下面的字段不该"跳"一下。
        AnimatedSize(
          duration: SkyMotion.fast,
          curve: SkyMotion.standard,
          alignment: Alignment.topLeft,
          child: label == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: SkySpacing.s6),
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(color: color),
                  ),
                ),
        ),
      ],
    );
  }

  /// 强度 → 颜色。刻意全部取自 `colorScheme`，走的正好是品牌色谱里
  /// 「危险朱红 → 伞衣橙 → 高空蓝」这条渐强的路，不需要额外定义一套语义色。
  Color _colorOf(ColorScheme scheme) => switch (strength) {
    PasswordStrength.empty => scheme.outlineVariant,
    PasswordStrength.weak => scheme.error,
    PasswordStrength.fair => scheme.tertiary,
    PasswordStrength.good => scheme.primary,
    PasswordStrength.strong => scheme.primary,
  };

  String? _labelOf(AppLocalizations l10n) => switch (strength) {
    PasswordStrength.empty => null,
    PasswordStrength.weak => l10n.authPasswordStrengthWeak,
    PasswordStrength.fair => l10n.authPasswordStrengthFair,
    PasswordStrength.good => l10n.authPasswordStrengthGood,
    PasswordStrength.strong => l10n.authPasswordStrengthStrong,
  };
}

const int _barCount = 4;
const double _barHeight = 4;
