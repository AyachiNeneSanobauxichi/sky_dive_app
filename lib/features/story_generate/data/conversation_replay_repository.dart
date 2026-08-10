import "dart:convert";

import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story_generate/data/conversation_replay_remote_data_source.dart";
import "package:happy_os/features/story_generate/data/dto/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

/// 把一次已完成的创作从服务端消息列表还原成时间线（`story-generate.api.md` v4）。
///
/// 全篇的基调是**能还原多少还原多少**：这批数据是好几个版本的服务端先后写进去的，
/// 缺字段、乱序、JSON 存成半截的都遇得到。任何一条消息解析不了就跳过它，
/// 而不是让整段回放报错——用户想看的是自己那篇故事，不是一个解析异常。
class ConversationReplayRepository {
  const ConversationReplayRepository(this._remote);

  final ConversationReplayRemoteDataSource _remote;

  /// 拉取并还原时间线。
  ///
  /// [fallbackWish] / [fallbackNovel] 来自剧本本体（`theme` 与全文）：会话里未必留着
  /// 心愿，正文也可能只落在剧本表里没进消息表，这两处缺了就拿剧本的顶上。
  Future<List<GenerationEntry>> fetchReplay(
    String conversationId, {
    String? fallbackWish,
    String? fallbackNovel,
  }) async {
    try {
      final raw = await _remote.fetchMessages(conversationId);
      final messages =
          <ConversationMessageDto>[
            for (final item in raw)
              if (item is Map<String, dynamic>)
                ConversationMessageDto.fromJson(item),
          ]..sort(
            (a, b) => a.messageOrder.compareTo(b.messageOrder),
          );
      return _toTimeline(
        messages,
        fallbackWish: fallbackWish,
        fallbackNovel: fallbackNovel,
      );
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }

  /// 消息（已按 `messageOrder` 升序）→ 时间线条目。
  List<GenerationEntry> _toTimeline(
    List<ConversationMessageDto> messages, {
    String? fallbackWish,
    String? fallbackNovel,
  }) {
    final answers = _pairAnswers(messages);
    // 大纲被改过时会有好几条：最后那条才是真正开写用的，之前的都是被打回去的。
    final lastOutlineIndex = messages.lastIndexWhere(
      (message) =>
          message.normalizedType == ConversationMessageType.outline,
    );

    final entries = <GenerationEntry>[];
    for (final (index, message) in messages.indexed) {
      final createdAt = _timeOf(message);
      final content = message.content?.trim() ?? "";

      switch (message.normalizedType) {
        case ConversationMessageType.chat when message.isFromUser:
          if (content.isEmpty) break;
          entries.add(GenerationEntry.wish(text: content, createdAt: createdAt));

        case ConversationMessageType.clarificationQuestion:
          final card = _decode(content, ClarificationCardDto.fromJson);
          if (card == null) break;
          entries.add(
            GenerationEntry.clarification(
              card: card.toEntity(),
              createdAt: createdAt,
              // 配不上答案的卡也照样展示：它至少说明"AI 当时问了这个"。
              answer: answers[index]?.content?.trim(),
            ),
          );

        case ConversationMessageType.outline:
          final outline = _decode(content, StoryOutlineDto.fromJson);
          if (outline == null) break;
          entries.add(
            GenerationEntry.outline(
              outline: outline.toEntity(),
              createdAt: createdAt,
              // 最后一版是被确认的，之前的都是提了意见打回去的。意见文本没有单独
              // 落库，所以只能标出"改过"，具体改了什么由展示层用另一句话交代。
              resolution: index == lastOutlineIndex
                  ? OutlineResolution.confirmed
                  : OutlineResolution.modified,
            ),
          );

        case ConversationMessageType.script:
          if (content.isEmpty) break;
          entries.add(
            GenerationEntry.novel(
              content: content,
              createdAt: createdAt,
              // 回放没有进行态，末尾不该有那颗跳动的光标。
              isStreaming: false,
            ),
          );

        // `clarification_answer` 已经并进它所回答的那张卡；配不上的直接丢——
        // 只显示一个答案而看不到问题，比不显示更让人困惑。
        // `system` 是欢迎语，不属于这次创作。其余未知类型一律跳过。
        default:
          break;
      }
    }

    return _withFallbacks(
      entries,
      fallbackWish: fallbackWish,
      fallbackNovel: fallbackNovel,
    );
  }

  /// 给每张澄清卡配一个答案，返回「卡片在 [messages] 里的下标 → 答案」。
  ///
  /// ⚠️ **不能按相邻配对**：库里 answer 的 `messageOrder` 有可能排在它对应的
  /// question 之前（不同版本的服务端写入顺序不一致）。所以按序号找"这张卡之后
  /// 第一个还没被别的卡领走的答案"，配不上就算了。
  Map<int, ConversationMessageDto> _pairAnswers(
    List<ConversationMessageDto> messages,
  ) {
    final paired = <int, ConversationMessageDto>{};
    final claimed = <int>{};

    for (final (questionIndex, question) in messages.indexed) {
      if (question.normalizedType !=
          ConversationMessageType.clarificationQuestion) {
        continue;
      }
      for (final (answerIndex, answer) in messages.indexed) {
        if (answer.normalizedType !=
                ConversationMessageType.clarificationAnswer ||
            claimed.contains(answerIndex) ||
            answer.messageOrder <= question.messageOrder) {
          continue;
        }
        claimed.add(answerIndex);
        paired[questionIndex] = answer;
        break;
      }
    }
    return paired;
  }

  /// 补上会话里没有、但剧本本体有的那两块，并把心愿提到最前面。
  List<GenerationEntry> _withFallbacks(
    List<GenerationEntry> entries, {
    String? fallbackWish,
    String? fallbackNovel,
  }) {
    final result = <GenerationEntry>[...entries];

    // 心愿逻辑上就是这次创作的开头，但它的 messageOrder 未必最小（有的版本把它
    // 补写在澄清之后）。会话里压根没有时，用剧本的 theme 顶上。
    final wishIndex = result.indexWhere(
      (entry) => entry is GenerationWishEntry,
    );
    if (wishIndex > 0) {
      result.insert(0, result.removeAt(wishIndex));
    } else if (wishIndex < 0 && (fallbackWish?.trim().isNotEmpty ?? false)) {
      result.insert(
        0,
        GenerationEntry.wish(
          text: fallbackWish!.trim(),
          // 借第一条的时间：心愿一定发生在它之前，显示同一时刻不会读出矛盾。
          createdAt: result.firstOrNull?.createdAt ?? DateTime.now(),
        ),
      );
    }

    // 早期数据只把正文落在剧本表里，消息表没有 script 那条。
    final hasNovel = result.any((entry) => entry is GenerationNovelEntry);
    if (!hasNovel && (fallbackNovel?.trim().isNotEmpty ?? false)) {
      result.add(
        GenerationEntry.novel(
          content: fallbackNovel!.trim(),
          createdAt: result.lastOrNull?.createdAt ?? DateTime.now(),
          isStreaming: false,
        ),
      );
    }

    return result;
  }

  /// 解析存成 JSON 字符串的卡片 / 大纲。解析不了返回 null（跳过这一条）。
  T? _decode<T>(String content, T Function(Map<String, dynamic>) fromJson) {
    if (content.isEmpty) return null;
    try {
      final decoded = jsonDecode(content);
      return decoded is Map<String, dynamic> ? fromJson(decoded) : null;
    } on Object {
      return null;
    }
  }

  /// 消息时间。解析不了就当"现在"——时间戳只是条目上的一行小字，
  /// 不值得为它丢掉一整条内容。
  DateTime _timeOf(ConversationMessageDto message) =>
      DateTime.tryParse(message.createTime ?? "") ?? DateTime.now();
}
