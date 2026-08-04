import "package:freezed_annotation/freezed_annotation.dart";

part "user_profile.freezed.dart";

/// 档案字段的稳定标识。
///
/// 用途：从档案卡点某一行 → 带着这个 key 跳到档案设置页，设置页据此定位/聚焦到
/// 对应输入项。**不要用展示文案当标识**——文案会随 i18n 变，key 不会；
/// 日后真实表单也用同一套 key 做锚点。
enum UserProfileFieldKey {
  gender,
  age,
  birthday,
  zodiac,
  city,
  occupation,
  industry,
  company,
  hobbies;

  /// 供路由 query 参数往返用（`?field=company`）。
  static UserProfileFieldKey? tryParse(String? name) {
    if (name == null) return null;
    for (final key in values) {
      if (key.name == name) return key;
    }
    return null;
  }
}

/// 用户档案领域实体（v2）。
///
/// 这是 story 生成时的"作者设定"：昵称/头像是身份，[awakeningLevel] 与
/// [starAffinity] 是产品化的成长指标，其余字段是画像素材——档案越全，
/// 生成的故事越贴合本人。
///
/// **除昵称外全部可空**：验证码登录会为新手机号直接建号，此时档案是空的，
/// UI 必须能展示"未填写"而不是崩在 null 上。
// TODO(user): 接口契约未定（agent/service/user/user.api.md 为空），字段名与类型
//   按 UI 需要先行假设：性别/星座等日后大概率收敛成枚举 + i18n 映射，
//   [age] 也可能改为从 [birthday] 推导。定稿后回来对齐并删除 data/mock/。
@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    required String nickname,

    /// 头像地址。为空时 UI 退化成"昵称首字 + 品牌渐变"的字母头像。
    String? avatarUrl,

    /// 深度觉醒等级。
    @Default(1) int awakeningLevel,

    /// 当前等级内的进度（0–1），用于等级卡的进度条。
    @Default(0) double awakeningProgress,

    /// 星厉契合度（0–1）。
    @Default(0) double starAffinity,

    // ── 个人档案 ──
    String? gender,
    int? age,
    DateTime? birthday,
    String? zodiac,
    String? city,
    String? occupation,
    String? industry,
    String? company,
    @Default(<String>[]) List<String> hobbies,
  }) = _UserProfile;

  /// 档案填写完成度（0–1）：驱动"完善档案"的引导文案。
  ///
  /// 只统计档案字段，不含昵称/头像与两个成长指标——那两类不是用户手填的。
  double get profileCompleteness {
    final filled = <bool>[
      gender != null,
      age != null,
      birthday != null,
      zodiac != null,
      city != null,
      occupation != null,
      industry != null,
      company != null,
      hobbies.isNotEmpty,
    ].where((isFilled) => isFilled).length;
    return filled / _profileFieldCount;
  }

  bool get isProfileComplete => profileCompleteness >= 1;

  static const int _profileFieldCount = 9;
}
