import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/auth/domain/user_role.dart";

part "user.freezed.dart";

/// 登录用户领域实体。
///
/// 字段对齐 `auth.api.md` v1 登录响应的 `userInfo`。[id] 是后端主键（服务端一切
/// 按它认人）；[email] 与 [phone] 都可空但**不会同时为空**——邮箱注册的人有邮箱，
/// 现场用短信验证码进来的人有手机号，两者都是可用于找回账号的联系方式。
/// 其余字段一律可空 / 带默认值：登录本身成功了，却因为某个展示字段缺失而把用户
/// 挡在门外，是不能接受的。
@freezed
abstract class User with _$User {
  const factory User({
    required String id,

    /// 显示名。注册时用户自己填，短信首登时后端按手机号后四位派生一个占位名。
    required String displayName,

    /// 登录邮箱。短信首登建号时为空，可在账号设置里补。
    String? email,

    /// 手机号（日本国内格式，含前导 0）。邮箱注册时为空。
    String? phone,

    /// 头像地址。
    String? avatarUrl,

    /// 跳伞执照等级原始值（v1 已知 `"none"` / `"aff"` / `"a"` / `"b"` / `"c"` / `"d"`）。
    ///
    /// 刻意保留 String 而非枚举：等级全集由运营方定义、还会随课程体系调整，
    /// 过早枚举化会把后端新加的等级静默吞成 unknown——把持证跳伞员当成体验客处理，
    /// 是比"多一个字符串"严重得多的事故（体验跳要配教练，持证跳不用）。
    // TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
    String? licenseLevel,

    /// 累计跳伞次数。老客要看到这个数字，这是他们的资历。
    @Default(0) int totalJumps,

    /// 账号角色。决定排班入口给不给他看（见 [UserRole]）。
    /// 缺省是客人：后端没下发角色时不该凭空多出一个运营。
    @Default(UserRole.customer) UserRole role,

    /// 注册时间 / 最近活跃时间（后端以 ISO-8601 下发，解析失败则为 null）。
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) = _User;

  const User._();

  /// 找回账号 / 客服联系时优先用哪个标识。展示态也用它当副标题。
  String? get primaryIdentifier => email ?? phone;

  /// 能否排班（航线增删改 + 名单分配）。
  bool get canManageLoads => role.canManageLoads;

  /// 是否已经是持证跳伞员（决定首页给他看体验跳还是自由跳的航线）。
  bool get isLicensed =>
      licenseLevel != null &&
      licenseLevel != "none" &&
      licenseLevel!.isNotEmpty;
}
