import "dart:async";

import "package:dio/dio.dart";
import "package:sky_dive/core/error/app_exception.dart";

/// 全局唯一的网络访问入口（薄封装 Dio）。
///
/// 职责：暴露语义化的 REST 方法；把底层 `DioException` 统一收敛成项目
/// `AppException`（拦截器已在 `err.error` 里放好映射结果），让上层只需
/// `on AppException` 捕获，无需感知 Dio。DataSource 只做原始请求，
/// 解析成 Entity 由 Repository 负责（红线 #4 / skill 05）。
class DioClient {
  const DioClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) => _request(
    () => _dio.get<T>(path, queryParameters: query, cancelToken: cancelToken),
  );

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) => _request(
    () => _dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
    ),
  );

  Future<T> put<T>(String path, {Object? data, CancelToken? cancelToken}) =>
      _request(() => _dio.put<T>(path, data: data, cancelToken: cancelToken));

  Future<T> patch<T>(String path, {Object? data, CancelToken? cancelToken}) =>
      _request(() => _dio.patch<T>(path, data: data, cancelToken: cancelToken));

  Future<T> delete<T>(String path, {Object? data, CancelToken? cancelToken}) =>
      _request(
        () => _dio.delete<T>(path, data: data, cancelToken: cancelToken),
      );

  /// 统一执行 + 异常收敛：Dio 抛出的 `DioException` 里，`error` 字段已被拦截器
  /// 替换为具体 `AppException`；这里取出重抛，把「Dio 细节」挡在网络层之内。
  Future<T> _request<T>(Future<Response<T>> Function() send) async {
    try {
      final res = await send();
      // ResponseInterceptor 已把信封 data 解包并写回 response.data。
      return res.data as T;
    } on DioException catch (e) {
      final err = e.error;
      throw err is AppException ? err : const UnknownException();
    }
  }
}
