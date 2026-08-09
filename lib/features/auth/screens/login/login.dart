import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/features/auth/screens/login/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 登录页（v3）：手机号 + 短信验证码。
///
/// 没有密码、没有注册入口——未注册的手机号由后端直接建号。C 端产品的第一屏
/// 每多一个字段就多一层流失，能省的都省掉。
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();

  /// 登录请求进行中。成功后的跳转由路由守卫依据全局登录态完成，故无需本地导航。
  bool _isSubmitting = false;

  /// 校验已通过、正在播成功确认（此后马上换页）。
  bool _isSuccess = false;

  /// 已成功发码的手机号；null 表示还没发过码。
  String? _codeSentTo;

  /// 用户点了"修改"，从折叠态临时回到手机号编辑态。
  bool _editingPhone = false;

  /// 手机号是否折叠成摘要：发过码且不在编辑态。
  bool get _isPhoneCollapsed => _codeSentTo != null && !_editingPhone;

  /// 协议勾选态的镜像。只用来判断"提交被卡住是不是因为协议"，
  /// 真值仍由 [LoginAgreement] 内的 `FormField` 持有。
  bool _agreed = false;

  /// 自增一次就让协议行抖一下（见 [LoginAgreement.shakeToken]）。
  int _agreementShakeToken = 0;

  /// 登录按钮可点的条件：两个字段都填够且没有请求在途。
  ///
  /// 协议勾选**不**参与此判断——未勾选时让用户点得动、再就地报错，
  /// 比一个无声变灰的按钮好解释（见 [LoginAgreement]）。
  bool get _canSubmit =>
      !_isSubmitting &&
      AuthRules.isValidPhone(_phoneController.text) &&
      AuthRules.isValidSmsCode(_codeController.text);

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _phoneFocusNode.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  /// 输入变化即重算按钮可用性（依赖 controller 文本，需主动重建）。
  void _onInputChanged(String _) => setState(() {});

  /// 手机号变化：一旦不再是"已发码的那个号"，旧验证码与旧冷却全部失效。
  ///
  /// 不清掉的话用户会拿着上一个号收到的验证码去登录新号——必然失败，
  /// 而且冷却还在，改错号码的人要干等一分钟。
  void _onPhoneChanged(String value) {
    final changedAwayFromSentPhone =
        _codeSentTo != null && value.trim() != _codeSentTo;
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

  /// 点"修改"：展开手机号输入。聚焦交给 `PhoneField.autofocus`——输入框是这一帧
  /// 新挂上的，此刻手动 requestFocus 还没有 FocusNode 可用。
  void _onEditPhone() => setState(() => _editingPhone = true);

  Future<void> _onSendCode() async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();

    // 手机号没填对就不发码：就地触发字段校验（错误显示在输入框下方），不弹 toast。
    if (!AuthRules.isValidPhone(phone)) {
      _formKey.currentState?.validate();
      return;
    }

    try {
      await ref.read(smsCodeControllerProvider.notifier).send(phone);
      if (!mounted) return;
      HappyToast.success(context, l10n.authCodeSent);
      // 发出去之后手机号就没有输入价值了：折叠成摘要，焦点交给验证码格子。
      setState(() {
        _codeSentTo = phone;
        _editingPhone = false;
      });
      _codeFocusNode.requestFocus();
    } on Object catch (e) {
      if (!mounted) return;
      HappyToast.error(context, _messageOf(e, l10n));
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

    setState(() => _isSubmitting = true);
    try {
      final session = await auth.authenticate(
        phone: _phoneController.text.trim(),
        code: _codeController.text.trim(),
      );

      // 先在原页确认"填对了"：6 格变对勾。登录态一翻转路由就换页，
      // 不留这一下的话用户刚敲完最后一位就被弹走，不知道自己填对没填对。
      if (mounted) {
        setState(() => _isSuccess = true);
        await Future<void>.delayed(HappyMotion.slow);
      }

      // 落地会话 → 登录态翻转 → route_guard 重定向到 home（不在此手动导航）。
      await auth.completeSession(session);
    } on Object catch (e) {
      if (!mounted) return;
      // 会话落地阶段失败时成功态已经亮起来了，要撤回——否则屏幕上一排对勾配着
      // 一条错误提示，自相矛盾。
      setState(() => _isSuccess = false);
      HappyToast.error(context, _messageOf(e, l10n));
      // 只有"验证码本身被拒"才清空格子并回到第一格，省掉用户手动删 6 位。
      // 网络 / 服务端故障必须**保留**已填内容——那不是用户填错，清了等于白填一次。
      if (AuthErrorCode.isSmsCodeRejected(e)) {
        _codeController.clear();
        _codeFocusNode.requestFocus();
      }
    } finally {
      // 成功后不解锁输入：马上就要换页，此刻让格子重新可编辑毫无意义。
      if (mounted && !_isSuccess) setState(() => _isSubmitting = false);
    }
  }

  /// 协议链接：页面还没有，但可点元素必须有反馈，先给轻提示。
  // TODO(auth): 协议 / 隐私政策页面就绪后改为跳转（需新增路由，属 infra，须人工确认）。
  void _onOpenAgreement() =>
      HappyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.authErrorGeneric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final smsState = ref.watch(smsCodeControllerProvider);

    return Scaffold(
      // 星空背景让登录页第一眼是品牌，而不是一张空白表单。
      // 星云压到 0.7：满强度下品红那团会占掉下半屏，把天幕和星野都盖住——
      // 这一页要的第一眼是"星空"，星云只是里面的光源。
      body: HappyStarfieldBackground(
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: SingleChildScrollView(
            // 往下拖就收键盘：输入区在屏幕中部，用户想看下面的协议时不必先找收起按钮。
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: HappySemanticSpacing.screenPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: HappySpacing.s40),
                  const HappyBrandMark(),
                  const SizedBox(height: HappySpacing.s24),
                  // 叙事衬线大标题：产品调性的第一触点
                  Text(l10n.loginTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: HappySpacing.s8),
                  // 第一屏必须说清"这个 app 干什么"：从广告落地进来的新用户
                  // 只看到登录方式会直接退出。
                  // TODO(product): 价值文案为暂定版，待产品定稿。
                  Text(
                    l10n.loginSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // 示例故事卡：键盘弹起时收起——说服内容该给输入让位。
                  AnimatedSize(
                    duration: HappyMotion.normal,
                    curve: HappyMotion.standard,
                    alignment: Alignment.topCenter,
                    child: MediaQuery.viewInsetsOf(context).bottom > 0
                        ? const SizedBox(width: double.infinity)
                        : const Padding(
                            padding: EdgeInsets.only(top: HappySpacing.s24),
                            child: LoginSampleStory(),
                          ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.sectionGap),
                  // 发码前是可编辑输入框，发码后折叠成打码摘要 + "修改"。
                  AnimatedSwitcher(
                    duration: HappyMotion.fast,
                    child: _isPhoneCollapsed
                        ? PhoneSummary(
                            key: const ValueKey("phone-summary"),
                            phone: _codeSentTo!,
                            enabled: !_isSubmitting,
                            onEdit: _onEditPhone,
                          )
                        : PhoneField(
                            key: const ValueKey("phone-field"),
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            enabled: !_isSubmitting,
                            autofocus: _editingPhone,
                            onChanged: _onPhoneChanged,
                          ),
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
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
                  const SizedBox(height: HappySpacing.s24),
                  LoginAgreement(
                    onOpenDocument: _onOpenAgreement,
                    onChanged: (checked) => setState(() => _agreed = checked),
                    shakeToken: _agreementShakeToken,
                  ),
                  const SizedBox(height: HappySpacing.s24),
                  HappyButton(
                    label: l10n.loginSubmit,
                    size: HappyButtonSize.large,
                    isLoading: _isSubmitting,
                    onPressed: _canSubmit ? _onSubmit : null,
                  ),
                  const SizedBox(height: HappySemanticSpacing.itemGap),
                  Center(
                    child: Text(
                      l10n.loginSignUpNotice,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

/// 登录页的星空氛围光强度。见 `HappyStarfieldBackground.intensity`。
const double _backgroundIntensity = 0.7;
