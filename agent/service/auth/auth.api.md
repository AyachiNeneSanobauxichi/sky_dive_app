# auth api

> ⚠️ 后端尚未就绪。以下契约是客户端与假后端（`lib/features/auth/data/mock/`）共同遵循的**约定稿**，
> 真实后端接入时以后端为准，客户端只需改 DTO 与 `authDataSourceProvider` 一行装配。
>
> 所有响应都是信封形态：`{ code, message, data }`，下面的 `response` 只写 `data` 的形状。

## v1

### 发送短信验证码

`GET /auth/sms-code`，无需鉴权。

```ts
// request（query）
{
  phone: string; // 日本国内格式，含前导 0，如 "09012345678"
}

// response
{
  code: string | null;    // 联调期回显的验证码，生产环境应移除
  expiresIn: number;      // 验证码有效期（秒），v1 = 300。⚠️ 不是重发冷却
  message: string | null; // 服务端提示文案
}
```

> 重发冷却**不由接口下发**，客户端本地按 60 秒计（`SmsCodeController`）。服务端仍应按号码做真正的限频。

### 邮箱密码登录

`POST /auth/login/email`，无需鉴权。

```ts
// request
{
  email: string;
  password: string;
}

// response —— 与 /auth/login/sms、/auth/register 同形
{
  accessToken: string;
  refreshToken: string;
  expiresIn: number;        // accessToken 有效期（秒），v1 = 86400
  loginTime: string;        // ISO-8601
  isNewAccount: boolean;    // 本次是否新建了账号
  userInfo: {
    id: string;
    displayName: string;
    email: string | null;
    phone: string | null;
    avatarUrl: string | null;
    licenseLevel: string | null; // "none" | "aff" | "a" | "b" | "c" | "d"
    totalJumps: number;
    createdAt: string | null;    // ISO-8601
    lastActiveAt: string | null; // ISO-8601
  };
}
```

### 短信验证码登录

`POST /auth/login/sms`，无需鉴权。未注册的手机号**由服务端直接建号**并返回 `isNewAccount: true`。

```ts
// request
{
  phone: string;
  smsCode: string; // 6 位数字
}

// response：同 /auth/login/email
```

### 注册

`POST /auth/register`，无需鉴权。成功即返回**可用会话**（不要求客户端再登录一次）。

```ts
// request
{
  email: string;
  password: string;
  displayName: string;
  phone?: string | null; // 选填
}

// response：同 /auth/login/email，isNewAccount 恒为 true
```

### 刷新令牌

`POST /auth/refresh-token`，无需鉴权（凭 refreshToken 本身）。

```ts
// request
{
  refreshToken: string;
}

// response —— 只回新的 accessToken，不轮换 refreshToken
{
  accessToken: string;
  expiresIn: number;
}
```

> ⚠️ 这个端点的路径还与 `core/network/interceptors/auth_interceptor.dart` 里的硬编码值联动，后端定稿后两处要一起改。

### 登出

`POST /auth/logout`，**需鉴权**（服务端凭 accessToken 判断吊销谁的会话）。无请求体，`data` 为 `null`。

> 客户端等待上限 5 秒，超时或失败都照常清空本地会话——登出是"我现在就要离开"的诉求。

### 业务错误码

`code` 非成功码时的取值。客户端按码出本地化文案（`authFailureMessage`），码表以外的一律用服务端下发的 `message` 兜底。

| code | 含义 | 客户端行为 |
| --- | --- | --- |
| 10001 | 邮箱或密码不正确 | 只清密码、保留邮箱、聚焦回密码框。**不区分**"账号不存在"与"密码错"，否则等于提供账号探测接口 |
| 10002 | 验证码不正确 | 清空 OTP、聚焦回第一格 |
| 10003 | 验证码已过期 | 同上，文案提示重新获取 |
| 10010 | 邮箱已被注册 | 就地钉在邮箱字段下方并聚焦 |
| 10011 | 手机号已绑定其它账号 | 就地钉在手机号字段下方并聚焦 |
| 10020 | 账号被停用 | 就地钉在邮箱字段下方（不用 toast） |

## v2

### 登录 / 注册响应的 `userInfo` 增加 `role`

```ts
interface UserInfo {
  // …v1 既有字段不变
  role?: "customer" | "staff"; // 账号角色；缺失按 customer 处理
}
```

- `staff` = 运营 / 地勤，能排班（航线增删改 + 名单分配，见 `agent/service/flight/flight.api.md`）。
- 客户端对**认不出的取值一律降级成 `customer`**（最小权限）。这与 `licenseLevel` 认不出时宁可多给的取舍方向相反——权限判断只能少给。
- 客户端只用它显隐入口；**权限的真正边界在服务端**，排班相关接口必须自己校验角色。
- 冷启动靠本地用户快照恢复登录态，快照里没有 `role`（旧版本存的）时同样降级成 `customer`。
