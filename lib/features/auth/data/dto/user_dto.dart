import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "user_dto.freezed.dart";
part "user_dto.g.dart";

/// 登录响应内嵌的用户 DTO（字段 `username` / `email`）。
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({required String username, required String email}) =
      _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toEntity() => User(username: username, email: email);
}
