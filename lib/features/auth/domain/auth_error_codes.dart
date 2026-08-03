import "package:happy_os/core/error/index.dart";

/// 后端业务错误码（`Failure.business` 携带的 `code`）。
///
/// 页面需要区分"用户填错了"和"系统出问题了"：前者要清空输入让他重填，
/// 后者必须**保留**已填内容——网络抖一下就把 6 位验证码清掉，等于让用户白填一次。
/// 这个判断只能靠业务码，不能靠文案匹配。
///
// TODO(auth): 码值取自 data/mock/auth_mock_api.dart 的假设，
//   auth.api.md 的错误码表定稿后必须校对；届时把这里和 mock 一起改。
abstract final class AuthErrorCode {
  /// 验证码不正确。
  static const int smsCodeIncorrect = 10002;

  /// 验证码格式不合法（位数/字符不对）。
  static const int smsCodeMalformed = 10003;

  /// 这次失败是否"验证码本身被拒"。
  static bool isSmsCodeRejected(Object error) => switch (error) {
    BusinessFailure(:final code) =>
      code == smsCodeIncorrect || code == smsCodeMalformed,
    _ => false,
  };
}
