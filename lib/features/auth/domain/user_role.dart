/// 账号角色。决定这个人能不能**排班**（新建 / 编辑 / 删除航线、给航线排人）。
///
/// 角色由**后端在登录响应里下发**，客户端只做展示与入口显隐——权限的真正边界在
/// 服务端，客户端藏起来的按钮挡不住任何人，只是别让客人看见和自己无关的东西。
///
/// 认不出的取值一律降级成 [customer]（最小权限）。这和 `User.licenseLevel`
/// 刻意保留 String 的取舍**方向相反**：执照等级认不出时宁可多给（当持证），
/// 权限认不出时必须少给——把新加的某个只读角色误判成运营，等于把排班板交出去。
enum UserRole {
  /// 普通客人：看航线、下预约、管自己的跳伞记录。
  customer,

  /// 运营 / 地勤：额外能排班（航线增删改 + 名单分配）。
  staff;

  static UserRole fromRaw(String? raw) => switch (raw) {
    "staff" || "admin" || "manifest" => UserRole.staff,
    _ => UserRole.customer,
  };

  String get raw => switch (this) {
    UserRole.customer => "customer",
    UserRole.staff => "staff",
  };

  /// 能否排班。用语义 getter 而不是让调用方到处写 `role == UserRole.staff`：
  /// 以后加了"只读运营"这类角色，只改这一处。
  bool get canManageLoads => this == UserRole.staff;
}
