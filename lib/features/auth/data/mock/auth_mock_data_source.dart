import "dart:math" as math;

import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/auth/data/auth_data_source.dart";
import "package:sky_dive/features/auth/data/dto/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";

/// 假后端：把整条认证链路（发码 → 登录 / 注册 → 刷新 → 登出）在本地跑通。
///
/// ## 为什么值得写这么细
/// 后端就绪前，UI 的加载 / 空 / 错误四态如果没有真实的失败可触发，就只能靠
/// 想象去写，上线时必然漏。这里刻意造出**六种可复现的失败**（见 [AuthErrorCode]），
/// 并给每个请求配了真实量级的延迟——按钮的忙碌态、防重复提交、
/// 「验证码填错自动清空、网络故障保留输入」这些分支才真的被走过。
///
/// ## 边界
/// - 账号存在**进程内存**里：热重启（hot restart）与杀进程都会清空，注册的账号
///   随之消失。这是刻意的——mock 不该假装自己是数据库，
///   谁也不该在它上面积累"数据"。已登录状态本身仍会被 refreshToken 持久化恢复，
///   但恢复时账号已经不在表里，于是会走"会话失效"分支——这条路径正好也需要被验到。
/// - 密码**明文比对**。这里不是要示范存储方案，真实后端只会拿到哈希。
///
// TODO(auth): 接入真实后端后，删除整个 `data/mock/` 目录，并把
//   `authDataSourceProvider` 换回 `AuthRemoteDataSource`。
//   届时 `kAuthMockEnabled` 的引用点（登录页的演示账号提示条）会编译报错，
//   那正是提醒你把它一并删掉。
class AuthMockDataSource implements AuthDataSource {
  AuthMockDataSource();

  /// 账号表。`static` 是必要的：provider 在某些时机会重建数据源，
  /// 实例字段会让刚注册的账号在下一次重建时凭空消失。
  static final List<_MockAccount> _accounts = <_MockAccount>[
    _MockAccount(
      id: "u_10001",
      email: demoEmail,
      password: demoPassword,
      displayName: "Kenji Sato",
      phone: "09012345678",
      licenseLevel: "b",
      totalJumps: 42,
    ),
    // 运营账号：登录后能看到排班入口（新建 / 编辑 / 删除航线、排名单）。
    // 客人账号看到的是同一份列表，只是没有那些入口。
    _MockAccount(
      id: "u_10003",
      email: demoStaffEmail,
      password: demoPassword,
      displayName: "Aya Manifest",
      phone: "09098765432",
      licenseLevel: "d",
      totalJumps: 1280,
      role: UserRole.staff,
    ),
    _MockAccount(
      id: "u_10002",
      email: "blocked@skydive.jp",
      password: demoPassword,
      displayName: "Suspended Account",
      isDisabled: true,
    ),
  ];

  /// 已下发但未使用的验证码：手机号 → 验证码。
  static final Map<String, String> _issuedCodes = <String, String>{};

  /// 已下发的 refreshToken → 账号 id。登出会把它移除，于是"登出后冷启动
  /// 不该自动登录"这条路径也能被验到。
  static final Map<String, String> _sessions = <String, String>{};

  static int _idSeed = 10003;

  /// 演示账号。登录页在 mock 开启时会把它显示出来，省掉"先注册才能看页面"。
  static const String demoEmail = "demo@skydive.jp";

  /// 演示**运营**账号（能排班）。两个视角都要能被随手验一遍，
  /// 所以演示账号必须成对给，不能只给客人那个。
  static const String demoStaffEmail = "staff@skydive.jp";

  static const String demoPassword = "skydive2026";

  /// 万能验证码。真实后端当然不会有这种东西。
  static const String demoSmsCode = "123456";

  // ───────────────────────── 接口实现 ─────────────────────────

  @override
  Future<Map<String, dynamic>> sendSmsCode(SendSmsCodeRequestDto params) async {
    await _latency(_smsLatency);
    final phone = AuthRules.normalizePhone(params.phone);
    _issuedCodes[phone] = demoSmsCode;
    return <String, dynamic>{
      "code": demoSmsCode,
      "expiresIn": 300,
      "message": null,
    };
  }

  @override
  Future<Map<String, dynamic>> loginWithEmail(EmailLoginRequestDto body) async {
    await _latency(_authLatency);
    final email = body.email.trim().toLowerCase();
    final account = _accounts
        .where((a) => a.email?.toLowerCase() == email)
        .firstOrNull;

    // 账号不存在与密码错误返回**同一个码**：区分开等于给撞库的人一个
    // 免费的账号存在性探测接口。
    if (account == null || account.password != body.password) {
      throw const BusinessException(code: AuthErrorCode.credentialsInvalid);
    }
    if (account.isDisabled) {
      throw const BusinessException(code: AuthErrorCode.accountDisabled);
    }
    return _sessionOf(account);
  }

  @override
  Future<Map<String, dynamic>> loginWithSms(SmsLoginRequestDto body) async {
    await _latency(_authLatency);
    final phone = AuthRules.normalizePhone(body.phone);
    final issued = _issuedCodes[phone];

    if (issued == null) {
      // 没发过码就来登录：当作"码过期了"，UI 会提示重新获取。
      throw const BusinessException(code: AuthErrorCode.smsCodeExpired);
    }
    if (issued != body.smsCode) {
      throw const BusinessException(code: AuthErrorCode.smsCodeIncorrect);
    }
    _issuedCodes.remove(phone); // 一次性：同一条码不能用两次

    final existing = _accounts.where((a) => a.phone == phone).firstOrNull;
    if (existing != null) {
      if (existing.isDisabled) {
        throw const BusinessException(code: AuthErrorCode.accountDisabled);
      }
      return _sessionOf(existing);
    }

    // 未注册的手机号直接建号——现场排队的客人没时间先注册再回来登录。
    final created = _MockAccount(
      id: "u_${_idSeed++}",
      phone: phone,
      // 显示名先用后四位派生一个占位，进 app 后可改。
      displayName: "Jumper ${phone.substring(phone.length - 4)}",
    );
    _accounts.add(created);
    return _sessionOf(created, isNewAccount: true);
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequestDto body) async {
    await _latency(_registerLatency);
    final email = body.email.trim().toLowerCase();
    final phone = body.phone == null || body.phone!.isEmpty
        ? null
        : AuthRules.normalizePhone(body.phone!);

    if (_accounts.any((a) => a.email?.toLowerCase() == email)) {
      throw const BusinessException(code: AuthErrorCode.emailAlreadyRegistered);
    }
    if (phone != null && _accounts.any((a) => a.phone == phone)) {
      throw const BusinessException(code: AuthErrorCode.phoneAlreadyRegistered);
    }

    final created = _MockAccount(
      id: "u_${_idSeed++}",
      email: body.email.trim(),
      password: body.password,
      displayName: body.displayName.trim(),
      phone: phone,
    );
    _accounts.add(created);
    return _sessionOf(created, isNewAccount: true);
  }

  @override
  Future<Map<String, dynamic>> refreshToken(RefreshTokenRequestDto body) async {
    await _latency(_refreshLatency);
    final accountId = _sessions[body.refreshToken];
    if (accountId == null || !_accounts.any((a) => a.id == accountId)) {
      // 登出过、或进程重启导致账号表已清空：会话不可恢复。
      throw const UnauthorizedException();
    }
    return <String, dynamic>{
      "accessToken": _token("access", accountId),
      "expiresIn": _accessTokenTtlSeconds,
    };
  }

  @override
  Future<void> logout() async {
    await _latency(_logoutLatency);
    // 真实后端按 accessToken 认人；mock 手上没有它，直接把所有会话吊销
    // ——单用户的本地假后端里两者等价。
    _sessions.clear();
  }

  // ───────────────────────── 内部 ─────────────────────────

  /// 造一份与 `auth.api.md` v1 完全同形的登录响应。
  Map<String, dynamic> _sessionOf(
    _MockAccount account, {
    bool isNewAccount = false,
  }) {
    final refreshToken = _token("refresh", account.id);
    _sessions[refreshToken] = account.id;
    final now = DateTime.now();

    return <String, dynamic>{
      "accessToken": _token("access", account.id),
      "refreshToken": refreshToken,
      "expiresIn": _accessTokenTtlSeconds,
      "loginTime": now.toIso8601String(),
      "isNewAccount": isNewAccount,
      "userInfo": <String, dynamic>{
        "id": account.id,
        "displayName": account.displayName,
        "email": account.email,
        "phone": account.phone,
        "avatarUrl": null,
        "licenseLevel": account.licenseLevel,
        "totalJumps": account.totalJumps,
        "role": account.role.raw,
        "createdAt": account.createdAt.toIso8601String(),
        "lastActiveAt": now.toIso8601String(),
      },
    };
  }

  /// 造一个每次都不同的令牌串，避免"看起来像但其实是同一个"掩盖刷新逻辑的问题。
  String _token(String kind, String accountId) =>
      "mock.$kind.$accountId.${_random.nextInt(1 << 32).toRadixString(16)}";

  /// 模拟网络延迟。**不要调成 0**：零延迟下按钮的忙碌态一闪而过，
  /// 等于没验过"等待中不可重复触发"这条规则。
  Future<void> _latency(Duration base) {
    final jitter = _random.nextInt(_jitterMillis);
    return Future<void>.delayed(base + Duration(milliseconds: jitter));
  }

  static final math.Random _random = math.Random();
}

/// mock 是否启用。登录页据此决定要不要显示演示账号提示条。
///
/// 换回真实数据源时把整个 `mock/` 目录删掉，这个常量的引用点会编译报错，
/// 提醒你把提示条一起删干净。
const bool kAuthMockEnabled = true;

/// 内存里的一条账号记录。
class _MockAccount {
  _MockAccount({
    required this.id,
    required this.displayName,
    this.email,
    this.password,
    this.phone,
    this.licenseLevel,
    this.totalJumps = 0,
    this.role = UserRole.customer,
    this.isDisabled = false,
  }) : createdAt = DateTime.now();

  final String id;
  final String displayName;
  final String? email;

  /// 明文密码。短信建号的账号没有密码，故可空。
  final String? password;
  final String? phone;
  final String? licenseLevel;
  final int totalJumps;
  final UserRole role;
  final bool isDisabled;
  final DateTime createdAt;
}

// ───────────────────────── mock 参数 ─────────────────────────

/// 各接口的基准延迟。取值贴近真实移动网络下的体感，
/// 让忙碌态、防重复提交、骨架屏都能被肉眼验到。
const Duration _smsLatency = Duration(milliseconds: 700);
const Duration _authLatency = Duration(milliseconds: 900);
const Duration _registerLatency = Duration(milliseconds: 1100);
const Duration _refreshLatency = Duration(milliseconds: 600);
const Duration _logoutLatency = Duration(milliseconds: 400);

/// 延迟抖动上限，避免每次都是一模一样的时长（那会掩盖竞态问题）。
const int _jitterMillis = 350;

/// accessToken 有效期（秒）。
const int _accessTokenTtlSeconds = 86400;
