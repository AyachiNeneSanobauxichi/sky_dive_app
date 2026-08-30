import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";

/// 注册页：显示名 + 邮箱 + 密码（+ 选填手机号）。
///
/// ## 只收四个字段
/// 体重、身高、紧急联系人、护照拼写这些跳伞**确实需要**的资料一个都不在这里收——
/// 它们属于"下第一单之前"，放进注册表单只会把转化率按在地上。
/// 注册的唯一目的是：拿到一个能收行程确认邮件的地址，和一个能再次登录的凭据。
///
/// ## 手机号为什么选填
/// 填了的好处是当天天气改期能收到短信（邮件在户外没人看），
/// 但强制它就等于把"不想给号码"的人挡在门外。所以给理由、不给强制。
///
/// ## 注册成功直接进 app
/// 后端返回的就是一份可用会话，让用户注册完再登录一次是纯粹的多余步骤。
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.initialEmail});

  /// 从登录页带过来的邮箱预填值。
  final String? initialEmail;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController = TextEditingController(
    text: widget.initialEmail ?? "",
  );
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  bool _isSubmitting = false;

  /// 校验已通过、正在播成功确认（此后马上换页）。
  bool _isSuccess = false;

  /// 服务端返回的、属于某个字段的错误（邮箱 / 手机号已被占用）。
  /// 这类错误客户端校验不出来，但它确实属于那个字段，就该钉在字段下方。
  String? _emailErrorText;
  String? _phoneErrorText;

  bool _agreed = false;
  int _agreementShakeToken = 0;

  /// 密码强度（驱动强度条）。
  PasswordStrength _strength = PasswordStrength.empty;

  /// 提交按钮可点的条件。四个必填项全部达标才亮。
  ///
  /// 注册与登录不同，这里**该**做严格的前置校验：密码规则是我们定的，
  /// 让用户提交一次再被后端打回来，等于白等一个网络往返。
  bool get _canSubmit =>
      !_isSubmitting &&
      _nameController.text.trim().isNotEmpty &&
      AuthRules.isValidEmail(_emailController.text) &&
      AuthRules.isValidPassword(_passwordController.text) &&
      _confirmController.text == _passwordController.text;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onInputChanged(String _) => setState(() {});

  void _onEmailChanged(String _) => setState(() => _emailErrorText = null);

  void _onPhoneChanged(String _) => setState(() => _phoneErrorText = null);

  void _onPasswordChanged(String value) =>
      setState(() => _strength = AuthRules.passwordStrength(value));

  /// 确认密码的校验：规则要比对**另一个字段**，所以不能用 PasswordField 的默认规则。
  String? _validateConfirm(String? value, AppLocalizations l10n) {
    final input = value ?? "";
    if (input.isEmpty) return l10n.authConfirmPasswordRequired;
    if (input != _passwordController.text) return l10n.authPasswordMismatch;
    return null;
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      if (!_agreed) setState(() => _agreementShakeToken++);
      return;
    }

    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    // 跨 await 先拿住 notifier：动效播完后要用它落地会话，那时页面可能已经卸载，
    // 再读 ref 会炸——而会话必须落地，否则用户白注册一次。
    final auth = ref.read(authControllerProvider.notifier);

    setState(() {
      _isSubmitting = true;
      _emailErrorText = null;
      _phoneErrorText = null;
    });
    try {
      final session = await auth.registerAccount(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _nameController.text,
        phone: _phoneController.text,
      );

      // 成功确认：先给一次明确的"账号建好了"，再让路由把人送进 app。
      if (mounted) {
        setState(() => _isSuccess = true);
        SkyToast.success(context, l10n.registerSuccess);
        await Future<void>.delayed(SkyMotion.slow);
      }

      await auth.completeSession(session);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _isSuccess = false);
      _handleFailure(e, l10n);
    } finally {
      if (mounted && !_isSuccess) setState(() => _isSubmitting = false);
    }
  }

  /// "已被占用"这类错误就地钉在对应字段下方——它需要用户**改那一个字段**，
  /// 而 toast 三秒就没了，用户只会拿同样的邮箱再试一次。
  void _handleFailure(Object error, AppLocalizations l10n) {
    final message = authFailureMessage(error, l10n);

    switch (error) {
      case BusinessFailure(code: AuthErrorCode.emailAlreadyRegistered):
        setState(() => _emailErrorText = message);
        _emailFocusNode.requestFocus();
      case BusinessFailure(code: AuthErrorCode.phoneAlreadyRegistered):
        setState(() => _phoneErrorText = message);
        _phoneFocusNode.requestFocus();
      default:
        // 网络 / 服务端故障：**不清任何输入**，那不是用户的错。
        SkyToast.error(context, message);
    }
  }

  // TODO(auth): 协议 / 隐私政策页面就绪后改为跳转（需新增路由，属 infra，须人工确认）。
  void _onOpenAgreement() =>
      SkyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 与登录页同一档氛围强度：两页连着出现，天色不该有明暗跳变。
      body: SkyBackground(
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // 透明 AppBar 只为一个返回箭头：注册是从登录 push 进来的深入页，
              // 必须有可见的返回路径（不能只靠系统手势）。
              AppBar(title: Text(l10n.registerTitle)),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    SkySemanticSpacing.screenPadding,
                    SkySpacing.s8,
                    SkySemanticSpacing.screenPadding,
                    SkySpacing.s32,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          l10n.registerSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: SkySemanticSpacing.sectionGap),

                        DisplayNameField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          enabled: !_isSubmitting,
                          // 首屏第一个必填字段自动聚焦，省一次点击；
                          // 其余字段一律不 autofocus（会顶起键盘遮住内容）。
                          autofocus: widget.initialEmail == null,
                          onChanged: _onInputChanged,
                          onSubmitted: (_) => _emailFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: SkySemanticSpacing.itemGap),

                        EmailField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          enabled: !_isSubmitting,
                          isNewAccount: true,
                          errorText: _emailErrorText,
                          onChanged: _onEmailChanged,
                          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: SkySemanticSpacing.itemGap),

                        PasswordField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          enabled: !_isSubmitting,
                          isNewAccount: true,
                          labelKind: PasswordFieldLabel.newPassword,
                          textInputAction: TextInputAction.next,
                          onChanged: _onPasswordChanged,
                          onSubmitted: (_) => _confirmFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: SkySpacing.s8),
                        PasswordStrengthBar(strength: _strength),
                        const SizedBox(height: SkySpacing.s4),
                        Text(
                          l10n.authPasswordRule(AuthRules.passwordMinLength),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: SkySemanticSpacing.itemGap),

                        PasswordField(
                          controller: _confirmController,
                          focusNode: _confirmFocusNode,
                          enabled: !_isSubmitting,
                          isNewAccount: true,
                          labelKind: PasswordFieldLabel.confirmPassword,
                          textInputAction: TextInputAction.next,
                          // 两次密码不一致要**尽早**说，不能等提交：
                          // 用户在这个字段上输入本身就是在"比对"，边输边判正合语义。
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => _validateConfirm(value, l10n),
                          onChanged: _onInputChanged,
                          onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: SkySemanticSpacing.sectionGap),

                        PhoneField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          enabled: !_isSubmitting,
                          isOptional: true,
                          textInputAction: TextInputAction.done,
                          onChanged: _onPhoneChanged,
                        ),
                        if (_phoneErrorText != null) ...<Widget>[
                          const SizedBox(height: SkySpacing.s6),
                          Text(
                            _phoneErrorText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: SkySpacing.s6),
                        // 给理由而不是给强制：说清填了能换来什么。
                        Text(
                          l10n.authPhoneOptionalReason,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: SkySemanticSpacing.sectionGap),

                        AuthAgreement(
                          onOpenDocument: _onOpenAgreement,
                          onChanged: (checked) =>
                              setState(() => _agreed = checked),
                          shakeToken: _agreementShakeToken,
                        ),
                        const SizedBox(height: SkySpacing.s24),

                        SkyButton(
                          label: l10n.registerSubmit,
                          size: SkyButtonSize.large,
                          isLoading: _isSubmitting,
                          onPressed: _canSubmit ? _onSubmit : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: SkyMotion.normal, curve: SkyMotion.standard);
  }
}

/// 注册页的天空氛围光强度，与登录页保持一致。
const double _backgroundIntensity = 0.7;
