import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/auth/domain/index.dart";

part "user_dto.freezed.dart";
part "user_dto.g.dart";

/// 登录 / 注册响应内嵌的 `userInfo`（auth.api.md v1）。
///
/// 时间字段刻意留 String 而不让 json_serializable 直接解成 `DateTime`：后端下发的
/// 格式一旦漂移（多个毫秒、换成时间戳），解析异常会把**整个登录**打成解析失败。
/// 这里原样收下，映射时用 `tryParse` 兜底。
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String displayName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? licenseLevel,
    @Default(0) int totalJumps,
    String? createdAt,
    String? lastActiveAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toEntity() => User(
    id: id,
    displayName: displayName,
    email: email,
    phone: phone,
    avatarUrl: avatarUrl,
    licenseLevel: licenseLevel,
    totalJumps: totalJumps,
    createdAt: parseServerTime(createdAt),
    lastActiveAt: parseServerTime(lastActiveAt),
  );

  /// 宽松解析服务端时间串：解析不了就当"没有这个时间"，不抛异常。
  /// `DateTime.tryParse` 同时认 ISO-8601 与空格分隔的 `yyyy-MM-dd HH:mm:ss`。
  static DateTime? parseServerTime(String? raw) =>
      (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);
}
