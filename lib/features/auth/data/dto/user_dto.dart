import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/index.dart";

part "user_dto.freezed.dart";
part "user_dto.g.dart";

/// 登录响应内嵌的 `userInfo`（auth.api.md v1）。
///
/// 时间字段刻意留 String 而不让 json_serializable 直接解成 `DateTime`：后端下发的是
/// `"2026-07-02 00:36:26"` 这种本地时间串，格式一旦漂移（多个毫秒、换成时间戳），
/// 解析异常会把**整个登录**打成解析失败。这里原样收下，映射时用 `tryParse` 兜底。
@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String phone,
    String? account,
    String? username,
    String? nickname,
    int? status,
    String? memberLevel,
    @Default(0) int totalDays,
    String? lastActiveTime,
    String? createTime,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  User toEntity() => User(
    id: id,
    phone: phone,
    account: account,
    username: username,
    nickname: nickname,
    status: status,
    memberLevel: memberLevel,
    totalDays: totalDays,
    lastActiveTime: parseServerTime(lastActiveTime),
    createTime: parseServerTime(createTime),
  );

  /// 宽松解析服务端时间串：解析不了就当"没有这个时间"，不抛异常。
  /// `DateTime.tryParse` 认空格分隔的 `yyyy-MM-dd HH:mm:ss`，无需自定义 formatter。
  static DateTime? parseServerTime(String? raw) =>
      (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);
}
