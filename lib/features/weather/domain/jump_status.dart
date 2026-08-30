/// 今日能不能跳的判断结果。
///
/// 这不是"天气好不好"，而是**运营方的放飞决定**——同样的风速，
/// 体验跳（带教练）和持证跳的门槛不一样，判断只能由运营方给，客户端不推算。
enum JumpStatus {
  /// 可跳：按计划起飞。
  go,

  /// 临界：风速 / 云底高度在边缘，当天现场再定。客人要能提前知道有变数。
  marginal,

  /// 停飞：今天不飞。
  hold;

  static JumpStatus fromRaw(String? raw) => switch (raw) {
    "go" => JumpStatus.go,
    "marginal" => JumpStatus.marginal,
    "hold" => JumpStatus.hold,
    // 认不出的值一律当"临界"而不是"可跳"：把停飞误报成可跳，
    // 会有人白跑两小时车程；反过来只是让人多问一句。
    _ => JumpStatus.marginal,
  };
}
