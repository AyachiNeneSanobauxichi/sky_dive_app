# story-history api

> 契约来源：`happy-life-star/mini-program/api-doc/04-epic-script.md` 与 `00-通用约定.md`。
> 本文件只抄**本模块用得到的那几个端点**，字段以 mini-program 的文档为准。

## v1

全部端点需要 `Authorization`（由 `AuthInterceptor` 注入）。响应走项目统一信封，
`DioClient` 已解包，下面写的都是解包后的 `data`。

### 1. 剧本分页

```ts
// get
const path = "/epicScript/page";

// query（BasePageRequest：注意参数名是 current / size，不是 pageNum / pageSize）
const request = {
  current: 1, // 页码，从 1 开始
  size: 10, // 每页条数
  orderBy: "createTime", // 可选
  orderDirection: "desc", // 可选，默认 desc
  keyword: "", // 可选，关键词
  style: "", // 可选，文风
  length: "", // 可选，篇幅
};

// data：PageResult<EpicScriptResponse>
const response = {
  current: 1,
  size: 10,
  total: 42,
  pages: 5,
  records: [], // EpicScriptResponse[]
};
```

### 2. 剧本详情

```ts
// get
const path = "/epicScript/detail"; // ?id=xxx
// data: EpicScriptResponse；不存在时 code 为 404
```

### 3. 删除剧本

```ts
// delete
const path = "/epicScript/delete"; // ?id=xxx
// data: null
```

### 4. 收藏

```ts
// post —— 切换收藏
const togglePath = "/epicScript/favorite/toggle";
const toggleRequest = { scriptId: "xxx" };
const toggleResponse = {
  scriptId: "xxx",
  isFavorited: true, // 切换**之后**的状态
  favoriteTime: "2026-04-16 00:46:30",
};

// get —— 收藏分页（?current=1&size=10）
const favoritePagePath = "/epicScript/favorite/page";
// data: PageResult<EpicScriptResponse>

// get —— 检查单篇是否已收藏（?scriptId=xxx）
const favoriteCheckPath = "/epicScript/favorite/check";
// data: ScriptFavoriteResponse（此接口不返回 favoriteTime）
```

### 响应体 `EpicScriptResponse`

```ts
const script = {
  id: "", // 主键，字符串
  createTime: "", // "2026-04-16 00:46:30"
  updateTime: "",
  userId: "",
  title: "", // 标题
  theme: "", // 主题 / 心愿
  style: "", // 文风
  length: "", // 篇幅：short / medium / long
  plotIntro: "", // 序幕：低谷回响
  plotTurning: "", // 转折：契机出现
  plotClimax: "", // 高潮：命运抉择
  plotEnding: "", // 结局：新的开始
  conversationId: "", // 关联会话 id
  currentVersionMessageId: "", // 当前生效版本的消息 id
  plotJson: {}, // 扩展 JSON，常见键见下
  isSelected: false, // 是否为当前选中剧本
};

// plotJson 常见键（客户端约定，非服务端强约束）
const plotJson = {
  fullContent: "", // 剧本全文（Markdown）
  conversationId: "",
  parentScriptId: "",
  revisionIndex: 0,
  mode: "", // custom / inspiration …
  prompt: "",
};
```

### 正文与摘要的拼装规则

**列表不能直接拿某一个字段当摘要**，得按下面的顺序拼：

1. 优先取 `plotJson.fullContent`；
2. 缺失时用四段式拼接：

```
【序幕：低谷回响】\n{plotIntro}

【转折：契机出现】\n{plotTurning}

【高潮：命运抉择】\n{plotClimax}

【结局：新的开始】\n{plotEnding}
```

3. 去掉 Markdown 符号后取前 90 字作为列表摘要。

### ⚠️ 契约缺口

- **列表响应里没有 `isFavorited`**。要在列表上显示收藏星标，只能另外拉一次
  `/epicScript/favorite/page` 拿到已收藏的 id 集合再套上去（客户端已这么做，
  见 `StoryHistoryRepository.fetchFavoriteIds`，且只探测第一页）。
  后端在 `EpicScriptResponse` 里补上 `isFavorited` 后应立即改掉这个绕法。
- **列表响应里没有"生成状态"**（生成中 / 失败）。分页拿到的都是已落库的成稿，
  所以历史列表不表达状态；此前 mock 版里的"生成中/失败"是凭空假设的，已随 mock 一起删除。
