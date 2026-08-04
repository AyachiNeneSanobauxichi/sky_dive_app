# user api

## v1

- 契约未定：本期无接口。业务侧按 mock 规范在 `lib/features/user/data/mock/` 造假数据跑通链路，接口定稿后回本文件补 `request` / `response`，并删除 mock。

## v2

- 用户信息接口

```ts
// get
const path = "https://lifescript.happylifeos.com/api/user-profile/me";

const response = {
  code: 200,
  message: "操作成功",
  data: {
    id: "de2e5fb66f283239ec926bb9c68f7870",
    userId: "2d6702df9531e762d83f133805942e42",
    nickname: "张义明",
    gender: "男",
    zodiac: "天秤座",
    profession: "产品经理",
    mbti: "ENFJ",
    hobbies: '["学习", "阅读", "旅行", "音乐", "写作"]',
    idealLife:
      "热爱阅读和旅行，喜欢用文字和镜头记录生活。\n相信真诚和努力能让世界变得更美好。",
    city: "北京",
    industry: "IT",
    company: "Meta",
    personalityTags: '["理性", "感性", "乐观", "独立"]',
    birthday: "2017-06-27",
    status: 1,
    createTime: "2026-04-16 00:46:30",
    updateTime: "2026-04-16 00:46:30",
  },
  timestamp: 1785860968407,
};
```

## v3

- 编辑接口

```ts
// put
const path = "https://lifescript.happylifeos.com/api/user-profile/update";

const request = {
  birthday: "2017-06-27",
  city: "北京",
  company: "Meta",
  gender: "男",
  hobbies: ["学习", "阅读", "旅行", "音乐", "写作"],
  id: "de2e5fb66f283239ec926bb9c68f7870",
  idealLife:
    "热爱阅读和旅行，喜欢用文字和镜头记录生活。↵相信真诚和努力能让世界变得更美好。",
  industry: "IT",
  mbti: "ENFJ",
  nickname: "张义明",
  personalityTags: ["理性", "感性", "乐观", "独立"],
  profession: "产品经理",
  zodiac: "天秤座",
};

const response = {
  code: 200,
  message: "操作成功",
  data: {
    id: "de2e5fb66f283239ec926bb9c68f7870",
    userId: "2d6702df9531e762d83f133805942e42",
    nickname: "张义明",
    gender: "男",
    zodiac: "天秤座",
    profession: "产品经理",
    mbti: "ENFJ",
    hobbies: '["学习","阅读","旅行","音乐","写作"]',
    idealLife:
      "热爱阅读和旅行，喜欢用文字和镜头记录生活。\n相信真诚和努力能让世界变得更美好。",
    city: "北京",
    industry: "IT",
    company: "Meta",
    personalityTags: '["理性","感性","乐观","独立"]',
    birthday: "2017-06-27",
    status: 1,
    createTime: "2026-04-16 00:46:30",
    updateTime: "2026-04-16 00:46:30",
  },
  timestamp: 1785863652300,
};
```
