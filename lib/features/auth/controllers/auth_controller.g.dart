// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth 数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时把这里换成
/// `AuthRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/` 整个目录。
/// 这是整条认证链路上**唯一**需要改的一行。

@ProviderFor(authDataSource)
final authDataSourceProvider = AuthDataSourceProvider._();

/// Auth 数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时把这里换成
/// `AuthRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/` 整个目录。
/// 这是整条认证链路上**唯一**需要改的一行。

final class AuthDataSourceProvider
    extends $FunctionalProvider<AuthDataSource, AuthDataSource, AuthDataSource>
    with $Provider<AuthDataSource> {
  /// Auth 数据源 DI。
  ///
  /// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时把这里换成
  /// `AuthRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/` 整个目录。
  /// 这是整条认证链路上**唯一**需要改的一行。
  AuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthDataSource create(Ref ref) {
    return authDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthDataSource>(value),
    );
  }
}

String _$authDataSourceHash() => r'fe437017c6fcbbe21634cfc3d1e138bab8baabef';

/// Auth 仓库 DI。

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Auth 仓库 DI。

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Auth 仓库 DI。
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'954cf775d6e44e1fb761b013ae07e70d2b44bf1c';

/// 全局登录态控制器。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/注册/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由
/// 页面各自的本地标记承载；失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 全局登录态控制器。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/注册/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由
/// 页面各自的本地标记承载；失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthState> {
  /// 全局登录态控制器。
  ///
  /// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
  /// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
  ///
  /// 登录/注册/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由
  /// 页面各自的本地标记承载；失败以异常上抛，页面本地捕获提示。
  ///
  /// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
  /// 造成登录态抖动甚至误登出。
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'29d7654d106b36847ffc5671464d7790c546e238';

/// 全局登录态控制器。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/注册/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由
/// 页面各自的本地标记承载；失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。

abstract class _$AuthController extends $AsyncNotifier<AuthState> {
  FutureOr<AuthState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthState>, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthState>, AuthState>,
              AsyncValue<AuthState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
