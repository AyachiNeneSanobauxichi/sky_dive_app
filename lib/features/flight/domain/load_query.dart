import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/load.dart";
import "package:sky_dive/features/flight/domain/load_sort.dart";

part "load_query.freezed.dart";

/// 航线列表的查询条件（搜索词 + 排序）。
///
/// 过滤与排序放在 domain 而不是 widget 里：这是"哪些航线该出现在列表上"的
/// 业务规则，页面只负责把结果画出来。
@freezed
abstract class LoadQuery with _$LoadQuery {
  const factory LoadQuery({
    @Default("") String keyword,
    @Default(LoadSort.departureAsc) LoadSort sort,
  }) = _LoadQuery;

  const LoadQuery._();

  /// 是否处于搜索状态（决定空态是"还没有航线"还是"没搜到"）。
  bool get hasKeyword => keyword.trim().isNotEmpty;

  /// 应用查询：先按关键词过滤，再按时间排序。
  ///
  /// 关键词按**空格分词后全部命中**（AND）：搜「藤岡 208」应该只剩藤岡场地的
  /// 208 机型那几班，而不是把两个词各自的结果并起来给一大堆。
  List<Load> apply(List<Load> loads) {
    final terms = keyword
        .toLowerCase()
        .split(RegExp(r"\s+"))
        .where((t) => t.isNotEmpty)
        .toList(growable: false);

    final filtered = terms.isEmpty
        ? List<Load>.of(loads)
        : loads.where((load) {
            final haystack = load.searchText.toLowerCase();
            return terms.every(haystack.contains);
          }).toList();

    filtered.sort(sort.compareLoads);
    return List<Load>.unmodifiable(filtered);
  }
}
