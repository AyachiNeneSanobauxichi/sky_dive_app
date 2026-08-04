// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth 仓库 DI：组装 DataSource（依赖全局 DioClient）。

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Auth 仓库 DI：组装 DataSource（依赖全局 DioClient）。

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Auth 仓库 DI：组装 DataSource（依赖全局 DioClient）。
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

String _$authRepositoryHash() => r'fdcc143418aeac9bba6bac8abffd08d4ed73541d';

/// 全局登录态控制器（v2）。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
/// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 全局登录态控制器（v2）。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
/// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
///
/// keepAlive 必需：autoDispose 会在无监听者时重跑 [build] 的静默刷新流程，
/// 造成登录态抖动甚至误登出。
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthState> {
  /// 全局登录态控制器（v2）。
  ///
  /// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
  /// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
  ///
  /// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
  /// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
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

String _$authControllerHash() => r'7bafb382025764dba0d354870fb43df0ed13dc4e';

/// 全局登录态控制器（v2）。
///
/// - `AsyncLoading`（仅冷启动 [build] 期间）：登录态未定，路由停在 splash。
/// - `AsyncData(AuthState)`：已定态，驱动路由守卫重定向。
///
/// 登录/登出**不**把本 provider 置 loading，以免误触发 splash——按钮 loading 由页面
/// 各自的本地标记承载；登录失败以异常上抛，页面本地捕获提示。
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
