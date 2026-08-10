import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_history/domain/index.dart";

part "story_script_dto.freezed.dart";
part "story_script_dto.g.dart";

/// `EpicScriptResponse`（`story-history.api.md` v1）。
///
/// 除 [id] 外全部可空：这些数据是多个端写进去的，早期剧本缺标题、缺四段式的都有，
/// 少一个字段不该让整页历史打不开。
@freezed
abstract class StoryScriptDto with _$StoryScriptDto {
  const StoryScriptDto._();

  const factory StoryScriptDto({
    required String id,
    String? title,
    String? theme,
    String? style,
    String? length,

    /// 四段式剧情。[plotJson] 里没有全文时靠它们拼。
    String? plotIntro,
    String? plotTurning,
    String? plotClimax,
    String? plotEnding,
    String? conversationId,
    String? currentVersionMessageId,

    /// 扩展 JSON。全文藏在 `fullContent` 里（客户端约定，不是强约束）。
    Map<String, dynamic>? plotJson,
    String? createTime,
    String? updateTime,
  }) = _StoryScriptDto;

  factory StoryScriptDto.fromJson(Map<String, dynamic> json) =>
      _$StoryScriptDtoFromJson(json);

  /// [isFavorited] 由调用方给：列表接口不带这个字段，是仓库另外探来的
  /// （见 `story-history.api.md` 的契约缺口）。
  StoryScript toEntity({bool isFavorited = false}) {
    final content = _fullContent();
    return StoryScript(
      id: id,
      // 标题缺失时退到心愿，再缺就交给 UI 兜底文案——这里不塞中文默认值，
      // 那是展示层的事（红线 #9）。
      title: _firstNonEmpty(<String?>[title, theme]) ?? "",
      summary: _summaryOf(content),
      createdAt: _parseTime(createTime) ?? DateTime.now(),
      theme: _trimToNull(theme),
      content: content,
      conversationId: _firstNonEmpty(<String?>[
        conversationId,
        plotJson?["conversationId"] as String?,
      ]),
      isFavorited: isFavorited,
    );
  }

  /// 全文：优先 `plotJson.fullContent`，缺失时按四段式拼。
  ///
  /// 顺序是契约规定的（`story-history.api.md`）——反过来会让改过版本的剧本显示成旧的
  /// 四段草稿，因为服务端只把最新全文写进 `fullContent`。
  String? _fullContent() {
    final full = plotJson?["fullContent"];
    if (full is String && full.trim().isNotEmpty) return full;

    final acts = <String>[
      for (final (label, text) in <(String, String?)>[
        (_actIntro, plotIntro),
        (_actTurning, plotTurning),
        (_actClimax, plotClimax),
        (_actEnding, plotEnding),
      ])
        if ((text ?? "").trim().isNotEmpty) "$label\n${text!.trim()}",
    ];
    return acts.isEmpty ? null : acts.join("\n\n");
  }

  /// 列表摘要：去掉 Markdown 符号与换行后取前 [_summaryLength] 字。
  ///
  /// 不去符号的话，摘要经常以 `## 【序幕` 开头——列表上那一行会变成一串井号。
  static String _summaryOf(String? content) {
    if (content == null) return "";
    final plain = content
        .replaceAll(_markdownNoise, " ")
        .replaceAll(_whitespaceRun, " ")
        .trim();
    // 按 **rune** 截断而不是 code unit：中文没问题，但 emoji 是代理对，
    // 按 code unit 切会切出半个字符（渲染成一个乱码方块）。
    // 没上 `characters`（字素簇）是因为那要多引一个包，而摘要差一格无伤大雅。
    final runes = plain.runes.toList(growable: false);
    return runes.length <= _summaryLength
        ? plain
        : "${String.fromCharCodes(runes.take(_summaryLength))}…";
  }

  static String? _firstNonEmpty(List<String?> candidates) {
    for (final value in candidates) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  static String? _trimToNull(String? value) => _firstNonEmpty(<String?>[value]);

  /// 宽松解析服务端时间串（`2026-04-16 00:46:30`）。解析不了就当没有。
  static DateTime? _parseTime(String? raw) =>
      (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);
}

/// 四段式的小标题。**是数据不是文案**：拼出来的全文会原样存进 `content`，
/// 也会被当作摘要来源，和界面语言无关。
const String _actIntro = "【序幕：低谷回响】";
const String _actTurning = "【转折：契机出现】";
const String _actClimax = "【高潮：命运抉择】";
const String _actEnding = "【结局：新的开始】";

/// 列表摘要的字数。约等于卡片上两行的容量。
const int _summaryLength = 90;

/// 摘要里要抹掉的 Markdown 记号：标题井号、强调星号/下划线、行内代码、引用与列表符。
final RegExp _markdownNoise = RegExp(
  r"[#*_`>~\-]+|!\[.*?\]\(.*?\)|\[|\]\(.*?\)",
);

/// 连续空白（含换行）压成一个空格。
final RegExp _whitespaceRun = RegExp(r"\s+");
