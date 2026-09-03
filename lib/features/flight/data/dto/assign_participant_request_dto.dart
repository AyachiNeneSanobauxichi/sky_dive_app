import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/index.dart";

part "assign_participant_request_dto.freezed.dart";
part "assign_participant_request_dto.g.dart";

/// 把某个人分配到某条航线的请求体。
///
/// 带上 [role] 而不是让后端按人查角色：同一个人可能既是持证跳伞员又是俱乐部
/// 摄影师，占哪种名额得由排班的人当场决定。
@freezed
abstract class AssignParticipantRequestDto with _$AssignParticipantRequestDto {
  const AssignParticipantRequestDto._();

  const factory AssignParticipantRequestDto({
    required String participantId,
    required String role,

    /// 此人不在运营侧候选池里时才下发（客人自助预约即属此类）。
    /// 后端能按 id 查到用户时以后端数据为准，这里只是兜底。
    String? name,
    String? detail,
  }) = _AssignParticipantRequestDto;

  factory AssignParticipantRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AssignParticipantRequestDtoFromJson(json);

  factory AssignParticipantRequestDto.of(LoadParticipant participant) =>
      AssignParticipantRequestDto(
        participantId: participant.id,
        role: participant.role.raw,
        name: participant.name,
        detail: participant.detail,
      );
}
