import "package:happy_os/features/story/domain/index.dart";

/// story 模块的假数据源（无真实接口期间的临时占位）。
///
/// ⚠️ **接完真实接口立即删除整个 `data/mock/` 目录**，并按
/// `agent/service/story/story.api.md` 定稿的契约补 DTO / DataSource / Repository。
// TODO(story): 等 story.api.md 定稿后删除本文件，切回真实 DataSource。
abstract final class StoryMockApi {
  /// 假网络延迟。留足时间是为了让骨架屏真的被看见。
  static const Duration _latency = Duration(milliseconds: 900);

  /// 置 true 后下一次请求抛错，用来人工验证「错误态 + 重试」这条链路。
  static bool simulateFailure = false;

  /// 置 true 后返回空列表，用来人工验证空态引导。
  static bool simulateEmpty = false;

  static Future<List<Story>> fetchHistory() async {
    await Future<void>.delayed(_latency);
    if (simulateFailure) {
      throw Exception("mock: failed to load story history");
    }
    return simulateEmpty ? const <Story>[] : _history;
  }

  /// 灵感池。「换一换」从这里取，所以要比一屏展示的条数多几倍才换得出花样。
  static Future<List<InspirationPrompt>> fetchInspirations() async {
    await Future<void>.delayed(_latency);
    return _inspirations;
  }

  /// 历史列表：故意混入一条"生成中"和一条"失败"，好让两种状态的样式都能被看到。
  static final List<Story> _history = <Story>[
    Story(
      id: "s1",
      title: "把简历送回他桌上",
      excerpt: "面试官把我的简历推回来时笑了一下。三个月后我签下他们最大的竞争对手——",
      createdAt: DateTime(2026, 8, 4, 9, 12),
    ),
    Story(
      id: "s2",
      title: "楼道里的那把旧钥匙",
      excerpt: "房东半夜换了门锁，我在楼道坐到天亮。谁也没想到那把被扔掉的钥匙后来——",
      createdAt: DateTime(2026, 8, 3, 22, 40),
      status: StoryStatus.generating,
    ),
    Story(
      id: "s3",
      title: "末班地铁的第三次抬头",
      excerpt: "对面车窗的倒影里，那个穿灰外套的男人第三次抬起头——而我背后没有人。",
      createdAt: DateTime(2026, 8, 1, 23, 5),
      status: StoryStatus.failed,
    ),
    Story(
      id: "s4",
      title: "被退回的第七版方案",
      excerpt: "第七版方案又被打回来。我把前六版全打印出来，钉在了他办公室门口——",
      createdAt: DateTime(2026, 7, 29, 18, 30),
    ),
    Story(
      id: "s5",
      title: "搬进第一间自己的房子",
      excerpt: "钥匙转了两圈才开。屋里什么都没有，我坐在地板上，第一次觉得脚下是自己的。",
      createdAt: DateTime(2026, 7, 26, 20, 15),
    ),
    Story(
      id: "s6",
      title: "十年后的那条消息",
      excerpt: "十年没联系的人半夜发来一句「在吗」。我盯着那两个字看了很久才回。",
      createdAt: DateTime(2026, 7, 21, 1, 8),
    ),
    Story(
      id: "s7",
      title: "没人看好的那场考试",
      excerpt: "所有人都劝我别报。成绩出来那天，我把截图设成了他们群里的封面。",
      createdAt: DateTime(2026, 7, 18, 12, 0),
    ),
    Story(
      id: "s8",
      title: "他们第一次说以我为荣",
      excerpt: "饭桌上我妈忽然停了筷子，说了一句我等了二十年的话。",
      createdAt: DateTime(2026, 7, 12, 19, 45),
    ),
  ];

  static const List<InspirationPrompt> _inspirations = <InspirationPrompt>[
    InspirationPrompt(id: "i1", text: "一次被当众否定，后来我怎么翻回来的"),
    InspirationPrompt(id: "i2", text: "那个看不起我的人，后来求我帮忙"),
    InspirationPrompt(id: "i3", text: "我一个人扛下了所有人都说做不到的事"),
    InspirationPrompt(id: "i4", text: "搬进第一间自己租的房子那天"),
    InspirationPrompt(id: "i5", text: "被裁员那天，我在楼下坐了很久"),
    InspirationPrompt(id: "i6", text: "十年没联系的朋友突然发来一条消息"),
    InspirationPrompt(id: "i7", text: "一场没人看好的考试，我考了第一"),
    InspirationPrompt(id: "i8", text: "父母第一次说他们以我为荣"),
    InspirationPrompt(id: "i9", text: "我把辞职信递上去的那个下午"),
  ];
}
