/// 认证输入的领域规则。
///
/// 放 domain 而不是各写一份：登录 / 注册页要用它决定「按钮能不能点」，
/// 表单校验器也要用它出错误文案。两处若各写一套正则，迟早出现
/// 「按钮能点但校验不过」这种自相矛盾的状态。
abstract final class AuthRules {
  // ───────────────────────── 邮箱 ─────────────────────────

  /// 邮箱格式。**刻意宽松**：邮箱的权威校验是"能不能收到那封信"，
  /// 客户端的正则只负责拦住明显的手滑（漏了 @、结尾少了域名后缀）。
  /// 写得越严，越可能把合法但少见的地址（带 `+` 标签、新顶级域）挡在门外。
  static final RegExp email = RegExp(
    r"^[\w.!#$%&'*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$",
  );

  /// 邮箱长度上限。RFC 5321 的实际上限是 254。
  static const int emailMaxLength = 254;

  static bool isValidEmail(String input) {
    final value = input.trim();
    return value.length <= emailMaxLength && email.hasMatch(value);
  }

  // ───────────────────────── 密码 ─────────────────────────

  /// 密码长度下限。8 位是 NIST SP 800-63B 的建议底线。
  static const int passwordMinLength = 8;

  /// 密码长度上限。设上限只为挡住异常输入，不是安全要求。
  static const int passwordMaxLength = 64;

  static final RegExp _hasLetter = RegExp(r"[A-Za-z]");
  static final RegExp _hasDigit = RegExp(r"\d");
  static final RegExp _hasSymbol = RegExp(r"[^A-Za-z0-9]");

  /// 密码是否达标：够长，且**同时含字母与数字**。
  ///
  /// 只要求这两类而不强制符号：强制符号会把人推向 `Password1!` 这种
  /// 既难记又不比 `skydive2026` 更安全的写法。真正的强度靠长度。
  static bool isValidPassword(String input) {
    if (input.length < passwordMinLength || input.length > passwordMaxLength) {
      return false;
    }
    return _hasLetter.hasMatch(input) && _hasDigit.hasMatch(input);
  }

  /// 密码强度评估，供注册页的强度条使用。
  ///
  /// 这不是安全判定（安全底线由 [isValidPassword] 兜），只是给用户一个
  /// "还能更好"的方向；所以它允许在密码尚未达标时也返回 [PasswordStrength.weak]，
  /// 而不是拒绝评估。
  static PasswordStrength passwordStrength(String input) {
    if (input.isEmpty) return PasswordStrength.empty;

    var score = 0;
    if (input.length >= passwordMinLength) score++;
    if (input.length >= 12) score++;
    if (_hasLetter.hasMatch(input) && _hasDigit.hasMatch(input)) score++;
    if (_hasSymbol.hasMatch(input)) score++;

    if (score <= 1) return PasswordStrength.weak;
    if (score <= 2) return PasswordStrength.fair;
    if (score == 3) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  // ───────────────────────── 手机号（日本） ─────────────────────────

  /// 国际区号前缀。
  static const String dialCode = "+81";

  /// 日本手机号位数（国内格式，含前导 0）。
  static const int phoneLength = 11;

  /// 日本手机号：`070` / `080` / `090` 开头 + 8 位，共 11 位。
  ///
  /// 只收手机号不收固话：验证码得靠短信送达，固话收不到。
  static final RegExp japanMobile = RegExp(r"^0[789]0\d{8}$");

  /// 把用户可能粘贴进来的各种写法收敛成 `0XXXXXXXXXX`。
  ///
  /// 现实里客人会从通讯录复制出 `+81 90-1234-5678` 或 `090 1234 5678`，
  /// 直接拿去正则匹配必然失败——那是我们没处理，不是他填错了。
  static String normalizePhone(String input) {
    var value = input.replaceAll(RegExp(r"[\s\-()]"), "");
    if (value.startsWith(dialCode)) {
      value = "0${value.substring(dialCode.length)}";
    } else if (value.startsWith("81") && value.length == phoneLength + 1) {
      value = "0${value.substring(2)}";
    }
    return value;
  }

  static bool isValidPhone(String input) =>
      japanMobile.hasMatch(normalizePhone(input));

  // ───────────────────────── 短信验证码 ─────────────────────────

  /// 验证码位数（同时用于 OTP 输入框的格子数）。
  static const int smsCodeLength = 6;

  /// 纯数字验证码。位数由 [smsCodeLength] 派生，避免两处各写一个数字。
  static final RegExp smsCode = RegExp("^\\d{$smsCodeLength}\$");

  static bool isValidSmsCode(String input) => smsCode.hasMatch(input.trim());

  // ───────────────────────── 打码展示 ─────────────────────────

  /// 手机号打码展示（`09012345678` → `090****5678`）。
  ///
  /// 折叠态要让用户**确认这是自己的号**，又不必把 11 位完整暴露在屏幕上
  /// （登录页常在现场、在同伴旁边打开）。位数不足时原样返回，不做半截打码。
  static String maskPhone(String phone) {
    final digits = normalizePhone(phone);
    if (digits.length != phoneLength) return digits;
    return "${digits.substring(0, 3)}****${digits.substring(7)}";
  }

  /// 邮箱打码展示（`takeshi@example.com` → `ta****@example.com`）。
  ///
  /// 保留前两位而不是只留一位：只留一位时同一个域名下的多个账号看起来一模一样，
  /// 用户无法确认自己用的是哪个。
  static String maskEmail(String email) {
    final value = email.trim();
    final at = value.indexOf("@");
    if (at <= 0) return value;
    final name = value.substring(0, at);
    final domain = value.substring(at);
    if (name.length <= 2) return "${name[0]}****$domain";
    return "${name.substring(0, 2)}****$domain";
  }
}

/// 密码强度档位。用于注册页的强度条，不参与安全判定。
enum PasswordStrength {
  /// 还没开始输入——强度条整条置灰，不显示任何评价。
  empty,
  weak,
  fair,
  good,
  strong;

  /// 强度条要点亮几格（共 4 格）。
  int get filledBars => switch (this) {
    PasswordStrength.empty => 0,
    PasswordStrength.weak => 1,
    PasswordStrength.fair => 2,
    PasswordStrength.good => 3,
    PasswordStrength.strong => 4,
  };
}
