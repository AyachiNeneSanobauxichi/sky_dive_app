import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:sky_dive/app/router/index.dart";
import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/features/auth/screens/login/widgets/index.dart";
import "package:sky_dive/features/weather/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";

/// 登录页：邮箱 + 密码 / 手机号 + 验证码，两条路由顶部的分段控件切换。
///
/// ## 为什么两条路都要
/// - **邮箱密码**是日本 C 端预约产品的主流，也是唯一能沉淀"可联系邮箱"的入口
///   （行程确认、保险单、天气改期通知都得发邮件）；
/// - **手机验证码**给现场临时下单的客人：排队时不想现编密码，一条短信最快，
///   未注册的号码由后端直接建号。
///
/// ## 表单只有一份
/// 两种方式共用同一个 `Form` 与同一个提交按钮，只换中间的字段区。
/// 做成两个独立页面会让"我到底在哪一页"变成一个需要思考的问题，
/// 而这只是同一件事（登录）的两种填法。
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();

  /// 当前登录方式。
  AuthMethod _method = AuthMethod.email;

  /// 登录请求进行中。成功后的跳转由路由守卫依据全局登录态完成，故无需本地导航。
  bool _isSubmitting = false;

  /// 校验已通过、正在播成功确认（此后马上换页）。
  bool _isSuccess = false;

  /// 已成功发码的手机号；null 表示还没发过码。
  String? _codeSentTo;

  /// 用户点了"修改"，从折叠态临时回到手机号编辑态。
  bool _editingPhone = false;

  /// 是否把手机号 / 邮箱的格式错误显示出来。
  ///
  /// **输入过程中永远是 false**：这两个字段都是逐字敲进去的，敲到一半就红着
  /// "格式不正确"是在指责用户"还没输完"。只有到了该判的时刻才置起——
  /// ① 离开输入框（人已经填完走人了，这时的半截内容就是真错）；② 点了发送验证码。
  ///
  /// 置起后传 `AutovalidateMode.always`，用户改对的那一刻红字自己消失；
  /// 而**重新聚焦回来就复位**——既然又在编辑了，就回到"输入时不判"。
  bool _showPhoneError = false;
  bool _showEmailError = false;

  /// 服务端返回的、属于**某个字段**的错误（如"该账号已被停用"）。
  /// 就地显示在字段下方，而不是弹一条会消失的 toast。
  String? _emailErrorText;

  /// 协议勾选态的镜像。只用来判断"提交被卡住是不是因为协议"，
  /// 真值仍由 [AuthAgreement] 内的 `FormField` 持有。
  bool _agreed = false;

  /// 自增一次就让协议行抖一下（见 [AuthAgreement.shakeToken]）。
  int _agreementShakeToken = 0;

  /// 手机号是否折叠成摘要：发过码且不在编辑态。
  bool get _isPhoneCollapsed => _codeSentTo != null && !_editingPhone;

  /// 提交按钮可点的条件。
  ///
  /// 协议勾选**不**参与此判断——未勾选时让用户点得动、再就地报错，
  /// 比一个无声变灰的按钮好解释（见 [AuthAgreement]）。
  bool get _canSubmit {
    if (_isSubmitting) return false;
    return switch (_method) {
      // 登录时密码只要求非空：拿"至少 8 位"去拦用户毫无意义，
      // 他的密码长什么样服务端说了算，多拦一道只会把老账号挡在门外。
      AuthMethod.email =>
        AuthRules.isValidEmail(_emailController.text) &&
            _passwordController.text.isNotEmpty,
      AuthMethod.phone =>
        AuthRules.isValidPhone(_phoneController.text) &&
            AuthRules.isValidSmsCode(_codeController.text),
    };
  }

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(_onPhoneFocusChanged);
    _emailFocusNode.addListener(_onEmailFocusChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _emailFocusNode
      ..removeListener(_onEmailFocusChanged)
      ..dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode
      ..removeListener(_onPhoneFocusChanged)
      ..dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  /// 焦点变化决定要不要显示格式错误（见 [_showPhoneError]）。
  ///
  /// 离开时才判，且**空着走开不算错**：没填就走开的人多半只是想先看看下面写了什么，
  /// 冲他喊"请输入邮箱"是无中生有；等他真去提交时再拦也不迟。
  void _onEmailFocusChanged() {
    final text = _emailController.text.trim();
    final shouldShow = _emailFocusNode.hasFocus
        ? false
        : text.isNotEmpty && !AuthRules.isValidEmail(text);
    if (_showEmailError == shouldShow) return;
    setState(() => _showEmailError = shouldShow);
  }

  void _onPhoneFocusChanged() {
    final text = _phoneController.text.trim();
    final shouldShow = _phoneFocusNode.hasFocus
        ? false
        : text.isNotEmpty && !AuthRules.isValidPhone(text);
    if (_showPhoneError == shouldShow) return;
    setState(() => _showPhoneError = shouldShow);
  }

  /// 输入变化即重算按钮可用性（依赖 controller 文本，需主动重建）。
  void _onInputChanged(String _) => setState(() {});

  /// 邮箱变化：清掉服务端就地错误。用户已经在改了，旧的"账号已停用"留在下面
  /// 只会让他以为改了也没用。
  void _onEmailChanged(String _) {
    if (_emailErrorText == null) {
      setState(() {});
      return;
    }
    setState(() => _emailErrorText = null);
  }

  /// 手机号变化：一旦不再是"已发码的那个号"，旧验证码与旧冷却全部失效。
  ///
  /// 不清掉的话用户会拿着上一个号收到的验证码去登录新号——必然失败，
  /// 而且冷却还在，改错号码的人要干等一分钟。
  void _onPhoneChanged(String value) {
    final changedAwayFromSentPhone =
        _codeSentTo != null && AuthRules.normalizePhone(value) != _codeSentTo;
    if (changedAwayFromSentPhone) {
      _codeController.clear();
      ref.read(smsCodeControllerProvider.notifier).reset();
    }
    setState(() {
      if (changedAwayFromSentPhone) {
        _codeSentTo = null;
        _editingPhone = false;
      }
    });
  }

  /// 切换登录方式。
  ///
  /// **不清空另一条路已填的内容**：用户可能只是想看看另一种方式长什么样，
  /// 切回来发现自己填的邮箱没了会很恼火。收键盘是因为字段区整个换掉了，
  /// 留着键盘会对着一个不存在的输入框。
  void _onMethodChanged(AuthMethod method) {
    if (method == _method) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _method = method;
      // 错误提示是"上一种方式"的，跟着一起退场。
      _showEmailError = false;
      _showPhoneError = false;
      _emailErrorText = null;
    });
  }

  /// 点"修改"：展开手机号输入。聚焦交给 `PhoneField.autofocus`——输入框是这一帧
  /// 新挂上的，此刻手动 requestFocus 还没有 FocusNode 可用。
  void _onEditPhone() => setState(() => _editingPhone = true);

  Future<void> _onSendCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = AuthRules.normalizePhone(_phoneController.text);

    // 手机号没填对就不发码：就地点亮**这一个字段**（错误显示在输入框下方），不弹 toast。
    //
    // 刻意不走整表单 `validate()`：那会把验证码格子和协议勾选一起点红——
    // 用户此刻只是想发个码，那两件事还没轮到他做，却先被判了两次错。
    if (!AuthRules.isValidPhone(phone)) {
      setState(() => _showPhoneError = true);
      return;
    }

    try {
      await ref.read(smsCodeControllerProvider.notifier).send(phone);
      if (!mounted) return;
      SkyToast.success(context, l10n.authCodeSent);
      // 发出去之后手机号就没有输入价值了：折叠成摘要，焦点交给验证码格子。
      setState(() {
        _codeSentTo = phone;
        _editingPhone = false;
      });
      _codeFocusNode.requestFocus();
    } on Object catch (e) {
      if (!mounted) return;
      SkyToast.error(context, authFailureMessage(e, l10n));
    }
  }

  Future<void> _onSubmit() async {
    // 协议未勾选也在这里被拦下，错误就地显示在勾选框下方。
    if (!(_formKey.currentState?.validate() ?? false)) {
      // 协议是最常见的卡点，且错误文案在页面下方容易被漏看：再抖一下 + 震一下。
      if (!_agreed) setState(() => _agreementShakeToken++);
      return;
    }

    final l10n = AppLocalizations.of(context);
    // 提交即收键盘：结果（toast / 跳转）在键盘下面，挡着等于没反馈。
    FocusScope.of(context).unfocus();

    // 跨 await 先拿住 notifier：动效播完后要用它落地会话，那时页面可能已经卸载，
    // 再读 ref 会炸——而会话必须落地，否则用户白登录一次。
    final auth = ref.read(authControllerProvider.notifier);

    setState(() {
      _isSubmitting = true;
      _emailErrorText = null;
    });
    try {
      final session = switch (_method) {
        AuthMethod.email => await auth.authenticateWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        ),
        AuthMethod.phone => await auth.authenticateWithPhone(
          phone: _phoneController.text,
          code: _codeController.text,
        ),
      };

      // 先在原页确认"通过了"：短信方式下 6 格变对勾。登录态一翻转路由就换页，
      // 不留这一下的话用户刚敲完最后一位就被弹走，不知道自己填对没填对。
      if (mounted) {
        setState(() => _isSuccess = true);
        await Future<void>.delayed(SkyMotion.slow);
      }

      // 落地会话 → 登录态翻转 → route_guard 重定向到首页（不在此手动导航）。
      await auth.completeSession(session);
    } on Object catch (e) {
      if (!mounted) return;
      // 会话落地阶段失败时成功态已经亮起来了，要撤回——否则屏幕上一排对勾配着
      // 一条错误提示，自相矛盾。
      setState(() => _isSuccess = false);
      _handleSubmitFailure(e, l10n);
    } finally {
      // 成功后不解锁输入：马上就要换页，此刻让字段重新可编辑毫无意义。
      if (mounted && !_isSuccess) setState(() => _isSubmitting = false);
    }
  }

  /// 失败后清不清用户已填的内容，**按"谁错了"分**：
  /// 用户填错（密码不对、验证码不对）→ 清空该字段并聚焦回去，省掉手动删；
  /// 网络 / 服务端故障 → **保留**已填内容，那不是用户的错，清了等于让他白填一次。
  /// 判断依据只能是业务码（[AuthErrorCode]），不能靠文案匹配——文案会随语言变。
  void _handleSubmitFailure(Object error, AppLocalizations l10n) {
    final message = authFailureMessage(error, l10n);

    if (AuthErrorCode.isPasswordRejected(error)) {
      // 密码错：只清密码，**保留邮箱**。邮箱多半是对的，清掉纯属添乱。
      _passwordController.clear();
      SkyToast.error(context, message);
      _passwordFocusNode.requestFocus();
      return;
    }
    if (AuthErrorCode.isSmsCodeRejected(error)) {
      _codeController.clear();
      SkyToast.error(context, message);
      _codeFocusNode.requestFocus();
      return;
    }
    if (error case BusinessFailure(code: AuthErrorCode.accountDisabled)) {
      // 账号被停用不是"填错了"，而是这个账号本身有问题：就地钉在邮箱字段下方，
      // 用 toast 的话它三秒就没了，用户会一直重试同一个账号。
      setState(() => _emailErrorText = message);
      return;
    }
    SkyToast.error(context, message);
  }

  /// 去注册。把已填的邮箱带过去预填——发现自己没注册的人，
  /// 不该被要求把邮箱再敲一遍。
  void _onGoRegister() {
    final email = _emailController.text.trim();
    context.pushNamed(
      RouteName.register,
      queryParameters: <String, String>{
        if (AuthRules.isValidEmail(email)) RouteQuery.email: email,
      },
    );
  }

  /// 协议链接：页面还没有，但可点元素必须有反馈，先给轻提示。
  // TODO(auth): 协议 / 隐私政策页面就绪后改为跳转（需新增路由，属 infra，须人工确认）。
  void _onOpenAgreement() =>
      SkyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  /// 一键填入演示账号（仅 mock 期间）。
  void _onFillDemoAccount(String email) {
    setState(() {
      _method = AuthMethod.email;
      _emailController.text = email;
      _passwordController.text = AuthMockDataSource.demoPassword;
      _showEmailError = false;
      _emailErrorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 天空背景让登录页第一眼是品牌，而不是一张空白表单。
      // 强度压到 0.7：满强度下近层云会占掉下半屏，把表单压住——
      // 这一页要的第一眼是"天"，云只是里面的层次。
      body: SkyBackground(
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: SingleChildScrollView(
            // 往下拖就收键盘：输入区在屏幕中部，用户想看下面的协议时不必先找收起按钮。
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: SkySemanticSpacing.screenPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: SkySpacing.s40),
                  const SkyBrandMark(),
                  const SizedBox(height: SkySpacing.s24),
                  Text(l10n.loginTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: SkySpacing.s8),
                  // 第一屏必须说清"这个 app 干什么"：从广告落地进来的新用户
                  // 只看到登录方式会直接退出。
                  Text(
                    l10n.loginSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // 今日放飞窗口：客人打开 app 的第一诉求是"今天能不能跳"，
                  // 不是登录。这条信息不需要鉴权，没理由藏在登录之后。
                  //
                  // 键盘弹起时整张收走——说服性内容该给输入让位，
                  // 而且它就在输入区正上方，不收的话表单会被顶出屏幕。
                  AnimatedSize(
                    duration: SkyMotion.normal,
                    curve: SkyMotion.standard,
                    alignment: Alignment.topCenter,
                    child: MediaQuery.viewInsetsOf(context).bottom > 0
                        ? const SizedBox(width: double.infinity)
                        : const Padding(
                            padding: EdgeInsets.only(top: SkySpacing.s24),
                            child: WeatherWindowCard(),
                          ),
                  ),
                  const SizedBox(height: SkySemanticSpacing.sectionGap),
                  AuthMethodSwitcher(
                    method: _method,
                    enabled: !_isSubmitting,
                    onChanged: _onMethodChanged,
                  ),
                  const SizedBox(height: SkySpacing.s24),
                  // 两种方式的字段区。AnimatedSize 吃掉高度差，AnimatedSwitcher
                  // 做交叉淡入——直接换会让下面的按钮"跳"一下。
                  AnimatedSize(
                    duration: SkyMotion.normal,
                    curve: SkyMotion.standard,
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                      duration: SkyMotion.fast,
                      child: _method.isEmail
                          ? _buildEmailFields(l10n)
                          : _buildPhoneFields(),
                    ),
                  ),
                  const SizedBox(height: SkySpacing.s24),
                  AuthAgreement(
                    onOpenDocument: _onOpenAgreement,
                    onChanged: (checked) => setState(() => _agreed = checked),
                    shakeToken: _agreementShakeToken,
                  ),
                  const SizedBox(height: SkySpacing.s24),
                  SkyButton(
                    label: l10n.loginSubmit,
                    size: SkyButtonSize.large,
                    isLoading: _isSubmitting,
                    onPressed: _canSubmit ? _onSubmit : null,
                  ),
                  const SizedBox(height: SkySemanticSpacing.itemGap),
                  _buildFooter(theme, l10n),
                  if (kAuthMockEnabled) ...<Widget>[
                    const SizedBox(height: SkySemanticSpacing.sectionGap),
                    MockCredentialsHint(onFill: _onFillDemoAccount),
                  ],
                  const SizedBox(height: SkySpacing.s32),
                ],
              ),
            ),
          ),
        ),
      ),
      // 整页轻微淡入：进入认证流程时给一个"落位"的仪式感
    ).animate().fadeIn(duration: SkyMotion.slow, curve: SkyMotion.standard);
  }

  Widget _buildEmailFields(AppLocalizations l10n) {
    return Column(
      key: const ValueKey<String>("email-fields"),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        EmailField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          enabled: !_isSubmitting,
          errorText: _emailErrorText,
          autovalidateMode: _showEmailError
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          onChanged: _onEmailChanged,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: SkySemanticSpacing.itemGap),
        PasswordField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          enabled: !_isSubmitting,
          onChanged: _onInputChanged,
          // 末字段回车即提交：填完密码用户没有别的意图，省掉一次点击。
          onSubmitted: (_) {
            if (_canSubmit) _onSubmit();
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: SizedBox(
            height: SkyControlSize.minTapTarget,
            child: SkyButton(
              label: l10n.authForgotPassword,
              variant: SkyButtonVariant.ghost,
              size: SkyButtonSize.small,
              isFullWidth: false,
              // TODO(auth): 找回密码流程待产品与后端定稿（需新增路由，属 infra）。
              onPressed: _isSubmitting
                  ? null
                  : () => SkyToast.info(context, l10n.commonComingSoon),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFields() {
    final smsState = ref.watch(smsCodeControllerProvider);

    return Column(
      key: const ValueKey<String>("phone-fields"),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 发码前是可编辑输入框，发码后折叠成打码摘要 + "修改"。
        AnimatedSwitcher(
          duration: SkyMotion.fast,
          child: _isPhoneCollapsed
              ? PhoneSummary(
                  key: const ValueKey<String>("phone-summary"),
                  phone: _codeSentTo!,
                  enabled: !_isSubmitting,
                  onEdit: _onEditPhone,
                )
              : PhoneField(
                  key: const ValueKey<String>("phone-field"),
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  enabled: !_isSubmitting,
                  autofocus: _editingPhone,
                  autovalidateMode: _showPhoneError
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  onChanged: _onPhoneChanged,
                ),
        ),
        const SizedBox(height: SkySemanticSpacing.itemGap),
        SmsCodeField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          state: smsState,
          enabled: !_isSubmitting,
          isSuccess: _isSuccess,
          onSendCode: _onSendCode,
          onChanged: _onInputChanged,
          // 6 位填满即自动提交：这一步用户没有别的意图，省掉一次点击。
          onCompleted: (_) {
            if (_canSubmit) _onSubmit();
          },
        ),
      ],
    );
  }

  /// 页脚。
  ///
  /// 只在**邮箱方式**下露注册入口：短信方式首登即建号，那条路上根本不存在
  /// "还没注册"这个状态，摆一个注册链接只会让人以为自己漏了一步。
  Widget _buildFooter(ThemeData theme, AppLocalizations l10n) {
    return AnimatedSize(
      duration: SkyMotion.normal,
      curve: SkyMotion.standard,
      alignment: Alignment.topCenter,
      child: _method.isEmail
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    l10n.loginNoAccount,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(
                  height: SkyControlSize.minTapTarget,
                  child: SkyButton(
                    label: l10n.loginGoRegister,
                    variant: SkyButtonVariant.ghost,
                    size: SkyButtonSize.small,
                    isFullWidth: false,
                    onPressed: _isSubmitting ? null : _onGoRegister,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                l10n.loginPhoneAutoSignUp,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }
}

/// 登录页的天空氛围光强度。见 `SkyBackground.intensity`。
const double _backgroundIntensity = 0.7;
