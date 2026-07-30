import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "register_response_dto.freezed.dart";
part "register_response_dto.g.dart";

/// `POST /auth/register` 响应体（信封解包后的 data）。
///
/// 注意：后端此处用 `userName`（大写 N），与登录响应里的 `username` 不一致。
/// 这里保留后端原字段名 [userName]，在 [toEntity] 统一映射到领域字段 `username`
/// （避免在 freezed 构造参数上用 `@JsonKey` 触发 invalid_annotation_target）。
@freezed
abstract class RegisterResponseDto with _$RegisterResponseDto {
  const RegisterResponseDto._();

  const factory RegisterResponseDto({
    required String email,
    required String userName,
  }) = _RegisterResponseDto;

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  User toEntity() => User(username: userName, email: email);
}
