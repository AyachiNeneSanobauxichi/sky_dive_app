import "package:flutter/foundation.dart";
import "package:speech_to_text/speech_recognition_error.dart";
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";

/// 端侧语音识别门面。
///
/// 业务层只依赖本类，不直接碰 `speech_to_text`——和 `DioClient` 之于 `Dio` 是同一个
/// 关系：插件的 API 面很大（一堆已废弃的重载参数、平台差异、初始化时序），全铺给
/// 调用方会让每个入口各写一套时序处理，且换库时要改遍所有页面。
///
/// ## 识别在端上做，不经后端
/// iOS 走 Speech 框架、Android 走 SpeechRecognizer，都是系统能力：不花钱、无网络往返、
/// 有实时中间结果。代价是识别质量取决于设备与系统语言包，且**必须先拿到权限**。
///
/// ## 生命周期约定
/// [prepare] → [start] → ([stop] 保留结果 | [cancel] 丢弃结果)。
/// 每次 [start] 都必须以 stop / cancel 收尾，否则麦克风会一直占着。
class SpeechRecognizer {
  SpeechRecognizer([SpeechToText? speech]) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  /// 平台侧回调过来的最后一次错误。用来在 [prepare] 失败时区分"没权限"和"不支持"。
  SpeechRecognitionError? _lastError;

  /// 本次会话是否已被 [cancel]。取消后仍可能有一帧迟到的识别结果推上来，
  /// 靠它挡掉——否则"上滑取消"会在松手后又把文字塞回输入框。
  bool _cancelled = false;

  bool get isListening => _speech.isListening;

  /// 初始化 + 申请权限。可重复调用：已就绪时直接返回，不会重复弹窗。
  Future<SpeechAvailability> prepare() async {
    _lastError = null;
    final ok = await _speech.initialize(
      onError: (error) => _lastError = error,
      // 状态回调这里不用（结束时机由 [start] 的 onDone 传给调用方），
      // 但必须挂上：不挂的话插件内部拿不到状态流转，isListening 会不准。
      onStatus: (_) {},
    );
    if (ok) return SpeechAvailability.ready;

    // initialize 只返回一个 bool，失败原因得自己判：权限是用户能解决的
    // （引导去设置），设备不支持是解决不了的（该把入口藏起来）。两者给的
    // 出路完全不同，不能笼统报一句"语音不可用"。
    final granted = await _speech.hasPermission;
    final denied =
        !granted ||
        (_lastError?.errorMsg.contains(_permissionErrorKeyword) ?? false);
    return denied
        ? SpeechAvailability.permissionDenied
        : SpeechAvailability.unavailable;
  }

  /// 开始识别。返回非 [SpeechAvailability.ready] 时**没有开始**，调用方据此给提示。
  ///
  /// [onTranscript] 会被调用很多次（每识别出几个字就来一次），调用方应当把它当成
  /// "当前这句话的最新全文"覆盖显示，而不是往后追加。
  Future<SpeechAvailability> start({
    required ValueChanged<SpeechTranscript> onTranscript,
    String? preferredLocaleId,
    ValueChanged<double>? onSoundLevel,
    VoidCallback? onDone,
  }) async {
    final availability = await prepare();
    if (availability != SpeechAvailability.ready) return availability;

    _cancelled = false;
    final localeId = await _resolveLocaleId(preferredLocaleId);

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        if (_cancelled) return;
        onTranscript(
          SpeechTranscript(
            text: result.recognizedWords,
            isFinal: result.finalResult,
          ),
        );
      },
      onSoundLevelChange: onSoundLevel == null
          ? null
          : (level) {
              if (!_cancelled) onSoundLevel(level);
            },
      listenOptions: SpeechListenOptions(
        // 中间结果是这套交互的命脉：用户要边说边看见字长出来，
        // 只给最终结果的话，说话过程中界面是死的。
        partialResults: true,
        // dictation 而不是默认的 confirmation：用户说的是一段经历，不是一个短指令。
        listenMode: ListenMode.dictation,
        // iOS 侧自动加标点。写作类输入里，一段没有标点的长句几乎没法直接用。
        autoPunctuation: true,
        // 永久性错误（如权限被吊销）直接结束会话，避免卡在"正在听"。
        cancelOnError: true,
        localeId: localeId,
        listenFor: _maxSession,
        pauseFor: _maxSilence,
      ),
    );

    // 平台侧自己停下来（说到超时 / 静音过久 / 出错）时通知调用方退出进行态。
    // 没有这一路，用户会看着"正在听"却怎么说都没反应。
    _speech.statusListener = (status) {
      if (status == SpeechToText.doneStatus && !_cancelled) onDone?.call();
    };
    return SpeechAvailability.ready;
  }

  /// 正常结束：保留已识别的内容，平台侧还会补最后一帧最终结果。
  Future<void> stop() async {
    if (!_speech.isListening) return;
    await _speech.stop();
  }

  /// 取消：丢弃这次会话。之后迟到的识别结果一律不再回调。
  Future<void> cancel() async {
    _cancelled = true;
    if (!_speech.isListening) return;
    await _speech.cancel();
  }

  /// 挑一个识别用的 locale。
  ///
  /// 传进来的是 app 的 locale（如 `zh_CN`），但设备装了哪些语言包由系统决定，
  /// 传一个没装的 id 在部分机型上会直接报错而不是回落。所以先在支持列表里找：
  /// 完全匹配 > 同语种（`zh` 匹配到 `zh_CN`/`zh_TW`）> 交给系统默认（返回 null）。
  Future<String?> _resolveLocaleId(String? preferred) async {
    if (preferred == null || preferred.isEmpty) return null;
    final wanted = _normalizeLocale(preferred);
    final available = await _speech.locales();
    if (available.isEmpty) return null;

    for (final locale in available) {
      if (_normalizeLocale(locale.localeId) == wanted) return locale.localeId;
    }
    final language = wanted.split("_").first;
    for (final locale in available) {
      if (_normalizeLocale(locale.localeId).startsWith("${language}_")) {
        return locale.localeId;
      }
    }
    return null;
  }

  /// 平台之间分隔符不统一（iOS 给 `zh-CN`、Android 给 `zh_CN`），比较前先抹平。
  static String _normalizeLocale(String id) =>
      id.replaceAll("-", "_").toLowerCase();

  /// 页面销毁时调用：麦克风是独占资源，不主动放会一直占着。
  void dispose() {
    _cancelled = true;
    _speech.cancel();
  }
}

/// 一次识别推送：当前这句话的最新全文 + 是不是最终结果。
@immutable
class SpeechTranscript {
  const SpeechTranscript({required this.text, required this.isFinal});

  /// 当前会话已识别出的全文（不是增量）。
  final String text;

  /// 平台已确认这句话说完了。之后不会再有针对这句的修正。
  final bool isFinal;
}

/// 语音识别能不能用。三种结果对应三种完全不同的出路，不要合并。
enum SpeechAvailability {
  /// 可以开始。
  ready,

  /// 用户拒绝了麦克风 / 语音识别权限——引导去系统设置。
  permissionDenied,

  /// 设备或系统不支持（没装语言包、无识别服务）——这条路走不通，别再劝。
  unavailable,
}

/// 平台错误里表示权限问题的关键字（Android 给 `error_permission`，iOS 类似）。
const String _permissionErrorKeyword = "permission";

/// 单次会话上限。超过就自动收尾——不设上限的话，用户把手机揣兜里麦克风会一直开着。
const Duration _maxSession = Duration(seconds: 60);

/// 静音多久算说完了。给得比系统默认宽松些：用户组织语言时的停顿不该被当成结束。
const Duration _maxSilence = Duration(seconds: 5);
