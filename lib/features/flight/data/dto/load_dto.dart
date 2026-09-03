import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/data/dto/drop_zone_dto.dart";
import "package:sky_dive/features/flight/data/dto/load_participant_dto.dart";
import "package:sky_dive/features/flight/domain/index.dart";

part "load_dto.freezed.dart";
part "load_dto.g.dart";

/// 一条航线的接口结构。
@freezed
abstract class LoadDto with _$LoadDto {
  const LoadDto._();

  const factory LoadDto({
    required String id,
    required String code,
    required DropZoneDto dropZone,

    /// ISO-8601 起飞时刻。
    required String departureAt,
    required String aircraft,
    required int altitudeFt,
    required int customerCapacity,
    required int photographerCapacity,
    @Default(<LoadParticipantDto>[]) List<LoadParticipantDto> participants,
  }) = _LoadDto;

  factory LoadDto.fromJson(Map<String, dynamic> json) =>
      _$LoadDtoFromJson(json);

  /// 映射为领域实体。
  ///
  /// 起飞时刻解析不了就**整条报错**（抛 [ParseException]），不像天气那样降级
  /// 显示——航线的全部意义就是"几点起飞"，一条没有时刻的航线既排不了序也
  /// 上不了名单，兜底成 `DateTime.now()` 只会让运营方按着一个假时间安排客人。
  Load toEntity() {
    final departure = DateTime.tryParse(departureAt);
    if (departure == null) throw const ParseException();

    return Load(
      id: id,
      code: code,
      dropZone: dropZone.toEntity(),
      departureAt: departure,
      aircraft: aircraft,
      altitudeFt: altitudeFt,
      customerCapacity: customerCapacity,
      photographerCapacity: photographerCapacity,
      participants: participants
          .map((p) => p.toEntity())
          .toList(growable: false),
    );
  }
}
