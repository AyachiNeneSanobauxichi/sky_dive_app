// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 用户档案控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/user/user.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成 `ref.read(userRepositoryProvider)`，
/// 页面一行都不用改。
// TODO(user): user.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。

@ProviderFor(UserProfileController)
final userProfileControllerProvider = UserProfileControllerProvider._();

/// 用户档案控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/user/user.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成 `ref.read(userRepositoryProvider)`，
/// 页面一行都不用改。
// TODO(user): user.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
final class UserProfileControllerProvider
    extends $AsyncNotifierProvider<UserProfileController, UserProfile> {
  /// 用户档案控制器（v2）。
  ///
  /// 直接读 mock 数据源而不是经 Repository：接口契约还没定
  /// （`agent/service/user/user.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
  /// 发明契约，定稿后必然重写。等契约落地时在这里换成 `ref.read(userRepositoryProvider)`，
  /// 页面一行都不用改。
  // TODO(user): user.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
  UserProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileControllerHash();

  @$internal
  @override
  UserProfileController create() => UserProfileController();
}

String _$userProfileControllerHash() =>
    r'd5bf5913ae330bb5605ec8d11c47106692097c6c';

/// 用户档案控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/user/user.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成 `ref.read(userRepositoryProvider)`，
/// 页面一行都不用改。
// TODO(user): user.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。

abstract class _$UserProfileController extends $AsyncNotifier<UserProfile> {
  FutureOr<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
