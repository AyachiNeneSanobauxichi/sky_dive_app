// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 安全存储单例：refreshToken / 用户快照等持久化数据的读写入口。

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

/// 安全存储单例：refreshToken / 用户快照等持久化数据的读写入口。

final class SecureStorageProvider
    extends $FunctionalProvider<SecureStorage, SecureStorage, SecureStorage>
    with $Provider<SecureStorage> {
  /// 安全存储单例：refreshToken / 用户快照等持久化数据的读写入口。
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'bdb93d61ae823ea072ad30026274e0d98d8cef4a';

/// 内存态 accessToken 持有者（v2：accessToken 不落盘，仅存内存）。

@ProviderFor(accessTokenStore)
final accessTokenStoreProvider = AccessTokenStoreProvider._();

/// 内存态 accessToken 持有者（v2：accessToken 不落盘，仅存内存）。

final class AccessTokenStoreProvider
    extends
        $FunctionalProvider<
          AccessTokenStore,
          AccessTokenStore,
          AccessTokenStore
        >
    with $Provider<AccessTokenStore> {
  /// 内存态 accessToken 持有者（v2：accessToken 不落盘，仅存内存）。
  AccessTokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenStoreHash();

  @$internal
  @override
  $ProviderElement<AccessTokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccessTokenStore create(Ref ref) {
    return accessTokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessTokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessTokenStore>(value),
    );
  }
}

String _$accessTokenStoreHash() => r'4f4b41e3c30cf4ebfa18da2d9a32a664acd45ae8';

/// 鉴权事件通道：拦截器广播「会话失效」，业务层订阅后翻转登录态（core 不反依赖 feature）。

@ProviderFor(authEvents)
final authEventsProvider = AuthEventsProvider._();

/// 鉴权事件通道：拦截器广播「会话失效」，业务层订阅后翻转登录态（core 不反依赖 feature）。

final class AuthEventsProvider
    extends $FunctionalProvider<AuthEvents, AuthEvents, AuthEvents>
    with $Provider<AuthEvents> {
  /// 鉴权事件通道：拦截器广播「会话失效」，业务层订阅后翻转登录态（core 不反依赖 feature）。
  AuthEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authEventsHash();

  @$internal
  @override
  $ProviderElement<AuthEvents> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthEvents create(Ref ref) {
    return authEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthEvents>(value),
    );
  }
}

String _$authEventsHash() => r'69826f28c010bef837672f24901439e4dc4eca9e';

/// 全局唯一 Dio 实例。
///
/// 集中配置 baseUrl / 超时 / 公共头，并按顺序挂载拦截器：
/// 鉴权(注入 token) → 解包(信封) → 错误映射 → 日志(仅 debug)。
/// 顺序要点：ErrorInterceptor 必须在 ResponseInterceptor 之后，
/// 才能接住后者 reject 出的业务错误。provider 销毁时关闭连接。

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// 全局唯一 Dio 实例。
///
/// 集中配置 baseUrl / 超时 / 公共头，并按顺序挂载拦截器：
/// 鉴权(注入 token) → 解包(信封) → 错误映射 → 日志(仅 debug)。
/// 顺序要点：ErrorInterceptor 必须在 ResponseInterceptor 之后，
/// 才能接住后者 reject 出的业务错误。provider 销毁时关闭连接。

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// 全局唯一 Dio 实例。
  ///
  /// 集中配置 baseUrl / 超时 / 公共头，并按顺序挂载拦截器：
  /// 鉴权(注入 token) → 解包(信封) → 错误映射 → 日志(仅 debug)。
  /// 顺序要点：ErrorInterceptor 必须在 ResponseInterceptor 之后，
  /// 才能接住后者 reject 出的业务错误。provider 销毁时关闭连接。
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'96d69ede0fad1d1252a6324ee5970d20cf974cb3';

/// 网络访问门面：业务层只依赖 `DioClient`，不直接接触 `Dio`。

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// 网络访问门面：业务层只依赖 `DioClient`，不直接接触 `Dio`。

final class DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  /// 网络访问门面：业务层只依赖 `DioClient`，不直接接触 `Dio`。
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$dioClientHash() => r'59364afefb19d370a6a50d4a6c191be4061ff9a6';
