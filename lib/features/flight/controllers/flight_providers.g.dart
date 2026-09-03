// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 航线数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `FlightRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
/// 这是整条航线链路上**唯一**需要改的一行。

@ProviderFor(flightDataSource)
final flightDataSourceProvider = FlightDataSourceProvider._();

/// 航线数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `FlightRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
/// 这是整条航线链路上**唯一**需要改的一行。

final class FlightDataSourceProvider
    extends
        $FunctionalProvider<
          FlightDataSource,
          FlightDataSource,
          FlightDataSource
        >
    with $Provider<FlightDataSource> {
  /// 航线数据源 DI。
  ///
  /// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
  /// `FlightRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
  /// 这是整条航线链路上**唯一**需要改的一行。
  FlightDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flightDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flightDataSourceHash();

  @$internal
  @override
  $ProviderElement<FlightDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FlightDataSource create(Ref ref) {
    return flightDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlightDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlightDataSource>(value),
    );
  }
}

String _$flightDataSourceHash() => r'4c67cee1f9b88f3f79946b8092820045c3fddf6a';

/// 航线仓库 DI。

@ProviderFor(flightRepository)
final flightRepositoryProvider = FlightRepositoryProvider._();

/// 航线仓库 DI。

final class FlightRepositoryProvider
    extends
        $FunctionalProvider<
          FlightRepository,
          FlightRepository,
          FlightRepository
        >
    with $Provider<FlightRepository> {
  /// 航线仓库 DI。
  FlightRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flightRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flightRepositoryHash();

  @$internal
  @override
  $ProviderElement<FlightRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FlightRepository create(Ref ref) {
    return flightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlightRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlightRepository>(value),
    );
  }
}

String _$flightRepositoryHash() => r'd2cd60701321644a80d2e77673946b0ec7c32afb';

/// 可选跳伞地点。
///
/// keepAlive：场地清单几乎不变，而每次打开"新建航线"表单都要用它。
/// autoDispose 会让每次开表单都重新请求一次，地点下拉框先空白一下再填上。

@ProviderFor(dropZones)
final dropZonesProvider = DropZonesProvider._();

/// 可选跳伞地点。
///
/// keepAlive：场地清单几乎不变，而每次打开"新建航线"表单都要用它。
/// autoDispose 会让每次开表单都重新请求一次，地点下拉框先空白一下再填上。

final class DropZonesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DropZone>>,
          List<DropZone>,
          FutureOr<List<DropZone>>
        >
    with $FutureModifier<List<DropZone>>, $FutureProvider<List<DropZone>> {
  /// 可选跳伞地点。
  ///
  /// keepAlive：场地清单几乎不变，而每次打开"新建航线"表单都要用它。
  /// autoDispose 会让每次开表单都重新请求一次，地点下拉框先空白一下再填上。
  DropZonesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dropZonesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dropZonesHash();

  @$internal
  @override
  $FutureProviderElement<List<DropZone>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DropZone>> create(Ref ref) {
    return dropZones(ref);
  }
}

String _$dropZonesHash() => r'f6994756c19afb8101a61263c18edeff4df8aff3';

/// 可被分配到航线的人（顾客 + 摄影师候选池）。

@ProviderFor(loadRoster)
final loadRosterProvider = LoadRosterProvider._();

/// 可被分配到航线的人（顾客 + 摄影师候选池）。

final class LoadRosterProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoadParticipant>>,
          List<LoadParticipant>,
          FutureOr<List<LoadParticipant>>
        >
    with
        $FutureModifier<List<LoadParticipant>>,
        $FutureProvider<List<LoadParticipant>> {
  /// 可被分配到航线的人（顾客 + 摄影师候选池）。
  LoadRosterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadRosterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadRosterHash();

  @$internal
  @override
  $FutureProviderElement<List<LoadParticipant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoadParticipant>> create(Ref ref) {
    return loadRoster(ref);
  }
}

String _$loadRosterHash() => r'2b69c5c041fc543dedb933d2064b93e3dd17d70d';
