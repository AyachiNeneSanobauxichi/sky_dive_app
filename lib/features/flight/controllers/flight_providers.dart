import "package:sky_dive/features/flight/data/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "flight_providers.g.dart";

/// 航线数据源 DI。
///
/// ⚠️ 当前装配的是 **mock**（后端未就绪）。接真后端时换成
/// `FlightRemoteDataSource(ref.watch(dioClientProvider))`，并删除 `data/mock/`。
/// 这是整条航线链路上**唯一**需要改的一行。
@Riverpod(keepAlive: true)
FlightDataSource flightDataSource(Ref ref) => FlightMockDataSource();

/// 航线仓库 DI。
@Riverpod(keepAlive: true)
FlightRepository flightRepository(Ref ref) =>
    FlightRepository(ref.watch(flightDataSourceProvider));

/// 可选跳伞地点。
///
/// keepAlive：场地清单几乎不变，而每次打开"新建航线"表单都要用它。
/// autoDispose 会让每次开表单都重新请求一次，地点下拉框先空白一下再填上。
@Riverpod(keepAlive: true)
Future<List<DropZone>> dropZones(Ref ref) =>
    ref.watch(flightRepositoryProvider).fetchDropZones();

/// 可被分配到航线的人（顾客 + 摄影师候选池）。
@Riverpod(keepAlive: true)
Future<List<LoadParticipant>> loadRoster(Ref ref) =>
    ref.watch(flightRepositoryProvider).fetchRoster();
