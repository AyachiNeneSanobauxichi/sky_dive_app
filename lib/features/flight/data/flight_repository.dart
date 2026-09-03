import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/data/dto/index.dart";
import "package:sky_dive/features/flight/data/flight_data_source.dart";
import "package:sky_dive/features/flight/domain/index.dart";

/// 航线仓库：DTO ↔ Entity 映射 + 异常收敛。
///
/// 每个方法都把 [AppException] 收敛成 [Failure] 再抛出，这样控制器一律
/// `AsyncValue.guard` / `try-catch Failure`，页面拿到的永远是可展示的失败，
/// 不会有 `DioException` 漏到 UI 层。
class FlightRepository {
  const FlightRepository(this._source);

  final FlightDataSource _source;

  Future<List<Load>> fetchLoads() => _guard(() async {
    final json = await _source.fetchLoads();
    return json
        .map((e) => LoadDto.fromJson(e).toEntity())
        .toList(growable: false);
  });

  Future<List<DropZone>> fetchDropZones() => _guard(() async {
    final json = await _source.fetchDropZones();
    return json
        .map((e) => DropZoneDto.fromJson(e).toEntity())
        .toList(growable: false);
  });

  Future<List<LoadParticipant>> fetchRoster() => _guard(() async {
    final json = await _source.fetchRoster();
    return json
        .map((e) => LoadParticipantDto.fromJson(e).toEntity())
        .toList(growable: false);
  });

  Future<Load> createLoad(LoadDraft draft) => _guard(() async {
    final body = LoadRequestDto.fromDraft(draft).toJson();
    return LoadDto.fromJson(await _source.createLoad(body)).toEntity();
  });

  Future<Load> updateLoad(LoadDraft draft) => _guard(() async {
    final body = LoadRequestDto.fromDraft(draft).toJson();
    final json = await _source.updateLoad(draft.id!, body);
    return LoadDto.fromJson(json).toEntity();
  });

  Future<void> deleteLoad(String loadId) =>
      _guard(() => _source.deleteLoad(loadId));

  Future<Load> assignParticipant({
    required String loadId,
    required LoadParticipant participant,
  }) => _guard(() async {
    final body = AssignParticipantRequestDto.of(participant).toJson();
    final json = await _source.assignParticipant(loadId, body);
    return LoadDto.fromJson(json).toEntity();
  });

  Future<Load> removeParticipant({
    required String loadId,
    required String participantId,
  }) => _guard(() async {
    final json = await _source.removeParticipant(loadId, participantId);
    return LoadDto.fromJson(json).toEntity();
  });

  /// 重排某个角色的名单顺序。
  Future<Load> reorderParticipants({
    required String loadId,
    required ParticipantRole role,
    required List<String> participantIds,
  }) => _guard(() async {
    final body = ReorderParticipantsRequestDto(
      participantIds: participantIds,
      role: role.raw,
    ).toJson();
    final json = await _source.reorderParticipants(loadId, body);
    return LoadDto.fromJson(json).toEntity();
  });

  /// 统一的异常收敛。八个方法各写一遍 try/catch 只会漏掉其中一个，
  /// 而漏掉的那个恰好就是把 `DioException` 泄到 UI 的那条路径。
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}
