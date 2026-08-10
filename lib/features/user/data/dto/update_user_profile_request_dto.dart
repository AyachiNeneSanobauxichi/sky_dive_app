import "dart:convert";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:intl/intl.dart";

part "update_user_profile_request_dto.freezed.dart";
part "update_user_profile_request_dto.g.dart";

/// `PUT /user-profile/update` 请求体（`user.api.md` v3 / mini-program `02-user-profile.md`）。
///
/// 三处必须贴着后端来，不能按领域实体的形状发：
/// 1. **[id] 必传**，是档案 id 而不是用户 id；
/// 2. `hobbies` / `personalityTags` 后端收的是**JSON 文本**（`'["阅读","旅行"]'`），
///    不是数组——发数组过去会被当成脏数据；
/// 3. `birthday` 是 `yyyy-MM-dd`，不能直接把 `DateTime.toString()` 甩过去
///    （那是 `2017-06-27 00:00:00.000`）。
///
/// 只发**表单管得着的字段**。契约里还有 `childhoodDate` / `peakContent` /
/// `futureVision` 等"人生节点"字段，它们不在本表单范围内，
/// 一律不出现在请求里——发 null 过去等于把用户在别处填的内容清空。
@freezed
abstract class UpdateUserProfileRequestDto with _$UpdateUserProfileRequestDto {
  const UpdateUserProfileRequestDto._();

  const factory UpdateUserProfileRequestDto({
    required String id,
    String? nickname,
    String? gender,
    String? zodiac,

    /// 职业。领域实体里叫 `occupation`。
    String? profession,
    String? mbti,

    /// JSON 文本形式的字符串数组。
    String? hobbies,
    String? idealLife,
    String? city,
    String? industry,
    String? company,

    /// JSON 文本形式的字符串数组。
    String? personalityTags,

    /// 生日（`yyyy-MM-dd`）。
    String? birthday,
  }) = _UpdateUserProfileRequestDto;

  factory UpdateUserProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserProfileRequestDtoFromJson(json);

  /// 由领域实体构造请求体。[id] 从实体上取，为空说明这份档案还没在后端建过。
  factory UpdateUserProfileRequestDto.fromEntity(UserProfile profile) {
    final id = profile.id;
    if (id == null || id.isEmpty) {
      throw StateError("档案 id 缺失，无法更新（未建档的账号应走 create）");
    }
    return UpdateUserProfileRequestDto(
      id: id,
      nickname: _trimToNull(profile.nickname),
      gender: profile.gender,
      zodiac: profile.zodiac,
      profession: profile.occupation,
      mbti: profile.mbti,
      hobbies: _encodeStringList(profile.hobbies),
      idealLife: _trimToNull(profile.idealLife),
      city: profile.city,
      industry: profile.industry,
      company: profile.company,
      personalityTags: _encodeStringList(profile.personalityTags),
      birthday: _formatDate(profile.birthday),
    );
  }

  /// 空列表也要发 `"[]"` 而不是 null：用户把标签全删光是一个**明确的意图**，
  /// 发 null 会被后端当成"这项没动"，删除就白删了。
  static String _encodeStringList(List<String> values) => jsonEncode(values);

  /// 只去空白后的空串当作"没填"。留着空串会把后端已有的值覆盖成空。
  static String? _trimToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  static String? _formatDate(DateTime? date) =>
      date == null ? null : _dateFormat.format(date);

  /// 后端要 `LocalDate`，格式固定，**不跟随 locale**。
  static final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
}
