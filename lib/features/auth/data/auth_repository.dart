import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/auth/data/auth_data_source.dart";
import "package:sky_dive/features/auth/data/dto/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";

/// Auth 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
///
/// 依赖的是 [AuthDataSource] 抽象而不是具体实现，因此后端未就绪期间由 mock 顶上，
/// 上线时换 provider 即可，本类一行不用改。
class AuthRepository {
  const AuthRepository(this._source);

  final AuthDataSource _source;

  /// 发送登录短信验证码。返回验证码有效期等回执（**不含重发冷却**，v1 接口不下发，
  /// 节流由 `SmsCodeController` 本地承担）。
  ///
  /// 手机号在这一层就归一化：用户可能粘贴 `+81 90-1234-5678`，
  /// 若把原样字符串发出去，服务端按号码限频时会把它和 `09012345678` 当成两个号。
  Future<SmsCodeChallenge> sendSmsCode(String phone) => _guard(() async {
    final json = await _source.sendSmsCode(
      SendSmsCodeRequestDto(phone: AuthRules.normalizePhone(phone)),
    );
    return SendSmsCodeResponseDto.fromJson(json).toEntity();
  });

  /// 邮箱 + 密码登录。
  ///
  /// 邮箱统一 `trim`：手机键盘在词尾自动补的那个空格是最常见的"登录失败"来源，
  /// 而用户完全看不见它。密码**不 trim**——空格是密码的合法组成部分。
  Future<AuthSession> loginWithEmail({
    required String email,
    required String password,
  }) => _guard(() async {
    final json = await _source.loginWithEmail(
      EmailLoginRequestDto(email: email.trim(), password: password),
    );
    return LoginResponseDto.fromJson(json).toEntity();
  });

  /// 手机号 + 验证码登录。未注册的手机号由后端直接建号。
  Future<AuthSession> loginWithSms({
    required String phone,
    required String code,
  }) => _guard(() async {
    final json = await _source.loginWithSms(
      SmsLoginRequestDto(
        phone: AuthRules.normalizePhone(phone),
        smsCode: code.trim(),
      ),
    );
    return LoginResponseDto.fromJson(json).toEntity();
  });

  /// 邮箱注册。成功即返回可用会话——注册完还要用户再登录一次是纯粹的多余步骤。
  Future<AuthSession> register({
    required String email,
    required String password,
    required String displayName,
    String? phone,
  }) => _guard(() async {
    final json = await _source.register(
      RegisterRequestDto(
        email: email.trim(),
        password: password,
        displayName: displayName.trim(),
        phone: (phone == null || phone.trim().isEmpty)
            ? null
            : AuthRules.normalizePhone(phone),
      ),
    );
    return LoginResponseDto.fromJson(json).toEntity();
  });

  /// 用 refreshToken 换取新的 accessToken。
  Future<String> refreshToken(String refreshToken) => _guard(() async {
    final json = await _source.refreshToken(
      RefreshTokenRequestDto(refreshToken: refreshToken),
    );
    return RefreshTokenResponseDto.fromJson(json).accessToken;
  });

  /// 登出：请求服务端吊销当前会话。
  ///
  /// 失败**不阻塞**本地登出——由 `AuthController.logout` 兜底清理（见那里的注释）。
  Future<void> logout() => _guard(_source.logout);

  /// 统一异常收敛：底层抛的 [AppException] 转成 [Failure] 再抛出，
  /// 页面据此渲染文案（解析异常等非 AppException 原样上抛）。
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}
