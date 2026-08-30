/// 登录方式。
///
/// 两条路并存是刻意的：
/// - **邮箱 + 密码**：日本 C 端预约类产品的主流做法，也是唯一能"注册"的路径
///   （要留下可联系的邮箱才能发行程确认与保险单）；
/// - **手机号 + 验证码**：到了现场临时下单的客人不想现编密码，一条短信最快。
///
/// 两条路指向同一个账号：手机号验证码首次登录会由后端建号，之后可在账号设置里补邮箱。
enum AuthMethod {
  email,
  phone;

  bool get isEmail => this == AuthMethod.email;
  bool get isPhone => this == AuthMethod.phone;
}
