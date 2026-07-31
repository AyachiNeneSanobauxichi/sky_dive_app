// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'HappyOS';

  @override
  String get commonOr => '或';

  @override
  String get authEmailLabel => '邮箱';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authShowPassword => '显示密码';

  @override
  String get authHidePassword => '隐藏密码';

  @override
  String get authIdentifierLabel => '邮箱或用户名';

  @override
  String get authPasswordWeak => '密码需包含至少一个大写字母、一个小写字母、一个数字和一个特殊字符';

  @override
  String get loginTitle => '欢迎回来';

  @override
  String get loginSubtitle => '登录以继续管理你的任务';

  @override
  String get loginForgotPassword => '忘记密码？';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginNoAccount => '还没有账号？';

  @override
  String get loginGoRegister => '去注册';

  @override
  String get registerTitle => '创建账号';

  @override
  String get registerSubtitle => '开始管理你的任务';

  @override
  String get registerUsernameLabel => '用户名';

  @override
  String get registerConfirmPasswordLabel => '确认密码';

  @override
  String get registerPasswordMismatch => '两次密码不一致';

  @override
  String get registerAgreementPrefix => '我已阅读并同意';

  @override
  String get registerUserAgreement => '《用户协议》';

  @override
  String get registerAgreementAnd => '和';

  @override
  String get registerPrivacyPolicy => '《隐私政策》';

  @override
  String get registerAgreementRequired => '请先阅读并同意用户协议';

  @override
  String get registerSubmit => '注册';

  @override
  String get registerHaveAccount => '已有账号？';

  @override
  String get registerGoLogin => '去登录';

  @override
  String get authErrorGeneric => '出错了，请稍后再试';

  @override
  String get registerSuccess => '注册成功，请登录';

  @override
  String get commonCancel => '取消';

  @override
  String get commonSave => '保存';

  @override
  String get commonRetry => '重试';

  @override
  String get commonApply => '应用';

  @override
  String get commonReset => '重置';

  @override
  String get homeTitle => 'HappyOS';

  @override
  String get homePlaceholder => '你的故事会出现在这里，目前还没有内容。';

  @override
  String get homeLogout => '退出登录';

  @override
  String get homeLogoutFailed => '退出登录失败，请重试。';

  @override
  String get homeCreateStory => '把一段经历写成故事';

  @override
  String get storyTitle => '你的故事';

  @override
  String get storyComposerTitle => '那天到底发生了什么？';

  @override
  String get storyComposerSubtitle => '写下一段真实发生在你身上的事。越具体，改出来的故事越有劲。';

  @override
  String get storyComposerHint => '那天末班地铁上，我发现对面那个人一直在看车窗里我的倒影……';

  @override
  String get storyExperienceLabel => '你的经历';

  @override
  String get storyEditExperience => '修改经历';

  @override
  String get storyThinking => '正在读你的经历……';

  @override
  String get storyStopped => '已停止';

  @override
  String get storyGenerate => '改写成故事';

  @override
  String get storyRegenerate => '重新生成';

  @override
  String get storyNewStory => '写新的一篇';

  @override
  String get storyStop => '停止';

  @override
  String get routeNotFound => '页面不存在';
}
