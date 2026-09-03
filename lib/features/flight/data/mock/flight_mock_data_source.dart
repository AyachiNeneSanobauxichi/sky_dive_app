import "dart:convert";

import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/flight/data/flight_data_source.dart";
import "package:sky_dive/features/flight/domain/index.dart";

/// 假航线服务（内存版排班系统）。
///
/// 它不只是"返回一串假数据"，而是把**服务端该守的规则**也守住了：名额满不许再
/// 塞人、同一个人不许排两次、上限不许改到低于已分配人数、删掉的航线再操作就
/// 报"不存在"。规则只写在 UI 里的话，接真后端那天才会发现两边判断不一致，
/// 而那时错误路径已经没人测得动了。
///
/// 另外 `fetchLoads` 每 [_failEvery] 次故意失败一次——错误态不给它复现机会，
/// 就等于没实现（同 `WeatherMockDataSource`）。写操作**不**随机失败：
/// 用户填完一整张表被随机丢弃，是在惩罚用户而不是在测错误态。
///
// TODO(flight): 接入真实后端后删除整个 `data/mock/` 目录，并把
//   `flightDataSourceProvider` 换回 `FlightRemoteDataSource`。
class FlightMockDataSource implements FlightDataSource {
  FlightMockDataSource();

  /// 读请求计数（只用于制造周期性失败）。static 是必要的：provider 重建时
  /// 不该把计数清零，否则失败永远轮不到。
  static int _reads = 0;

  /// 自增 id 序号。
  static int _seq = 0;

  /// 内存库。static 让它在 provider 重建后依然存活——mock 期间用户新建的航线
  /// 不该因为切了个页面就蒸发。
  static final List<Map<String, dynamic>> _loads = _seedLoads();

  @override
  Future<List<Map<String, dynamic>>> fetchLoads() async {
    await _delay();
    _reads++;
    if (_reads % _failEvery == 0) throw const NetworkException();
    return _loads.map(_clone).toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchDropZones() async {
    await _delay();
    return _dropZones.map(_clone).toList(growable: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRoster() async {
    await _delay();
    return _roster.map(_clone).toList(growable: false);
  }

  @override
  Future<Map<String, dynamic>> createLoad(Map<String, dynamic> body) async {
    await _delay();
    final load = <String, dynamic>{
      "id": "load_${++_seq}_${DateTime.now().millisecondsSinceEpoch}",
      "code": body["code"],
      "dropZone": _clone(_requireDropZone(body["dropZoneId"] as String)),
      "departureAt": body["departureAt"],
      "aircraft": body["aircraft"],
      "altitudeFt": body["altitudeFt"],
      "customerCapacity": body["customerCapacity"],
      "photographerCapacity": body["photographerCapacity"],
      "participants": <Map<String, dynamic>>[],
    };
    _loads.add(load);
    return _clone(load);
  }

  @override
  Future<Map<String, dynamic>> updateLoad(
    String loadId,
    Map<String, dynamic> body,
  ) async {
    await _delay();
    final load = _requireLoad(loadId);

    // 名额不能改到低于已分配人数：否则名单上会有人"没有位置"。
    _requireCapacityFitsAssigned(
      load,
      ParticipantRole.customer,
      body["customerCapacity"] as int,
    );
    _requireCapacityFitsAssigned(
      load,
      ParticipantRole.photographer,
      body["photographerCapacity"] as int,
    );

    load
      ..["code"] = body["code"]
      ..["dropZone"] = _clone(_requireDropZone(body["dropZoneId"] as String))
      ..["departureAt"] = body["departureAt"]
      ..["aircraft"] = body["aircraft"]
      ..["altitudeFt"] = body["altitudeFt"]
      ..["customerCapacity"] = body["customerCapacity"]
      ..["photographerCapacity"] = body["photographerCapacity"];
    return _clone(load);
  }

  @override
  Future<void> deleteLoad(String loadId) async {
    await _delay();
    _requireLoad(loadId);
    _loads.removeWhere((load) => load["id"] == loadId);
  }

  @override
  Future<Map<String, dynamic>> assignParticipant(
    String loadId,
    Map<String, dynamic> body,
  ) async {
    await _delay();
    final load = _requireLoad(loadId);
    final participantId = body["participantId"] as String;
    final role = ParticipantRole.fromRaw(body["role"] as String?);
    final participants = _participantsOf(load);

    if (participants.any((p) => p["id"] == participantId)) {
      throw const BusinessException(code: LoadErrorCode.alreadyAssigned);
    }
    if (_countOf(load, role) >= _capacityOf(load, role)) {
      throw const BusinessException(code: LoadErrorCode.loadFull);
    }

    // 候选池里没有这个人时，用请求里带的名字建一条：客人自助预约走的就是
    // 这条路（客人不在运营的候选池里）。真后端按 id 查用户表，查不到才 404。
    final person = _roster
        .where((p) => p["id"] == participantId)
        .map(_clone)
        .firstOrNull;
    if (person == null && body["name"] == null) {
      throw const ServerException(statusCode: 404);
    }
    participants.add(<String, dynamic>{
      ...?person,
      "id": participantId,
      "name": person?["name"] ?? body["name"],
      "detail": person?["detail"] ?? body["detail"],
      "role": role.raw,
    });
    load["participants"] = participants;
    return _clone(load);
  }

  @override
  Future<Map<String, dynamic>> removeParticipant(
    String loadId,
    String participantId,
  ) async {
    await _delay();
    final load = _requireLoad(loadId);
    final participants = _participantsOf(load)
      ..removeWhere((p) => p["id"] == participantId);
    load["participants"] = participants;
    return _clone(load);
  }

  @override
  Future<Map<String, dynamic>> reorderParticipants(
    String loadId,
    Map<String, dynamic> body,
  ) async {
    await _delay();
    final load = _requireLoad(loadId);
    final participants = _participantsOf(load);
    final requested = (body["participantIds"] as List<dynamic>).cast<String>();

    // 只认"确实在名单上"的 id：客户端与服务端可能差着一次分配，
    // 拿一个不存在的 id 去重排会把整次操作搞崩，不如忽略它。
    final ids = requested
        .where((id) => participants.any((p) => p["id"] == id))
        .toList(growable: false);

    // 关键：**只在这些人原本占据的下标上**按新顺序填回，别的人原地不动。
    // 否则给顾客排一次序，会把摄影师全挤到名单末尾。
    final slots = <int>[];
    for (var i = 0; i < participants.length; i++) {
      if (ids.contains(participants[i]["id"])) slots.add(i);
    }
    final moved = <Map<String, dynamic>>[
      for (final id in ids) participants.firstWhere((p) => p["id"] == id),
    ];
    for (var k = 0; k < slots.length; k++) {
      participants[slots[k]] = moved[k];
    }

    load["participants"] = participants;
    return _clone(load);
  }

  // ───────────────────────── 内部工具 ─────────────────────────

  Map<String, dynamic> _requireLoad(String loadId) => _loads.firstWhere(
    (load) => load["id"] == loadId,
    // 多半是别人（或上一屏）刚把它删了，本地列表还没刷新。
    orElse: () =>
        throw const BusinessException(code: LoadErrorCode.loadNotFound),
  );

  Map<String, dynamic> _requireDropZone(String dropZoneId) =>
      _dropZones.firstWhere(
        (zone) => zone["id"] == dropZoneId,
        orElse: () => throw const ServerException(statusCode: 422),
      );

  void _requireCapacityFitsAssigned(
    Map<String, dynamic> load,
    ParticipantRole role,
    int capacity,
  ) {
    if (capacity < _countOf(load, role)) {
      throw const BusinessException(code: LoadErrorCode.capacityBelowAssigned);
    }
  }

  List<Map<String, dynamic>> _participantsOf(Map<String, dynamic> load) =>
      (load["participants"] as List<dynamic>).cast<Map<String, dynamic>>();

  int _countOf(Map<String, dynamic> load, ParticipantRole role) =>
      _participantsOf(load).where((p) => p["role"] == role.raw).length;

  int _capacityOf(Map<String, dynamic> load, ParticipantRole role) =>
      switch (role) {
        ParticipantRole.customer => load["customerCapacity"] as int,
        ParticipantRole.photographer => load["photographerCapacity"] as int,
      };

  /// 深拷贝：内存库直接把引用交出去的话，UI 改一下就"写进了服务端"，
  /// 那 mock 就再也测不出"改了但没保存"这类 bug 了。
  Map<String, dynamic> _clone(Map<String, dynamic> source) =>
      jsonDecode(jsonEncode(source)) as Map<String, dynamic>;

  static Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 620));

  /// 每 N 次读请求失败一次，给错误态一个稳定的复现路径。
  static const int _failEvery = 6;

  // ───────────────────────── 种子数据 ─────────────────────────

  static final List<Map<String, dynamic>> _dropZones = <Map<String, dynamic>>[
    <String, dynamic>{
      "id": "dz_fujioka",
      "name": "藤岡スカイダイビングクラブ",
      "area": "群馬県",
    },
    <String, dynamic>{"id": "dz_sekiyado", "name": "関宿滑空場", "area": "千葉県"},
    <String, dynamic>{"id": "dz_ishigaki", "name": "石垣島ドロップゾーン", "area": "沖縄県"},
  ];

  static final List<Map<String, dynamic>> _roster = <Map<String, dynamic>>[
    <String, dynamic>{
      "id": "person_01",
      "name": "佐藤 美咲",
      "role": "customer",
      "detail": "体験ジャンプ · 初回",
    },
    <String, dynamic>{
      "id": "person_02",
      "name": "田中 健一",
      "role": "customer",
      "detail": "ライセンス B · 84 回",
    },
    <String, dynamic>{
      "id": "person_03",
      "name": "Emily Carter",
      "role": "customer",
      "detail": "Tandem · first jump",
    },
    <String, dynamic>{
      "id": "person_04",
      "name": "山本 陽向",
      "role": "customer",
      "detail": "AFF Level 4",
    },
    <String, dynamic>{
      "id": "person_05",
      "name": "李 明",
      "role": "customer",
      "detail": "体验跳 · 首次",
    },
    <String, dynamic>{
      "id": "person_06",
      "name": "中村 拓海",
      "role": "customer",
      "detail": "ライセンス D · 612 回",
    },
    <String, dynamic>{
      "id": "person_07",
      "name": "小林 遥",
      "role": "photographer",
      "detail": "ハンドカム + ヘルメット",
    },
    <String, dynamic>{
      "id": "person_08",
      "name": "Marco Rossi",
      "role": "photographer",
      "detail": "Outside video",
    },
    <String, dynamic>{
      "id": "person_09",
      "name": "渡辺 さくら",
      "role": "photographer",
      "detail": "ハンドカム",
    },
  ];

  /// 种子航线：**相对今天**生成，不写死日期。
  ///
  /// 刻意覆盖四种长相：已起飞（今天早上）、名额已满、名额半空、明天的空名单。
  /// 全是"还剩几位"的话，满员角标和已起飞的灰态永远没人眼看过一次。
  static List<Map<String, dynamic>> _seedLoads() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    Map<String, dynamic> person(String id, ParticipantRole role) {
      final source = _roster.firstWhere((p) => p["id"] == id);
      return <String, dynamic>{
        ...jsonDecode(jsonEncode(source)) as Map<String, dynamic>,
        "role": role.raw,
      };
    }

    return <Map<String, dynamic>>[
      <String, dynamic>{
        "id": "load_seed_1",
        "code": "L-201",
        "dropZone": _dropZones[0],
        "departureAt": today.add(const Duration(hours: 8)).toIso8601String(),
        "aircraft": "Cessna 208B",
        "altitudeFt": 14000,
        "customerCapacity": 6,
        "photographerCapacity": 2,
        "participants": <Map<String, dynamic>>[
          person("person_02", ParticipantRole.customer),
          person("person_06", ParticipantRole.customer),
          person("person_07", ParticipantRole.photographer),
        ],
      },
      <String, dynamic>{
        "id": "load_seed_2",
        "code": "L-204",
        "dropZone": _dropZones[0],
        "departureAt": today
            .add(const Duration(hours: 13, minutes: 30))
            .toIso8601String(),
        "aircraft": "Cessna 208B",
        "altitudeFt": 14000,
        // 满员航线：客人看到的是"满员"，运营方看到的是"不能再塞人"。
        "customerCapacity": 3,
        "photographerCapacity": 1,
        "participants": <Map<String, dynamic>>[
          person("person_01", ParticipantRole.customer),
          person("person_03", ParticipantRole.customer),
          person("person_04", ParticipantRole.customer),
          person("person_09", ParticipantRole.photographer),
        ],
      },
      <String, dynamic>{
        "id": "load_seed_3",
        "code": "S-102",
        "dropZone": _dropZones[1],
        "departureAt": today
            .add(const Duration(hours: 15, minutes: 15))
            .toIso8601String(),
        "aircraft": "Pilatus PC-6",
        "altitudeFt": 12000,
        "customerCapacity": 8,
        "photographerCapacity": 2,
        "participants": <Map<String, dynamic>>[
          person("person_05", ParticipantRole.customer),
        ],
      },
      <String, dynamic>{
        "id": "load_seed_4",
        "code": "IS-01",
        "dropZone": _dropZones[2],
        "departureAt": today
            .add(const Duration(days: 1, hours: 10))
            .toIso8601String(),
        "aircraft": "Cessna 182",
        "altitudeFt": 10000,
        "customerCapacity": 4,
        "photographerCapacity": 1,
        "participants": <Map<String, dynamic>>[],
      },
    ];
  }
}
