import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/index.dart";

part "drop_zone_dto.freezed.dart";
part "drop_zone_dto.g.dart";

/// 跳伞地点的接口结构。
@freezed
abstract class DropZoneDto with _$DropZoneDto {
  const DropZoneDto._();

  const factory DropZoneDto({
    required String id,
    required String name,
    String? area,
  }) = _DropZoneDto;

  factory DropZoneDto.fromJson(Map<String, dynamic> json) =>
      _$DropZoneDtoFromJson(json);

  DropZone toEntity() => DropZone(id: id, name: name, area: area);
}
