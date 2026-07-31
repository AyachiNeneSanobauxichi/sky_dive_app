import "dart:async";

import "package:dio/dio.dart";
import "package:happy_os/core/error/app_exception.dart";
import "package:happy_os/core/network/sse/index.dart";

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

  /// SSE 长连接：把服务端持续推送的事件以流的形式交给上层（AI 流式生成的通道）。
  ///
  /// 与普通 [post] 的四处关键差异：
  /// 1. `responseType: stream`——拿到原始字节流，不等 body 收完。`ResponseInterceptor`
  ///    只解包 `Map` 类型的 data，这里 data 是 `ResponseBody`，会原样放行，不冲突。
  /// 2. `receiveTimeout: Duration.zero`（即不限时）——**长连接绝不能吃接收超时**。
  ///    模型思考 30 秒不代表连接坏了，用默认的 15 秒会把正常生成掐死。
  /// 3. 错误分两段：建连阶段失败走 `DioException`；连上之后中途断开走流的 error
  ///    通道（Dio 不再包装），两段都要收敛成 `AppException`。
  /// 4. 主动取消（用户点"停止生成"）不是错误，正常收流即可。
  ///
  /// 上层拿到的是协议层事件，业务哨兵（如 `[DONE]`）由 feature 的 DataSource 识别。
  Stream<SseEvent> postSse(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async* {
    try {
      final res = await _dio.post<ResponseBody>(
        path,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration.zero,
          headers: const {"Accept": "text/event-stream"},
        ),
      );
      final body = res.data;
      if (body == null) throw const ParseException();
      yield* SseDecoder.decode(body.stream);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return; // 主动停止，正常结束
      final err = e.error;
      throw err is AppException ? err : const UnknownException();
    } on AppException {
      rethrow;
    } on Object catch (_) {
      // 已建连后 socket 断开 / 解码失败等：Dio 不再包装成 DioException
      throw const NetworkException();
    }
  }

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
