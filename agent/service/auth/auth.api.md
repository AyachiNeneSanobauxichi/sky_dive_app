# auth api

## v1

- 获取验证码接口

```ts
// get
const path =
  "https://lifescript.happylifeos.com/api/auth/sms-code?phone=15040646791";

const response = {
  code: 200,
  message: "验证码已发送",
  data: {
    code: "123456",
    expiresIn: 300,
    message: "验证码已发送，用于登录验证，有效期5分钟",
  },
  timestamp: 1785860858577,
};
```

- 登录接口

```ts
// post
const path = "https://lifescript.happylifeos.com/api/auth/login";

const request = {
  phone: "15040646791",
  smsCode: "123456",
};

const response = {
  code: 200,
  message: "登录成功",
  data: {
    accessToken:
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyZDY3MDJkZjk1MzFlNzYyZDgzZjEzMzgwNTk0MmU0MiIsInVzZXJuYW1lIjoi5byA5b-Db0Y2SnhxIiwidXNlclR5cGUiOiJ1c2VyIiwiaWF0IjoxNzg1ODYwOTY3LCJleHAiOjE3ODU5NDczNjd9.2nJKi3vJdzgVAX-Ls-sUmcIvg5vfHXvCXa4sc-VKBnDnivX9h_pogeHxU704ONZIeLPv7VWEA5WMWmQxxOap1A",
    refreshToken:
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyZDY3MDJkZjk1MzFlNzYyZDgzZjEzMzgwNTk0MmU0MiIsInVzZXJuYW1lIjoi5byA5b-Db0Y2SnhxIiwidXNlclR5cGUiOiJ1c2VyIiwiaWF0IjoxNzg1ODYwOTY3LCJleHAiOjE3ODY0NjU3Njd9.uhwP1w3DKWLd7SB9tBdkYX4_yCqKvEaOJv3OfFT0U-ULeAbAD9Am4CH3vpzcT4GTZyfqOJmhR8R-sq8tubWO5g",
    expiresIn: 86400,
    userInfo: {
      id: "2d6702df9531e762d83f133805942e42",
      account: "15040646791",
      username: "开心oF6Jxq",
      nickname: "开心oF6Jxq",
      phone: "15040646791",
      status: 1,
      memberLevel: "free",
      totalDays: 0,
      lastActiveTime: "2026-07-02 00:36:26",
      createTime: "2026-04-16 00:45:28",
    },
    loginTime: "2026-08-05 00:29:27",
  },
  timestamp: 1785860967960,
};
```
