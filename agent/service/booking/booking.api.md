# booking api

> ⚠️ 后端尚未就绪。v1 刻意**不新造一套 `/bookings` 存储**：预约就是在航线名单上占一个
> 顾客位，直接复用 `flight.api.md` 的名单接口，客户端与 mock 都只有一份真源，
> 名额与名单天然一致。真实后端若把预约拆成独立资源，只需改 booking 的仓库一处。

## v1

### 预约一条航线

复用 `POST /loads/{loadId}/participants`（见 `agent/service/flight/flight.api.md`）。

```ts
interface AssignParticipantRequest {
  participantId: string;   // 当前登录用户的 id
  role: "customer";        // 客人自助预约固定占顾客位
  name?: string;           // 仅当此人不在运营侧候选池里时下发（自助预约即属此类）
  detail?: string;
}
// response: Load（更新后的完整航线，含名额与名单）
```

### 取消预约

复用 `DELETE /loads/{loadId}/participants/{participantId}`，`participantId` 为当前用户 id。

### 我的预约

v1 **不单独取**：客户端从已经加载的航线列表里筛出"名单上有我"的航线即可
（数据量在一个运营点的量级，没必要多一次请求）。

```ts
// 客户端派生：loads.filter(l => l.participants.some(p => p.id === me.id))
```

> 一旦航线量涨到需要分页，这里要换成真正的 `GET /bookings/mine`，
> 并且返回体要自带航线快照（否则"我的预约"会依赖整张航线列表被加载过）。

### 业务错误码

沿用 `flight.api.md` 的码表。客户端对客人**换一套面向客人的文案**：
`20001`（满员）对运营是"先空出名额或调高上限"，对客人是"这班刚满了，换一班试试"。
