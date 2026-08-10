// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User 仓库 DI：组装 DataSource（依赖全局 DioClient）。

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

/// User 仓库 DI：组装 DataSource（依赖全局 DioClient）。

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  /// User 仓库 DI：组装 DataSource（依赖全局 DioClient）。
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'59d3e61569cb500ecba24c2e661855463d91c446';

/// 用户档案控制器（v2）。
///
/// 取数走真实接口 `GET /user-profile/me`（`user.api.md` v2），鉴权头由
/// `AuthInterceptor` 注入——所以本控制器只在已登录态下才会被页面挂载。

@ProviderFor(UserProfileController)
final userProfileControllerProvider = UserProfileControllerProvider._();

/// 用户档案控制器（v2）。
///
/// 取数走真实接口 `GET /user-profile/me`（`user.api.md` v2），鉴权头由
/// `AuthInterceptor` 注入——所以本控制器只在已登录态下才会被页面挂载。
final class UserProfileControllerProvider
    extends $AsyncNotifierProvider<UserProfileController, UserProfile> {
  /// 用户档案控制器（v2）。
  ///
  /// 取数走真实接口 `GET /user-profile/me`（`user.api.md` v2），鉴权头由
  /// `AuthInterceptor` 注入——所以本控制器只在已登录态下才会被页面挂载。
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
    r'68cbc96df16ee0e3e93f7cd96c83c0805ded61be';

/// 用户档案控制器（v2）。
///
/// 取数走真实接口 `GET /user-profile/me`（`user.api.md` v2），鉴权头由
/// `AuthInterceptor` 注入——所以本控制器只在已登录态下才会被页面挂载。

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
