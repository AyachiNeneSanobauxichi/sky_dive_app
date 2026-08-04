import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/user/data/dto/index.dart";
import "package:happy_os/features/user/data/user_remote_data_source.dart";
import "package:happy_os/features/user/domain/index.dart";

/// User 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
class UserRepository {
  const UserRepository(this._remote);

  final UserRemoteDataSource _remote;

  /// 拉取当前登录用户的档案（需鉴权头，由 AuthInterceptor 注入）。
  Future<UserProfile> fetchMyProfile() => _guard(() async {
    final json = await _remote.fetchMyProfile();
    return UserProfileDto.fromJson(json).toEntity();
  });

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
