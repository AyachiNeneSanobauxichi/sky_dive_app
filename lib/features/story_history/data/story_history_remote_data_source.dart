import "package:happy_os/core/network/index.dart";

/// story-history 远程数据源：只发原始请求、拿信封解包后的 `data`，**不做领域映射**。
///
/// 端点对齐 `agent/service/story-history/story-history.api.md` v2。
class StoryHistoryRemoteDataSource {
  const StoryHistoryRemoteDataSource(this._client);

  final DioClient _client;

  static const String _page = "/epicScript/page";
  static const String _detail = "/epicScript/detail";
  static const String _delete = "/epicScript/delete";
  static const String _favoriteToggle = "/epicScript/favorite/toggle";
  static const String _favoritePage = "/epicScript/favorite/page";

  /// 剧本分页。[length] 为 `short` / `medium` / `long`，null 表示不限篇幅。
  ///
  /// ⚠️ 参数名是 `current` / `size`，不是 `pageNum` / `pageSize`——后者绑不上后端的
  /// `BasePageRequest`，会静默退化成第一页（mini-program 就踩了这个坑，
  /// 见其 `99-已知问题.md`）。
  Future<Map<String, dynamic>> fetchPage({
    required int current,
    required int size,
    String? length,
  }) => _client.get<Map<String, dynamic>>(
    _page,
    query: <String, dynamic>{
      "current": current,
      "size": size,
      "orderBy": _orderBy,
      "orderDirection": _orderDirection,
      // 不限篇幅时**不传这个 key**（null 感知元素会整条省略），而不是传 null：
      // 后端对空值的处理没有约定，传过去有可能被当成"篇幅等于空"而筛出零条。
      "length": ?length,
    },
  );

  /// 单篇详情。列表已经带了全文，所以只在全文缺失时才用得上。
  Future<Map<String, dynamic>> fetchDetail(String id) =>
      _client.get<Map<String, dynamic>>(
        _detail,
        query: <String, dynamic>{"id": id},
      );

  /// 已收藏的剧本（只探第一页，见仓库里的说明）。
  Future<Map<String, dynamic>> fetchFavoritePage({
    required int current,
    required int size,
  }) => _client.get<Map<String, dynamic>>(
    _favoritePage,
    query: <String, dynamic>{"current": current, "size": size},
  );

  /// 删除。id 在 **query** 上（服务端 `@RequestParam`），放 body 收不到。
  ///
  /// 手拼在 path 上是因为 `DioClient.delete` 目前没有 `query` 形参（core 属 infra，
  /// 不在本模块的改动范围内）。id 是雪花号，正常不含特殊字符，仍然编码一次兜底。
  // TODO(story-history): DioClient.delete 支持 query 后改成传 map。
  Future<void> deleteScript(String id) =>
      _client.delete<void>("$_delete?id=${Uri.encodeQueryComponent(id)}");

  /// 切换收藏，返回切换**之后**的状态。
  Future<Map<String, dynamic>> toggleFavorite(String scriptId) =>
      _client.post<Map<String, dynamic>>(
        _favoriteToggle,
        data: <String, dynamic>{"scriptId": scriptId},
      );
}

/// 列表排序：按创建时间倒序。历史列表最该先看到的永远是刚写完的那篇。
const String _orderBy = "createTime";
const String _orderDirection = "desc";
