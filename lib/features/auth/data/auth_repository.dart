import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/auth/data/auth_remote_data_source.dart";
import "package:happy_os/features/auth/data/dto/index.dart";
import "package:happy_os/features/auth/data/mock/auth_mock_api.dart";
import "package:happy_os/features/auth/domain/index.dart";

/// Auth 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
///
/// mock 开关放在这一层而不是 DataSource：DataSource 的职责是「怎么发这个请求」，
/// 「这次到底走不走网络」是仓库的取数策略。真实接口就位后只删这一层的分支。
class AuthRepository {
  const AuthRepository(this._remote, {this.useMock = true});

  final AuthRemoteDataSource _remote;

  /// 是否走 mock 后端。
  ///
  // TODO(auth): auth.api.md 契约定稿、真实接口可用后改成 false 并删掉 data/mock/。
  final bool useMock;

  /// 发送登录短信验证码。返回**后端要求的重发冷却时长**，倒计时据此起算。
  Future<Duration> sendSmsCode(String phone) => _guard(() async {
    final json = useMock
        ? await AuthMockApi.sendSmsCode(phone)
        : await _remote.sendSmsCode(SendSmsCodeRequestDto(phone: phone));
    final dto = SendSmsCodeResponseDto.fromJson(json);
    return Duration(seconds: dto.resendAfterSeconds);
  });

  /// 手机号 + 验证码登录。返回用户 + 令牌；未注册的手机号由后端直接建号。
  Future<AuthSession> login({required String phone, required String code}) =>
      _guard(() async {
        final json = useMock
            ? await AuthMockApi.login(phone: phone, code: code)
            : await _remote.login(LoginRequestDto(phone: phone, code: code));
        return LoginResponseDto.fromJson(json).toEntity();
      });

  /// 用 refreshToken 换取新的 accessToken。
  Future<String> refreshToken(String refreshToken) => _guard(() async {
    final json = useMock
        ? await AuthMockApi.refreshToken(refreshToken)
        : await _remote.refreshToken(
            RefreshTokenRequestDto(refreshToken: refreshToken),
          );
    return RefreshTokenResponseDto.fromJson(json).accessToken;
  });

  /// 登出。
  Future<void> logout() =>
      _guard(useMock ? AuthMockApi.logout : _remote.logout);

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
