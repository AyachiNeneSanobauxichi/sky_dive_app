/// 天气数据源契约。抽出这一层只为了 mock，见 `AuthDataSource` 的同款说明。
abstract interface class WeatherDataSource {
  /// 取默认跳伞点当天的放飞窗口。**不需要鉴权**——登录页就要用它。
  Future<Map<String, dynamic>> fetchTodayWindow();
}
