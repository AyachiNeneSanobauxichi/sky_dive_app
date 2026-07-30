import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/auth/data/auth_remote_data_source.dart";
import "package:happy_os/features/auth/data/dto/index.dart";
import "package:happy_os/features/auth/domain/index.dart";

/// Auth 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
class AuthRepository {
  const AuthRepository(this._remote);

  final AuthRemoteDataSource _remote;

  /// 注册。成功返回新建用户；后端不下发令牌，需再走登录。
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) => _guard(() async {
    final json = await _remote.register(
      RegisterRequestDto(username: username, email: email, password: password),
    );
    return RegisterResponseDto.fromJson(json).toEntity();
  });

  /// 登录。返回用户 + 令牌。
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) => _guard(() async {
    final json = await _remote.login(
      LoginRequestDto(identifier: identifier, password: password),
    );
    return LoginResponseDto.fromJson(json).toEntity();
  });

  /// 用 refreshToken 换取新的 accessToken。
  Future<String> refreshToken(String refreshToken) => _guard(() async {
    final json = await _remote.refreshToken(
      RefreshTokenRequestDto(refreshToken: refreshToken),
    );
    return RefreshTokenResponseDto.fromJson(json).accessToken;
  });

  /// 登出。
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
