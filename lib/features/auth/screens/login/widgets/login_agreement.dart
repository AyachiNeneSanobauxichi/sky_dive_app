import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 用户协议勾选（接入 `Form` 校验）。
///
/// 做成 `FormField` 而不是普通勾选框 + 弹提示：未勾选时错误文案就地显示在勾选框下方、
/// 方框转红，用户一眼看到卡在哪。**登录按钮不因未勾选而禁用**——按钮无声变灰
/// 会让人以为应用坏了；让他点、然后指出这里没勾，才是能自解释的路径。
///
/// 但"下方多一行小字"在视线停在按钮上时很容易被漏掉，所以 [shakeToken] 变化时
/// 额外抖一下 + 给一次错误触感，把注意力主动拉回来。
///
/// **协议链接不放在勾选行里**：勾选行整行可点，行内嵌链接会让行中心正好压在
/// 《用户协议》上——用户想勾选，结果打开了协议页。拆成两行后，上行只负责勾选，
/// 下行两个链接是独立的文字按钮（热区 44），两种意图不再抢同一块像素。
class LoginAgreement extends StatefulWidget {
  const LoginAgreement({
    super.key,
    required this.onOpenDocument,
    required this.onChanged,
    this.shakeToken = 0,
  });

  /// 点击协议 / 隐私政策链接。协议页尚未上线，由调用方给出反馈。
  final VoidCallback onOpenDocument;

  /// 勾选态回传给页面（用于判断提交被卡住的原因是不是协议）。
  final ValueChanged<bool> onChanged;

  /// 每次自增都播一次抖动。用 token 而不是回调句柄：父级只管"该提醒了"，
  /// 动画怎么播是本组件的事。
  final int shakeToken;

  @override
  State<LoginAgreement> createState() => _LoginAgreementState();
}

class _LoginAgreementState extends State<LoginAgreement>
    with SingleTickerProviderStateMixin {
  /// 抖动幅度（左右峰值位移）。
  static const double _shakeAmplitude = HappySpacing.s8;

  /// 一次抖动里的往复次数。3 次足够"被看见"，再多就像坏掉了。
  static const double _shakeCycles = 3;

  /// 链接行的左缩进：对齐勾选框右侧的文案起始位置（方框 + 间距 - 按钮自身内边距）。
  static const double _linkRowIndent =
      HappySpacing.s20 + HappySpacing.s2 - HappySpacing.s12;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: HappyMotion.normal,
  );

  @override
  void didUpdateWidget(LoginAgreement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shakeToken != oldWidget.shakeToken) _remind();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _remind() {
    // 触感即使在「减弱动态效果」下也保留：它不是动画，是另一条通道的反馈。
    HapticFeedback.mediumImpact();
    if (MediaQuery.disableAnimationsOf(context)) return;
    _shakeController.forward(from: 0);
  }

  /// 衰减正弦：末端自然收住，不会突然停在偏移位置上。
  double _offsetFor(double t) =>
      math.sin(t * math.pi * 2 * _shakeCycles) * _shakeAmplitude * (1 - t);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) => Transform.translate(
        offset: Offset(_offsetFor(_shakeController.value), 0),
        child: child,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HappyCheckboxFormField(
            onChanged: widget.onChanged,
            validator: (checked) =>
                (checked ?? false) ? null : l10n.authAgreementRequired,
            label: Text(
              l10n.authAgreementPrefix,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: _linkRowIndent),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _linkButton(l10n.authUserAgreement),
                Text(
                  l10n.authAgreementAnd,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                _linkButton(l10n.authPrivacyPolicy),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 协议链接：文字观感，但热区撑到 44——法务链接被点不到是合规风险，不只是体验问题。
  Widget _linkButton(String label) => SizedBox(
    height: HappyControlSize.minTapTarget,
    child: HappyButton(
      label: label,
      variant: HappyButtonVariant.ghost,
      size: HappyButtonSize.small,
      isFullWidth: false,
      onPressed: widget.onOpenDocument,
    ),
  );
}
