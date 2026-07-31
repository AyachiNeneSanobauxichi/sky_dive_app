import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

export "widgets/index.dart";

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isChecked = false;

  // 注册是「提交后导航离开」的一次性动作，不产生共享登录态（后端不下发令牌），
  // 故用本地提交标记控制按钮 loading，而非塞进 authController 的 AsyncValue。
  bool _isSubmitting = false;

  // "去登录" 富文本链接的点击识别器（需随 State 释放）。
  late final TapGestureRecognizer _goLoginTap;

  @override
  void initState() {
    super.initState();
    _goLoginTap = TapGestureRecognizer()
      ..onTap = () => context.goNamed(RouteName.login);
  }

  Future<void> _onRegister() async {
    // 表单校验已含协议勾选（HappyCheckboxFormField 自带 validator）。
    final formValid = _formKey.currentState!.validate();
    if (!formValid) return; // 输入框/协议有错，停止

    // 跨 await 前先捕获依赖 context 的对象，避免 async gap 后再读 context。
    final l10n = AppLocalizations.of(context);

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            username: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (!mounted) return;
      // 注册成功：提示并回登录页（后端不下发令牌，需再登录）。
      HappyToast.success(context, l10n.registerSuccess);
      context.goNamed(RouteName.login);
    } on Object catch (e) {
      if (!mounted) return;
      final msg = e is Failure ? e.displayMessage : l10n.authErrorGeneric;
      HappyToast.error(context, msg);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _goLoginTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: HappyAuroraBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: HappySemanticSpacing.screenPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: HappySpacing.s48),
                  const HappyBrandMark(icon: LucideIcons.userPlus),
                  const SizedBox(height: HappySpacing.s24),
                  Text(l10n.registerTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: HappySpacing.s8),
                  Text(
                    l10n.registerSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.sectionGap),
                  AuthInput(
                    label: l10n.registerUsernameLabel,
                    icon: LucideIcons.user,
                    controller: _nameController,
                    autofillHints: const <String>[AutofillHints.newUsername],
                    validator: FormBuilderValidators.compose(
                      <String? Function(String?)>[
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                        FormBuilderValidators.maxLength(20),
                      ],
                    ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
                  AuthInput(
                    label: l10n.authEmailLabel,
                    icon: LucideIcons.mail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const <String>[AutofillHints.email],
                    validator: FormBuilderValidators.compose(
                      <String? Function(String?)>[
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
                  AuthPassword(
                    label: l10n.authPasswordLabel,
                    controller: _passwordController,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    // 密码复杂度（v2）：至少 8 位，且含大小写字母、数字、特殊字符。
                    // 正则与后端 passwordSchema 保持一致，特殊字符限定 @$!%*?& 。
                    validator: FormBuilderValidators.compose(<
                      String? Function(String?)
                    >[
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(8),
                      FormBuilderValidators.match(
                        RegExp(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
                        ),
                        errorText: l10n.authPasswordWeak,
                        checkNullOrEmpty: false,
                      ),
                    ]),
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
                  AuthPassword(
                    label: l10n.registerConfirmPasswordLabel,
                    controller: _confirmPasswordController,
                    autofillHints: const <String>[AutofillHints.newPassword],
                    validator: FormBuilderValidators.compose(
                      <String? Function(String?)>[
                        FormBuilderValidators.required(),
                        (value) => value == _passwordController.text
                            ? null
                            : l10n.registerPasswordMismatch,
                      ],
                    ),
                  ),
                  const SizedBox(height: HappySpacing.s20),
                  HappyCheckboxFormField(
                    value: _isChecked,
                    label: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(text: l10n.registerAgreementPrefix),
                          TextSpan(
                            text: l10n.registerUserAgreement,
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                          TextSpan(text: l10n.registerAgreementAnd),
                          TextSpan(
                            text: l10n.registerPrivacyPolicy,
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                    validator: (v) =>
                        (v ?? false) ? null : l10n.registerAgreementRequired,
                    onChanged: (value) => setState(() => _isChecked = value),
                  ),
                  const SizedBox(height: HappySpacing.s20),
                  HappyButton(
                    label: l10n.registerSubmit,
                    onPressed: _onRegister,
                    isLoading: _isSubmitting,
                    size: HappyButtonSize.large,
                  ),
                  const SizedBox(height: HappySemanticSpacing.sectionGap),
                  OrDivider(text: l10n.commonOr),
                  const SizedBox(height: HappySpacing.s24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: HappySpacing.s16,
                    children: <Widget>[
                      // Lucide 不含品牌 logo，这里先用语义图标占位。
                      // TODO(auth): 三方登录接入后换成各家官方 SVG（flutter_svg）。
                      SocialIconButton(icon: LucideIcons.mail, onTap: () {}),
                      SocialIconButton(icon: LucideIcons.apple, onTap: () {}),
                      SocialIconButton(icon: LucideIcons.wallet, onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: HappySpacing.s40),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodyMedium,
                        children: <InlineSpan>[
                          TextSpan(text: l10n.registerHaveAccount),
                          TextSpan(
                            text: l10n.registerGoLogin,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            recognizer: _goLoginTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: HappySpacing.s32),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: HappyMotion.slow, curve: HappyMotion.standard);
  }
}
