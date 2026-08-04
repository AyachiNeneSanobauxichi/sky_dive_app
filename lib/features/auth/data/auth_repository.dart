import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/auth/data/auth_remote_data_source.dart";
import "package:happy_os/features/auth/data/dto/index.dart";
import "package:happy_os/features/auth/domain/index.dart";

/// Auth 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
///
/// v1 起全部走真实接口（`agent/service/auth/auth.api.md`），mock 后端与 `useMock`
/// 开关已随之删除。
class AuthRepository {
  const AuthRepository(this._remote);

  final AuthRemoteDataSource _remote;

  /// 发送登录短信验证码。返回验证码有效期等回执（**不含重发冷却**，v1 接口不下发，
  /// 节流由 `SmsCodeController` 本地承担）。
  Future<SmsCodeChallenge> sendSmsCode(String phone) => _guard(() async {
    final json = await _remote.sendSmsCode(SendSmsCodeRequestDto(phone: phone));
    return SendSmsCodeResponseDto.fromJson(json).toEntity();
  });

  /// 手机号 + 验证码登录。返回用户 + 令牌；未注册的手机号由后端直接建号。
  Future<AuthSession> login({required String phone, required String code}) =>
      _guard(() async {
        final json = await _remote.login(
          LoginRequestDto(phone: phone, smsCode: code),
        );
        return LoginResponseDto.fromJson(json).toEntity();
      });

  /// 用 refreshToken 换取新的 accessToken。
  ///
  // TODO(auth): 契约未在 auth.api.md v1 定义，后端确认前冷启动静默刷新可能一直失败
  //   （表现为每次冷启动都要重新登录）。
  Future<String> refreshToken(String refreshToken) => _guard(() async {
    final json = await _remote.refreshToken(
      RefreshTokenRequestDto(refreshToken: refreshToken),
    );
    return RefreshTokenResponseDto.fromJson(json).accessToken;
  });

  /// 登出（v3）：请求服务端吊销当前会话。
  ///
  /// 失败**不阻塞**本地登出——由 `AuthController.logout` 兜底清理（见那里的注释）。
  Future<void> logout() => _guard(_remote.logout);

  /// 统一异常收敛：底层抛的 [AppException] 转成 [Failure] 再抛出，controller 用
  /// `AsyncValue.guard` 即可拿到 Failure 渲染文案（解析异常等非 AppException 原样上抛）。
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}
