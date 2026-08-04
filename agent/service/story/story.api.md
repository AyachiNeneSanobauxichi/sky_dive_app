# story api

## v1

- 契约未定：本期无接口。业务侧按 mock 规范在 `lib/features/story/data/mock/` 造假数据跑通链路，接口定稿后回本文件补 `request` / `response`，并删除 mock。

## v2

- 灵感提示词接口

```ts
// get
const path =
  "https://lifescript.happylifeos.com/api/epicScript/inspiration/recommendations";

const response = {
  code: 200,
  message: "操作成功",
  data: [
    {
      text: "我想把最近一次低谷，改写成主角觉醒的开端。",
      tag: "觉醒",
      category: "转折",
    },
    {
      text: "如果我在最遗憾的选择里勇敢了一次，人生会怎样展开？",
      tag: "遗憾",
      category: "重启",
    },
    {
      text: "把一次普通的职场挑战，写成逆风翻盘的高光篇章。",
      tag: "职场",
      category: "成长",
    },
    {
      text: "我想见到十年后的自己，让 TA 给现在的我一封信。",
      tag: "未来",
      category: "对话",
    },
    {
      text: "把一段关系里的告别，写成重新认识自己的旅程。",
      tag: "关系",
      category: "治愈",
    },
    {
      text: "让我的童年记忆成为故事里的隐藏力量。",
      tag: "童年",
      category: "力量",
    },
    {
      text: "把一次失败的面试、考试或竞赛，改写成命运伏笔。",
      tag: "挑战",
      category: "伏笔",
    },
    {
      text: "写一个我终于不再讨好别人，开始选择自己的平行人生。",
      tag: "自我",
      category: "选择",
    },
  ],
  timestamp: 1785860968603,
};
```
