/// 认证输入的领域规则。
///
/// 放 domain 而不是各写一份：登录页要用它决定「发送验证码 / 登录按钮能不能点」，
/// 表单校验器也要用它出错误文案。两处若各写一套正则，迟早出现「按钮能点但校验不过」
/// 这种自相矛盾的状态。
abstract final class AuthRules {
  /// 手机号位数（同时用于输入框限长）。
  static const int phoneLength = 11;

  /// 短信验证码位数（同时用于输入框限长）。
  static const int smsCodeLength = 6;

  /// 国际区号前缀。
  ///
  // TODO(auth): 暂只支持大陆号码，多区号选择器待产品确认。
  static const String dialCode = "+86";

  /// 中国大陆手机号：1 开头 + 第二位 3-9 + 共 11 位。
  static final RegExp mainlandPhone = RegExp(r"^1[3-9]\d{9}$");

  /// 纯数字验证码。位数由 [smsCodeLength] 派生，避免两处各写一个数字。
  static final RegExp smsCode = RegExp("^\\d{$smsCodeLength}\$");

  static bool isValidPhone(String input) =>
      mainlandPhone.hasMatch(input.trim());

  static bool isValidSmsCode(String input) => smsCode.hasMatch(input.trim());

  /// 手机号打码展示（`13800138000` → `138****8000`）。
  ///
  /// 折叠态要让用户**确认这是自己的号**，又不必把 11 位完整暴露在屏幕上
  /// （登录页常在公共场合打开）。位数不足时原样返回，不做半截打码。
  static String maskPhone(String phone) {
    final digits = phone.trim();
    if (digits.length != phoneLength) return digits;
    return "${digits.substring(0, 3)}****${digits.substring(7)}";
  }
}
