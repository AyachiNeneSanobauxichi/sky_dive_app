import "package:freezed_annotation/freezed_annotation.dart";

part "register_request_dto.freezed.dart";
part "register_request_dto.g.dart";

/// `POST /auth/register` 请求体。
///
/// 只收四个字段：邮箱、密码、显示名，外加**可选**手机号。
/// 体重、身高、紧急联系人这些跳伞必需的信息**不在注册收集**——
/// 它们属于「下第一单之前」的资料，放进注册表单只会把转化率按在地上。
@freezed
abstract class RegisterRequestDto with _$RegisterRequestDto {
  const factory RegisterRequestDto({
    required String email,
    required String password,
    required String displayName,
    String? phone,
  }) = _RegisterRequestDto;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);
}
