import "package:freezed_annotation/freezed_annotation.dart";

part "user.freezed.dart";

/// 登录用户领域实体。
///
/// v3（手机号验证码登录）：身份锚点从邮箱换成手机号。[nickname] 可空——
/// 验证码登录会为新手机号直接建号，此时用户还没起过昵称，UI 需自行兜底展示。
@freezed
abstract class User with _$User {
  const factory User({required String phone, String? nickname}) = _User;
}
