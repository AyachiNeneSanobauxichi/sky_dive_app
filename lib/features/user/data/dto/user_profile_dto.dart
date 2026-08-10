import "dart:convert";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/user/domain/index.dart";

part "user_profile_dto.freezed.dart";
part "user_profile_dto.g.dart";

/// `GET /user-profile/me` 响应体（信封解包后的 data，`user.api.md` v2）。
///
/// 两处刻意"贴合后端而非贴合领域"：
/// 1. `hobbies` / `personalityTags` 后端下发的是**JSON 文本**（`'["学习","阅读"]'`）
///    而不是数组，所以这里类型是 `String?`，映射时才解成 `List<String>`；
/// 2. 时间字段留 String（`"2026-04-16 00:46:30"` / `"2017-06-27"`），映射时 `tryParse`
///    兜底——格式一漂移就把整份档案打成解析失败太脆。
///
/// 除 [id] 外全部可空：验证码登录会为新手机号直接建号，此时档案几乎全空。
@freezed
abstract class UserProfileDto with _$UserProfileDto {
  const UserProfileDto._();

  const factory UserProfileDto({
    required String id,

    /// 所属用户 id（对应登录响应 `userInfo.id`）。
    String? userId,
    String? nickname,
    String? gender,
    String? zodiac,

    /// 职业。领域实体里叫 `occupation`，映射时改名。
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
    int? status,
    String? createTime,
    String? updateTime,
  }) = _UserProfileDto;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  UserProfile toEntity() {
    final birth = _parseTime(birthday);
    return UserProfile(
      // 昵称是实体的必填展示锚点；后端没给就退化成空串，UI 已有"首字母兜底"处理。
      nickname: nickname ?? "",
      // 档案 id 必须带进领域层：保存时 `PUT /update` 要回传它。
      id: id,
      gender: gender,
      // 契约没有 age 字段，由生日派生一次，避免各处 UI 各算一套。
      age: _ageOf(birth),
      birthday: birth,
      zodiac: zodiac,
      city: city,
      occupation: profession,
      industry: industry,
      company: company,
      hobbies: _decodeStringList(hobbies),
      mbti: mbti,
      idealLife: idealLife,
      personalityTags: _decodeStringList(personalityTags),
    );
  }

  /// 解析"数组被序列化成 JSON 文本"的字段。
  ///
  /// 解析不了就当空列表：少几个兴趣标签，远好过整页档案打不开。
  static List<String> _decodeStringList(String? raw) {
    if (raw == null || raw.isEmpty) return const <String>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <String>[];
      return decoded.whereType<String>().toList(growable: false);
    } on FormatException {
      return const <String>[];
    }
  }

  /// 宽松解析服务端时间串：解析不了就当"没有这个时间"，不抛异常。
  static DateTime? _parseTime(String? raw) =>
      (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);

  /// 由生日推算周岁。算法收在 `profile_derivations.dart`——档案表单也要用同一套，
  /// 两处各算一份迟早会不一致（生日填成未来日期时返回 null，档案上不出现"-3 岁"）。
  static int? _ageOf(DateTime? birthday) =>
      birthday == null ? null : ageFromBirthday(birthday);
}
