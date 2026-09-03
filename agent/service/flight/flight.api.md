# flight api

> ⚠️ 后端尚未就绪。以下契约是**客户端先行拟定**的，当前由 `lib/features/flight/data/mock/`
> 的假后端实现（含名额、重复分配、上限下界等规则）。真实后端就绪后按此校对，
> 并把 `flightDataSourceProvider` 从 mock 换回 `FlightRemoteDataSource`、删除 `data/mock/`。

## v1

### 取航线列表

`GET /loads` · 需鉴权

```ts
// response: Load[]
interface Load {
  id: string;
  code: string;              // 航线代号 / 呼号，如 "L-204"
  dropZone: DropZone;        // 跳伞地点
  departureAt: string;       // ISO-8601 起飞时刻（本地时区）
  aircraft: string;          // 机型，如 "Cessna 208B"
  altitudeFt: number;        // 出舱高度（英尺）
  customerCapacity: number;  // 顾客名额上限
  photographerCapacity: number; // 摄影师名额上限
  participants: LoadParticipant[]; // 名单（两种角色混排）
}

interface DropZone {
  id: string;
  name: string;   // 场地名（如 "藤岡スカイダイビングクラブ"）
  area?: string;  // 都道府県
}

interface LoadParticipant {
  id: string;     // 人的主键（候选池里同一个 id）
  name: string;
  role: "customer" | "photographer";
  detail?: string; // 顾客写跳伞类型 / 执照等级，摄影师写机位
}
```

### 取跳伞地点

`GET /drop-zones` · 需鉴权 → `DropZone[]`

### 取可分配的人（候选池）

`GET /loads/roster` · 需鉴权 → `LoadParticipant[]`

### 新建 / 编辑航线

`POST /loads` · `PUT /loads/{loadId}` · 需鉴权

```ts
interface LoadRequest {
  code: string;
  dropZoneId: string;
  departureAt: string;       // ISO-8601
  aircraft: string;
  altitudeFt: number;
  customerCapacity: number;
  photographerCapacity: number;
}
// response: Load（更新后的完整航线）
```

### 删除航线

`DELETE /loads/{loadId}` · 需鉴权 → 无响应体

### 名单增删

`POST /loads/{loadId}/participants` · 需鉴权

```ts
interface AssignParticipantRequest {
  participantId: string;
  role: "customer" | "photographer";
}
// response: Load（更新后的完整航线，含名额与名单）
```

`DELETE /loads/{loadId}/participants/{participantId}` · 需鉴权 → `Load`

> 增删都返回**整条航线**而不是单个人：名额与名单顺序都可能被这次操作改变，
> 只回一个人会逼客户端自己拼状态，拼错就和服务端不一致了。

### 业务错误码（`code` 非 0 时）

| code | 含义 | 客户端表现 |
| --- | --- | --- |
| 20001 | 该角色名额已满 | 「这条航线已满，先空出名额或调高上限」 |
| 20002 | 此人已在本航线名单上 | 「这个人已经在名单上了」 |
| 20003 | 航线不存在（已被删除） | 「这条航线已经不在了」，并从本地列表移除 |
| 20004 | 名额上限低于已分配人数 | 「名额不能低于已排入的人数」 |

## v3

### 重排名单顺序

`PUT /loads/{loadId}/participants/order` · 需鉴权

```ts
interface ReorderParticipantsRequest {
  participantIds: string[];          // 该角色的**完整**新顺序
  role: "customer" | "photographer"; // 这次重排的是哪一组
}
// response: Load（更新后的完整航线）
```

- 下发整份顺序而不是「把第 3 个挪到第 1 个」这类增量指令：增量一旦和服务端的当前顺序对不上（别人刚加了个人），结果就是错的，而且很难查。整份顺序是幂等的。
- 服务端只重排**该角色**的人，另一角色在名单里的位置不动。
- 认不出的 id 忽略即可（客户端与服务端可能差着一次分配），不要整次拒绝。

### 分配名单接口增加可选的 `name` / `detail`

```ts
interface AssignParticipantRequest {
  participantId: string;
  role: "customer" | "photographer";
  name?: string;    // 此人不在运营侧候选池里时下发
  detail?: string;
}
```

- 客人**自助预约**走的就是这条路（客人不在运营的候选池里，见 `agent/service/booking/booking.api.md`）。
- 后端能按 id 查到用户时以后端数据为准，这两个字段只是兜底。
