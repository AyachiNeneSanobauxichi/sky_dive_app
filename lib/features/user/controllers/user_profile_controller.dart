import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/user/data/index.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_profile_controller.g.dart";

/// User 仓库 DI：组装 DataSource（依赖全局 DioClient）。
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) =>
    UserRepository(UserRemoteDataSource(ref.watch(dioClientProvider)));

/// 用户档案控制器（v2）。
///
/// 取数走真实接口 `GET /user-profile/me`（`user.api.md` v2），鉴权头由
/// `AuthInterceptor` 注入——所以本控制器只在已登录态下才会被页面挂载。
@riverpod
class UserProfileController extends _$UserProfileController {
  UserRepository get _repo => ref.read(userRepositoryProvider);

  @override
  Future<UserProfile> build() => _repo.fetchMyProfile();

  /// 重新拉取（错误态重试 / 下拉刷新共用）。
  ///
  /// 下拉刷新时**不**把 state 置回 loading：已有内容要留在原地，
  /// 否则一刷新整页变骨架，用户会以为数据丢了。刷新指示器自己表达进行中。
  Future<void> reload({bool showSkeleton = false}) async {
    if (showSkeleton) state = const AsyncLoading<UserProfile>();
    state = await AsyncValue.guard(_repo.fetchMyProfile);
  }
}
