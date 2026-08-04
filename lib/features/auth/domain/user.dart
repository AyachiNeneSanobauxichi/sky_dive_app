import "package:freezed_annotation/freezed_annotation.dart";

part "user.freezed.dart";

/// 登录用户领域实体。
///
/// 字段对齐 `auth.api.md` v1 登录响应的 `userInfo`。[id] 是后端主键（服务端一切
/// 按它认人），[phone] 是登录凭据兼展示锚点，二者必填；其余字段一律可空 / 带默认值
/// ——登录本身成功了，却因为某个展示字段缺失而把用户挡在门外，是不能接受的。
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String phone,

    /// 登录账号。v1 与手机号同值，但语义不同：账号可改，手机号是凭据。
    String? account,

    /// 系统生成的用户名（注册时按规则派生，如「开心oF6Jxq」）。
    String? username,

    /// 用户可改的昵称。验证码登录会为新手机号直接建号，此时可能与 [username] 同值。
    String? nickname,

    /// 账号状态原始值（v1 样例为 1）。
    ///
    // TODO(auth): auth.api.md 未给出 status 取值表，补齐后改成枚举 + unknown 兜底。
    int? status,

    /// 会员等级原始值（v1 已知 "free"）。
    ///
    /// 刻意保留 String 而非枚举：等级全集未定，过早枚举化会把后端新加的付费等级
    /// 静默吞成 unknown，付费用户被当免费用户处理是比"多一个字符串"严重得多的事故。
    // TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
    String? memberLevel,

    /// 累计使用天数。
    @Default(0) int totalDays,

    /// 最近活跃时间 / 注册时间（后端以本地时间字符串下发，解析失败则为 null）。
    DateTime? lastActiveTime,
    DateTime? createTime,
  }) = _User;
}
