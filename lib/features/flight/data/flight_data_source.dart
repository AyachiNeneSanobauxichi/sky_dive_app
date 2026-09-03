/// 航线数据源契约。
///
/// 抽这一层只为了 mock：后端未就绪时用 `FlightMockDataSource` 顶上，
/// 上面的仓库 / 控制器 / 页面一行都不用改（见 `AuthDataSource` 的同款说明）。
/// 方法一律收发原始 JSON，DTO ↔ Entity 的映射归仓库管。
abstract interface class FlightDataSource {
  /// 取全部航线（含名单）。
  Future<List<Map<String, dynamic>>> fetchLoads();

  /// 取可选的跳伞地点。新建 / 编辑航线的地点选择器要用。
  Future<List<Map<String, dynamic>>> fetchDropZones();

  /// 取可被分配的人（顾客 + 摄影师候选池）。
  Future<List<Map<String, dynamic>>> fetchRoster();

  /// 新建航线，返回新建后的完整航线。
  Future<Map<String, dynamic>> createLoad(Map<String, dynamic> body);

  /// 编辑航线，返回更新后的完整航线。
  Future<Map<String, dynamic>> updateLoad(
    String loadId,
    Map<String, dynamic> body,
  );

  /// 删除航线。
  Future<void> deleteLoad(String loadId);

  /// 把某人分配到航线，返回更新后的完整航线。
  ///
  /// 返回整条航线而不是"新加的那个人"：名额、名单顺序都可能被这次分配改变，
  /// 只回一个人的话客户端得自己拼状态，拼错就和服务端不一致了。
  Future<Map<String, dynamic>> assignParticipant(
    String loadId,
    Map<String, dynamic> body,
  );

  /// 把某人从航线名单移除，返回更新后的完整航线。
  Future<Map<String, dynamic>> removeParticipant(
    String loadId,
    String participantId,
  );

  /// 重排名单顺序（= 登机 / 出舱顺序），返回更新后的完整航线。
  ///
  /// body 里只带**某一个角色**的完整顺序：顾客和摄影师是分开两组展示、
  /// 分开拖的，一次重排不该动到另一组的位置。
  Future<Map<String, dynamic>> reorderParticipants(
    String loadId,
    Map<String, dynamic> body,
  );
}
