import "package:freezed_annotation/freezed_annotation.dart";

part "reorder_participants_request_dto.freezed.dart";
part "reorder_participants_request_dto.g.dart";

/// 重排某个角色的名单顺序的请求体。
///
/// 下发的是**该角色的完整顺序**而不是"把第 3 个挪到第 1 个"这样的增量指令：
/// 增量指令一旦和服务端的当前顺序对不上（别人刚加了个人），结果就是错的，
/// 而且错得很难查。整份顺序是幂等的。
@freezed
abstract class ReorderParticipantsRequestDto
    with _$ReorderParticipantsRequestDto {
  const ReorderParticipantsRequestDto._();

  const factory ReorderParticipantsRequestDto({
    required List<String> participantIds,

    /// 这次重排的是哪个角色（`customer` / `photographer`）。
    required String role,
  }) = _ReorderParticipantsRequestDto;

  factory ReorderParticipantsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReorderParticipantsRequestDtoFromJson(json);
}
