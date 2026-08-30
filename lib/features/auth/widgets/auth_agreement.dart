import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";

/// 用户协议勾选（接入 `Form` 校验）。
///
/// 登录页与注册页共用一份，所以放在 `auth/widgets/` 而不是某一页的私有目录下。
///
/// 做成 `FormField` 而不是普通勾选框 + 弹提示：未勾选时错误文案就地显示在勾选框下方、
/// 方框转红，用户一眼看到卡在哪。**提交按钮不因未勾选而禁用**——按钮无声变灰
/// 会让人以为应用坏了；让他点、然后指出这里没勾，才是能自解释的路径。
///
/// 但"下方多一行小字"在视线停在按钮上时很容易被漏掉，所以 [shakeToken] 变化时
/// 额外抖一下 + 给一次错误触感，把注意力主动拉回来。
///
/// ## 为什么协议链接又收回了同一行
/// 早先把链接拆到第二行，理由是"整行可点的勾选行里嵌链接会误触"。实测下来这个
/// 顾虑站不住：链接自己有 `GestureDetector`，命中测试里**内层永远赢**，
/// 点在链接上就是打开链接，点在别处才是勾选。而拆两行的代价是实打实的——
/// 一句话被切成两截、中间空掉近 40px，读起来像断掉的句子，还白占一屏的高度。
///
/// 代价说清楚：链接的纵向热区是 `bodySmall` 行高 + 上下各 8，约 34px，
/// **低于 44 的推荐值**。横向热区是文字宽度（中文四个字约 48px）足够。
/// 这是用一点合规余量换回一行紧凑排版，产品确认过。
class AuthAgreement extends StatefulWidget {
  const AuthAgreement({
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
  State<AuthAgreement> createState() => _AuthAgreementState();
}

class _AuthAgreementState extends State<AuthAgreement>
    with SingleTickerProviderStateMixin {
  /// 抖动幅度（左右峰值位移）。
  static const double _shakeAmplitude = SkySpacing.s8;

  /// 一次抖动里的往复次数。3 次足够"被看见"，再多就像坏掉了。
  static const double _shakeCycles = 3;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: SkyMotion.normal,
  );

  @override
  void didUpdateWidget(AuthAgreement oldWidget) {
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
      child: SkyCheckboxFormField(
        onChanged: widget.onChanged,
        // 文案被链接的内边距撑高了，方框贴顶会很怪，改成居中。
        labelAlignment: CrossAxisAlignment.center,
        validator: (checked) =>
            (checked ?? false) ? null : l10n.authAgreementRequired,
        label: DefaultTextStyle.merge(
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          // Wrap 而不是 Row：日文的「利用規約」「プライバシーポリシー」两个词很长，
          // 窄屏上必须能折行，Row 会直接溢出。
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(l10n.authAgreementPrefix),
              _link(theme, l10n.authUserAgreement),
              Text(l10n.authAgreementAnd),
              _link(theme, l10n.authPrivacyPolicy),
            ],
          ),
        ),
      ),
    );
  }

  /// 协议链接：视觉上是行内文字，但有自己独立的命中区域。
  ///
  /// 用 `GestureDetector` 而不是 `InkWell`：水波会在勾选行的水波**上面**再炸一圈，
  /// 两层叠着看得出是"点重了"。这里的反馈由外层勾选行的水波 + 打开的页面承担。
  Widget _link(ThemeData theme, String label) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: widget.onOpenDocument,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SkySpacing.s4,
        vertical: SkySpacing.s8,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
