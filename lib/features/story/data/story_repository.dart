import "dart:async";

import "package:dio/dio.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story/data/mock/mock_story_stream.dart";
import "package:happy_os/features/story/data/story_remote_data_source.dart";

/// 故事仓库：向 controller 暴露文本增量流，并把技术异常收敛成 [Failure]。
///
/// 流式场景下「异常收敛」比普通请求麻烦一点：错误不是 `throw` 出来的，而是从
/// **流的 error 通道**送来的，所以要用 `StreamTransformer` 在管道上转换，
/// 不能靠 try/catch。
class StoryRepository {
  const StoryRepository(this._remote, {this.useMock = true});

  final StoryRemoteDataSource _remote;

  /// 是否走 mock 数据源。
  ///
  // TODO(story): 后端 /story/generate 上线后改默认值为 false 并删掉 data/mock/。
  final bool useMock;

  /// 生成故事，返回文本增量流（未做节奏整形——匀速吐字属于展示层，由 controller 加）。
  Stream<String> generate({
    required String experience,
    CancelToken? cancelToken,
  }) {
    final source = useMock
        ? MockStoryStream.generate(experience: experience)
        : _remote.generate(experience: experience, cancelToken: cancelToken);
    return _guard(source);
  }

  /// 把流中的 [AppException] 换成面向 UI 的 [Failure]，其余错误原样透传。
  Stream<String> _guard(Stream<String> source) {
    return source.transform(
      StreamTransformer<String, String>.fromHandlers(
        handleError: (error, stackTrace, sink) {
          sink.addError(
            error is AppException ? error.toFailure() : error,
            stackTrace,
          );
        },
      ),
    );
  }
}
