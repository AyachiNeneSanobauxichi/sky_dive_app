import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/auth/domain/index.dart";

/// 假的认证后端。
///
/// `agent/service/auth/auth.api.md` 目前是空的（接口契约未定），用它把
/// 「输入 → 发码 → 倒计时 → 登录 → 登录态落地 → 路由跳转」整条链路先跑通。
///
/// 刻意保留两种**不友好行为**，否则本地永远一次成功、接上真接口才发现没做错误态：
/// 1. **网络延迟**：发码和登录都不是瞬时返回，用来验证按钮忙碌态与防重复提交；
/// 2. **验证码错误分支**：[_rejectedCode] 走业务错误，用来验证错误提示与重试路径。
///
// TODO(auth): 真实接口上线后**删除整个 data/mock/ 目录**，
//   并把 AuthRepository 的 useMock 默认值改为 false。
abstract final class AuthMockApi {
  /// 发码延迟：短信网关通常有几百毫秒。
  static const Duration _sendCodeLatency = Duration(milliseconds: 900);

  /// 登录延迟：验证码校验 + 建号 + 签发令牌。
  static const Duration _loginLatency = Duration(milliseconds: 1200);

  /// 后端下发的重发冷却秒数。
  static const int _resendAfterSeconds = 60;

  /// 专门用来触发「验证码错误」分支的输入。其余 6 位数字均视为正确。
  static const String _rejectedCode = "000000";

  static Future<Map<String, dynamic>> sendSmsCode(String phone) async {
    await Future<void>.delayed(_sendCodeLatency);
    return const {"resendAfterSeconds": _resendAfterSeconds};
  }

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(_loginLatency);
    if (code == _rejectedCode) {
      // 模拟后端业务错误（HTTP 200 + code != 0）。文案模拟服务端返回，故不走 i18n。
      throw const BusinessException(
        code: AuthErrorCode.smsCodeIncorrect,
        message: "验证码不正确，请重新输入",
      );
    }
    if (!AuthRules.isValidSmsCode(code)) {
      throw const BusinessException(
        code: AuthErrorCode.smsCodeMalformed,
        message: "验证码格式不正确",
      );
    }
    return {
      "accessToken": "mock-access-token-$phone",
      "refreshToken": "mock-refresh-token-$phone",
      // 新手机号直接建号，昵称留空由 UI 兜底。
      "user": {"phone": phone, "nickname": null},
    };
  }

  /// 静默刷新：让 mock 会话能跨冷启动存活，否则每次重启都要重新登录，
  /// 「启动静默刷新 → 恢复登录态」这条路径也就无从验证。
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    return {"accessToken": refreshToken.replaceFirst("refresh", "access")};
  }

  static Future<void> logout() async {}
}
