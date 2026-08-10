# story-generate-new api

## v1

- 编写生成文章的接口
- 首次进来先调 stream 接口

```ts
// post SSE
const path = "https://lifescript.happylifeos.com/api/shortNovel/stream";

const request = { query: "我叫张义明" };

// response 需要根据返回的类型生成对应的 ui 交互卡片
/*
"type":"clarification_card","payload":{"card":{"card_type":"text_input","question":"你想讲述一个什么样的故事？请简单描述一下发生了什么，或者你希望看到什么样的情节。","description":"例如：被人欺负想逆袭、职场受气想打脸、感情不顺想翻盘等。","input_placeholder":"请输入你的故事梗概或想法","round":1,"max_rounds":3,"allow_custom":true}},"timestamp":"2026-08-10T13:12:58.675533211Z","session_id":"sess_431b8218ea8b431482cb"}
*/
```
