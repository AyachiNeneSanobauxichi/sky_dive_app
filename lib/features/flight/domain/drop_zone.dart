import "package:freezed_annotation/freezed_annotation.dart";

part "drop_zone.freezed.dart";

/// 跳伞地点（drop zone）。
///
/// 一条航线必须挂在某个跳伞点上：同一天同一架飞机可能在不同场地飞，
/// 客人认的是"去哪儿跳"，运营方排班认的也是场地——没有场地的航线无法执行。
///
/// [area] 是行政区（都道府県）。名称大多是当地俱乐部名，客人未必分得清，
/// 列表里"名称 · 地区"一起给，比只给名称少一次追问。
@freezed
abstract class DropZone with _$DropZone {
  const factory DropZone({
    required String id,
    required String name,

    /// 所在都道府県（如「群馬県」）。缺失时 UI 只展示名称。
    String? area,
  }) = _DropZone;

  const DropZone._();

  /// 搜索用的可匹配文本。
  String get searchText => "$name ${area ?? ""}";
}
