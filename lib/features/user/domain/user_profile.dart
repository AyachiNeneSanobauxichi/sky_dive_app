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
///
/// 字段来源（`user.api.md` v2 `GET /user-profile/me`）：[age] 由 `birthday` 派生
/// （契约无此字段），[occupation] 对应契约的 `profession`。
// TODO(user): 契约未下发 [avatarUrl] 与三个成长指标（[awakeningLevel] /
//   [awakeningProgress] / [starAffinity]），真实数据下这三项恒为默认值（等级 1、
//   进度 0），等级卡形同占位。后端补字段后回来对齐。
// TODO(user): 性别 / 星座日后大概率收敛成枚举 + i18n 映射，现按后端原样的中文串透传。
@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    required String nickname,

    /// 档案 id（不是用户 id）。
    ///
    /// `PUT /user-profile/update` **必传**它，所以实体必须带着走——只在 UI 层留一份
    /// 展示数据，保存时就没有 id 可回传了。新建号且从未建档时为 null，
    /// 此时保存要走 `create` 而不是 `update`。
    String? id,

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

    /// MBTI 人格类型（如 `ENFJ`）。
    String? mbti,

    /// 用户自述的"理想生活"，可含换行。story 生成时最有信息量的一段素材。
    String? idealLife,

    /// 性格标签（如 理性 / 乐观）。
    @Default(<String>[]) List<String> personalityTags,
  }) = _UserProfile;

  /// 档案填写完成度（0–1）：驱动"完善档案"的引导文案与星厉契合度。
  ///
  /// 只统计**用户能在档案表单里亲手填的项**，不含昵称/头像与两个成长指标。
  ///
  /// [age] 与 [zodiac] 刻意**不计入**：两者都由 [birthday] 推导（见档案表单），
  /// 计进去等于让生日一项顶三项，完成度会虚高。
  ///
  /// v4 起 [mbti] / [idealLife] / [personalityTags] 计入——档案表单已经有这三项的
  /// 入口了，不计入的话完成度永远差一截而用户找不到还能填什么。
  double get profileCompleteness {
    final filled = <bool>[
      gender != null,
      birthday != null,
      city != null,
      occupation != null,
      industry != null,
      company != null,
      hobbies.isNotEmpty,
      mbti != null,
      idealLife != null,
      personalityTags.isNotEmpty,
    ].where((isFilled) => isFilled).length;
    return filled / _profileFieldCount;
  }

  bool get isProfileComplete => profileCompleteness >= 1;

  static const int _profileFieldCount = 10;
}
