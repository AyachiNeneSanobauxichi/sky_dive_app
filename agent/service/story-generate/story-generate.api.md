# story-generate api

## v1

- 本模块对接**短篇小说生成服务**（后端是外部 short-novel-service 的 SSE 代理）。一次生成是一条**多轮会话**：心愿 → 澄清问答 → 大纲确认/修改 → 流式正文 → 落库成剧本。
- 两个端点都是 **SSE（`Content-Type: text/event-stream`）**，均需鉴权（`Authorization: Bearer <accessToken>`，由 `AuthInterceptor` 注入）；未登录后端直接抛业务异常。
- 两个端点的**事件流格式完全一致**，只是入口不同：`/shortNovel/stream` 开新会话，`/shortNovel/followup` 推进已有会话。
- ⚠️ SSE 响应**不走统一信封** `{code,message,data}`，每帧 `data:` 就是事件对象本体。信封只在建连失败（HTTP 4xx/5xx）时出现。
- ⚠️ 服务端会在每个事件后补发一帧空注释（`:` 开头）用于 flush，按 SSE 协议忽略即可。上游还可能发 `data: [DONE]`，同样忽略。

### 发起生成

```ts
// post  (SSE)
const path = "/shortNovel/stream";

const request = {
  query: string, // 必填。用户的心愿文本（故事页输入框那段话）
};
```

### 推进会话

```ts
// post  (SSE)
const path = "/shortNovel/followup";

const request = {
  sessionId: string, // 必填。由 status 事件下发的 session_id
  action: "answer_clarification" | "confirm_outline" | "modify_outline" | "retry",
  payload: object | null, // 随 action 而定，见下表
  originalQuery: string, // 首次心愿文本。缺失时后端从 session 缓存兜底恢复
};

// action ↔ payload 对应关系
// answer_clarification -> { answer: string }   用户对澄清卡的回答
// confirm_outline      -> null                 确认大纲，开始写正文
// modify_outline       -> { feedback: string } 大纲修改意见
// retry                -> null                 恢复上次中断的会话
```

### 事件流（两个端点共用）

每帧 `event:` 名与 `data.type` 相同，解析以 `data.type` 为准（`event:` 名仅作兜底）。

```ts
// 所有事件的公共外壳
const event = {
  type: string,
  session_id: string, // 与 type 同级，不在 payload 内
  payload: object,
};
```

```ts
// type: "status"  阶段提示。仅更新加载文案，不产生对话条目
const statusPayload = {
  stage: string, // 当前阶段标识
  session_id: string, // 与外层同值，二者取其一即可
  style: string,
  length: string,
};

// type: "clarification_card"  澄清卡：AI 反问，等用户作答
const clarificationPayload = {
  card: {
    question: string,
    description: string,
    card_type: "single_select" | "multi_select" | "mixed" | "text_input",
    options: [{ value: string, label: string, description: string }],
    allow_custom: boolean, // 允许在选项之外补充自由文本
    input_placeholder: string,
    min_selections: number, // 缺省 1
    max_selections: number,
  },
};

// type: "outline_created"  大纲：等用户确认或提修改意见
const outlinePayload = {
  outline: {
    title: string,
    logline: string,
    beats: [{ order: number, title: string, summary: string }],
    ending: string,
  },
};

// type: "novel_start"  正文开始，后续 novel_delta 往这一条上累加
const novelStartPayload = {};

// type: "novel_delta"  正文增量
const novelDeltaPayload = {
  delta: string, // 增量片段，客户端自行累加
};

// type: "novel_done"  正文完成。后端此时已落库，并把三个 id 注入本 payload
const novelDonePayload = {
  full_text: string, // 全文。缺失时以累加的 delta 为准
  title: string,
  scriptId: string, // 落库后的剧本 ID
  conversationId: string,
  currentVersionMessageId: string,
};

// type: "error"  生成失败
const errorPayload = {
  code: string, // 见下方错误码
  message: string,
};
```

### 错误码

| `payload.code` | 含义 | 客户端处理 |
| --- | --- | --- |
| `DAILY_GENERATION_IN_PROGRESS` | 今天已有未完成的会话 | 留存 `session_id`，展示「继续创作」，点击后发 `action: "retry"` |
| 其余 | 通用生成失败 | 展示 `message` + 重试入口；已生成的正文保留不清屏 |
