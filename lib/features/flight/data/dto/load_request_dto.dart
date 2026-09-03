import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/index.dart";

part "load_request_dto.freezed.dart";
part "load_request_dto.g.dart";

/// 新建 / 编辑航线的请求体。
///
/// 用 DTO 而不是在仓库里手拼 `Map`：字段名写错时 `toJson` 至少还有类型兜着，
/// 手拼的 `"aircaft"` 要等联调才发现。
@freezed
abstract class LoadRequestDto with _$LoadRequestDto {
  const LoadRequestDto._();

  const factory LoadRequestDto({
    required String code,
    required String dropZoneId,

    /// ISO-8601 起飞时刻。
    required String departureAt,
    required String aircraft,
    required int altitudeFt,
    required int customerCapacity,
    required int photographerCapacity,
  }) = _LoadRequestDto;

  factory LoadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoadRequestDtoFromJson(json);

  /// 从表单草稿构造。调用前草稿必须已通过必填校验（[LoadDraft.isComplete]）。
  factory LoadRequestDto.fromDraft(LoadDraft draft) => LoadRequestDto(
    code: draft.code.trim(),
    dropZoneId: draft.dropZone!.id,
    departureAt: draft.departureAt!.toIso8601String(),
    aircraft: draft.aircraft.trim(),
    altitudeFt: draft.altitudeFt,
    customerCapacity: draft.customerCapacity,
    photographerCapacity: draft.photographerCapacity,
  );
}
