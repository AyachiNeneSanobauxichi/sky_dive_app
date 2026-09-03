import "package:sky_dive/core/network/index.dart";
import "package:sky_dive/features/flight/data/flight_data_source.dart";

/// 航线远程数据源。
///
/// ⚠️ 后端尚未就绪，当前 `flightDataSourceProvider` 装配的是
/// `FlightMockDataSource`；这里先按 REST 惯例把端点定下来。
// TODO(flight): 端点与字段待 `agent/service/flight/flight.api.md` 定稿后校对，
//   届时把 controllers 里的 provider 换成本类并删除 `data/mock/`。
class FlightRemoteDataSource implements FlightDataSource {
  const FlightRemoteDataSource(this._client);

  final DioClient _client;

  static const String _loads = "/loads";
  static const String _dropZones = "/drop-zones";
  static const String _roster = "/loads/roster";

  @override
  Future<List<Map<String, dynamic>>> fetchLoads() async {
    final res = await _client.get<List<dynamic>>(_loads);
    return res.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchDropZones() async {
    final res = await _client.get<List<dynamic>>(_dropZones);
    return res.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRoster() async {
    final res = await _client.get<List<dynamic>>(_roster);
    return res.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> createLoad(Map<String, dynamic> body) =>
      _client.post<Map<String, dynamic>>(_loads, data: body);

  @override
  Future<Map<String, dynamic>> updateLoad(
    String loadId,
    Map<String, dynamic> body,
  ) => _client.put<Map<String, dynamic>>("$_loads/$loadId", data: body);

  @override
  Future<void> deleteLoad(String loadId) =>
      _client.delete<void>("$_loads/$loadId");

  @override
  Future<Map<String, dynamic>> assignParticipant(
    String loadId,
    Map<String, dynamic> body,
  ) => _client.post<Map<String, dynamic>>(
    "$_loads/$loadId/participants",
    data: body,
  );

  @override
  Future<Map<String, dynamic>> removeParticipant(
    String loadId,
    String participantId,
  ) => _client.delete<Map<String, dynamic>>(
    "$_loads/$loadId/participants/$participantId",
  );

  @override
  Future<Map<String, dynamic>> reorderParticipants(
    String loadId,
    Map<String, dynamic> body,
  ) => _client.put<Map<String, dynamic>>(
    "$_loads/$loadId/participants/order",
    data: body,
  );
}
