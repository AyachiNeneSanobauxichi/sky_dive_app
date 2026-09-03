import "package:sky_dive/features/flight/domain/index.dart";

/// 骨架屏用的占位航线。
///
/// 字段长度贴近真实值（日文场地名、四位代号、五位数高度），骨架条的宽度才不会
/// 失真——占位数据写成 "aaa" 的骨架屏，加载完会明显"抖"一下。
///
/// 列表页与详情页共用同一份，两处的骨架长相才一致。
Load placeholderLoad(DateTime now) => Load(
  id: "placeholder",
  code: "L-204",
  dropZone: const DropZone(
    id: "placeholder",
    name: "藤岡スカイダイビングクラブ",
    area: "群馬県",
  ),
  departureAt: now,
  aircraft: "Cessna 208B",
  altitudeFt: LoadRules.defaultAltitudeFt,
  customerCapacity: LoadRules.defaultCustomerCapacity,
  photographerCapacity: LoadRules.defaultPhotographerCapacity,
  participants: const <LoadParticipant>[
    LoadParticipant(
      id: "placeholder_1",
      name: "佐藤 美咲",
      role: ParticipantRole.customer,
      detail: "体験ジャンプ · 初回",
    ),
    LoadParticipant(
      id: "placeholder_2",
      name: "小林 遥",
      role: ParticipantRole.photographer,
      detail: "ハンドカム",
    ),
  ],
);
