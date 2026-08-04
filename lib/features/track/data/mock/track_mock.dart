import "package:happy_os/features/track/domain/index.dart";

/// track 模块的假数据源（无真实接口期间的临时占位）。
///
/// ⚠️ **接完真实接口立即删除整个 `data/mock/` 目录**，并按
/// `agent/service/track/track.api.md` 定稿的契约补 DTO / DataSource / Repository。
// TODO(track): 等 track.api.md 定稿后删除本文件，切回真实 DataSource。
abstract final class TrackMockApi {
  /// 假网络延迟。留足时间是为了让骨架屏真的被看见。
  static const Duration _latency = Duration(milliseconds: 900);

  /// 置 true 后下一次请求抛错，用来人工验证「错误态 + 重试」这条链路。
  static bool simulateFailure = false;

  /// 置 true 后返回空列表，用来人工验证空态引导。
  static bool simulateEmpty = false;

  static Future<List<TrackEntry>> fetchEntries() async {
    await Future<void>.delayed(_latency);
    if (simulateFailure) {
      throw Exception("mock: failed to load track entries");
    }
    return simulateEmpty ? const <TrackEntry>[] : _entries;
  }

  /// 四种标签各给两条，这样筛选切换时每个标签下都有内容可看；
  /// 故意留一条 [TrackEntry.outcome] 为空，"还没有结果"的样式才能被验到。
  static final List<TrackEntry> _entries = <TrackEntry>[
    TrackEntry(
      id: "t1",
      event: "签下他们最大的竞争对手",
      happenedAt: DateTime(2026, 7, 30),
      feeling: "手心全是汗，但笔没抖",
      outcome: "第一件事就是让人把那份被退回的简历送到他桌上",
      tag: TrackTag.highlight,
    ),
    TrackEntry(
      id: "t2",
      event: "在楼道里坐到天亮",
      happenedAt: DateTime(2026, 7, 12),
      feeling: "冷，倒不是怕，是不知道明天住哪",
      outcome: null,
      tag: TrackTag.lowPoint,
    ),
    TrackEntry(
      id: "t3",
      event: "搬进第一间自己租的房子",
      happenedAt: DateTime(2026, 6, 28),
      feeling: "屋里什么都没有，我坐在地板上笑了很久",
      outcome: "后来那间屋子成了我所有故事的开头",
      tag: TrackTag.goodMoment,
    ),
    TrackEntry(
      id: "t4",
      event: "被当众否定的那场汇报",
      happenedAt: DateTime(2026, 5, 16),
      feeling: "站在原地把话讲完了，声音有点飘",
      outcome: "三个月后同一批人来问我怎么做的",
      tag: TrackTag.lowPoint,
    ),
    TrackEntry(
      id: "t5",
      event: "父母第一次说以我为荣",
      happenedAt: DateTime(2026, 4, 2),
      feeling: "饭桌上我妈忽然停了筷子",
      outcome: "我等这句话等了二十年",
      tag: TrackTag.goodMoment,
    ),
    TrackEntry(
      id: "t6",
      event: "小学门口那家一毛钱的冰棍",
      happenedAt: DateTime(2008, 6, 1),
      feeling: "夏天很长，钱很少，快乐很密",
      outcome: "现在再也吃不到那个味道了",
      tag: TrackTag.childhood,
    ),
    TrackEntry(
      id: "t7",
      event: "第一次拿到全班第一",
      happenedAt: DateTime(2010, 1, 20),
      feeling: "成绩单被我在书包里摸了一路",
      outcome: "我爸把它贴在了冰箱上，贴了三年",
      tag: TrackTag.childhood,
    ),
    TrackEntry(
      id: "t8",
      event: "把辞职信递上去的那个下午",
      happenedAt: DateTime(2026, 3, 8),
      feeling: "按下发送键之后反而不慌了",
      outcome: "走出写字楼时天正好晴",
      tag: TrackTag.highlight,
    ),
  ];
}
