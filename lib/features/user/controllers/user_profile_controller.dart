import "package:happy_os/features/user/data/index.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_profile_controller.g.dart";

/// 用户档案控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/user/user.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成 `ref.read(userRepositoryProvider)`，
/// 页面一行都不用改。
// TODO(user): user.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserProfile> build() => UserProfileMockApi.fetch();

  /// 重新拉取（错误态重试 / 下拉刷新共用）。
  ///
  /// 下拉刷新时**不**把 state 置回 loading：已有内容要留在原地，
  /// 否则一刷新整页变骨架，用户会以为数据丢了。刷新指示器自己表达进行中。
  Future<void> reload({bool showSkeleton = false}) async {
    if (showSkeleton) state = const AsyncLoading<UserProfile>();
    state = await AsyncValue.guard(UserProfileMockApi.fetch);
  }
}
