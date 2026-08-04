import "package:happy_os/core/error/index.dart";

/// 后端业务错误码（`Failure.business` 携带的 `code`）。
///
/// 页面需要区分"用户填错了"和"系统出问题了"：前者要清空输入让他重填，
/// 后者必须**保留**已填内容——网络抖一下就把 6 位验证码清掉，等于让用户白填一次。
/// 这个判断只能靠业务码，不能靠文案匹配。
///
/// ⚠️ 下面的码值是 mock 时代的假设值，`auth.api.md` v1 只给了成功响应、**没有错误码表**。
/// 也就是说真实后端拒掉验证码时 [isSmsCodeRejected] 目前会返回 false——后果是登录页
/// 不会自动清空 6 位格子（用户得手动删），但不会误清，属于可接受的降级。
///
// TODO(auth): auth.api.md 补上错误码表后校对码值，否则"验证码填错自动清空"一直不生效。
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
