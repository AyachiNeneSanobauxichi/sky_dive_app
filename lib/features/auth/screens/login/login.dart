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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // 登录标识符：邮箱或用户名（v2）。后端登录用 identifier 字段，不限定为邮箱。
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // 登录进行中的本地标记（控制按钮 loading）。登录成功的导航由路由守卫依据
  // 全局登录态自动完成，故此处不手动 goNamed。
  bool _isSubmitting = false;

  // "去注册" 富文本链接的点击识别器（需随 State 释放）。
  late final TapGestureRecognizer _goRegisterTap;

  @override
  void initState() {
    super.initState();
    _goRegisterTap = TapGestureRecognizer()
      ..onTap = () => context.goNamed(RouteName.register);
  }

  Future<void> _onLogin() async {
    final formValid = _formKey.currentState!.validate();
    if (!formValid) return; // 输入框有错，停止

    // 跨 await 前先捕获依赖 context 的对象，避免 async gap 后再读 context。
    final l10n = AppLocalizations.of(context);

    setState(() => _isSubmitting = true);
    try {
      // 登录 API 用 identifier（用户名或邮箱），这里传邮箱输入值。
      // 成功后全局登录态翻转，路由守卫自动跳转 home。
      await ref
          .read(authControllerProvider.notifier)
          .login(
            identifier: _identifierController.text.trim(),
            password: _passwordController.text,
          );
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
    _identifierController.dispose();
    _passwordController.dispose();
    _goRegisterTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 极光背景让登录页第一眼就是品牌，而不是一张空白表单
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
                  const SizedBox(height: HappySpacing.s56),
                  const HappyBrandMark(),
                  const SizedBox(height: HappySpacing.s24),
                  // 叙事衬线大标题：产品调性的第一触点
                  Text(l10n.loginTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: HappySpacing.s8),
                  Text(
                    l10n.loginSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.sectionGap),
                  AuthInput(
                    // v2：登录标识符接受邮箱或用户名，故不再做邮箱格式校验，仅校验必填。
                    label: l10n.authIdentifierLabel,
                    icon: LucideIcons.user,
                    controller: _identifierController,
                    textInputAction: TextInputAction.next,
                    autofillHints: const <String>[AutofillHints.username],
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
                  AuthPassword(
                    // 登录只校验必填：密码复杂度规则属于注册期约束，登录不重复施加。
                    label: l10n.authPasswordLabel,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    autofillHints: const <String>[AutofillHints.password],
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: HappySpacing.s4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(l10n.loginForgotPassword),
                    ),
                  ),
                  const SizedBox(height: HappySpacing.s12),
                  HappyButton(
                    label: l10n.loginSubmit,
                    onPressed: _onLogin,
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
                          TextSpan(text: l10n.loginNoAccount),
                          TextSpan(
                            text: l10n.loginGoRegister,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                            recognizer: _goRegisterTap,
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
      // 整页轻微上浮淡入：进入认证流程时给一个"落位"的仪式感
    ).animate().fadeIn(duration: HappyMotion.slow, curve: HappyMotion.standard);
  }
}
