import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/index.dart";

part "load_participant_dto.freezed.dart";
part "load_participant_dto.g.dart";

/// 名单上一个人的接口结构。
@freezed
abstract class LoadParticipantDto with _$LoadParticipantDto {
  const LoadParticipantDto._();

  const factory LoadParticipantDto({
    required String id,
    required String name,

    /// 角色原始值（`customer` / `photographer`）。
    required String role,
    String? detail,
  }) = _LoadParticipantDto;

  factory LoadParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$LoadParticipantDtoFromJson(json);

  LoadParticipant toEntity() => LoadParticipant(
    id: id,
    name: name,
    role: ParticipantRole.fromRaw(role),
    detail: detail,
  );
}
