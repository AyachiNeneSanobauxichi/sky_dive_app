import "package:freezed_annotation/freezed_annotation.dart";

part "user.freezed.dart";

/// 登录用户领域实体。只保留 UI 需要的最小信息（用户名、邮箱）。
@freezed
abstract class User with _$User {
  const factory User({required String username, required String email}) = _User;
}
