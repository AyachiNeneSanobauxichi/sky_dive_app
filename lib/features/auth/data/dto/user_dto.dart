import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "user_dto.freezed.dart";
part "user_dto.g.dart";

/// 登录响应内嵌的用户 DTO。
///
// TODO(auth): 字段按 mock 假设为 `phone` / `nickname`，auth.api.md 补齐契约后校对。
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({required String phone, String? nickname}) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toEntity() => User(phone: phone, nickname: nickname);
}
