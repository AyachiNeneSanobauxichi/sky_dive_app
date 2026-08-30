import "package:sky_dive/core/error/index.dart";

/// 后端业务错误码（`Failure.business` 携带的 `code`）。
///
/// 页面需要区分"用户填错了"和"系统出问题了"：前者要清空对应输入让他重填，
/// 后者必须**保留**已填内容——网络抖一下就把 6 位验证码清掉，等于让用户白填一次。
/// 这个判断只能靠业务码，不能靠文案匹配（文案会随 locale 变）。
///
/// ⚠️ 当前码值来自 `data/mock/` 的假后端，与 `auth.api.md` v1 的约定一致；
/// 真实后端接入后要按后端的错误码表校对这一张表，其余代码不用改。
abstract final class AuthErrorCode {
  /// 邮箱或密码不正确。
  ///
  /// 刻意**不区分**"邮箱不存在"和"密码错误"：区分开等于给撞库的人一个
  /// 免费的账号存在性探测接口。UI 上两者也用同一句文案。
  static const int credentialsInvalid = 10001;

  /// 验证码不正确。
  static const int smsCodeIncorrect = 10002;

  /// 验证码已过期，需要重新发送。
  static const int smsCodeExpired = 10003;

  /// 该邮箱已被注册。
  static const int emailAlreadyRegistered = 10010;

  /// 该手机号已绑定其它账号。
  static const int phoneAlreadyRegistered = 10011;

  /// 账号被停用（例如违规或欠费）。
  static const int accountDisabled = 10020;

  /// 这次失败是否"验证码本身被拒"——是则清空 OTP 格子并聚焦回第一格。
  static bool isSmsCodeRejected(Object error) => switch (error) {
    BusinessFailure(:final code) =>
      code == smsCodeIncorrect || code == smsCodeExpired,
    _ => false,
  };

  /// 这次失败是否"密码被拒"——是则清空密码框（保留邮箱）并聚焦回去。
  static bool isPasswordRejected(Object error) => switch (error) {
    BusinessFailure(:final code) => code == credentialsInvalid,
    _ => false,
  };

  /// 这次失败是否"该标识已被占用"——是则把错误就地显示在对应字段下方，
  /// 而不是弹一条转瞬即逝的 toast。
  static bool isIdentifierTaken(Object error) => switch (error) {
    BusinessFailure(:final code) =>
      code == emailAlreadyRegistered || code == phoneAlreadyRegistered,
    _ => false,
  };
}
