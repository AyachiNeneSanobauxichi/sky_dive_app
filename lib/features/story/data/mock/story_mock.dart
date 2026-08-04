import "package:happy_os/features/story/domain/index.dart";

/// story 模块**生成历史**的假数据源（无真实接口期间的临时占位）。
///
/// 灵感推荐已在 `story.api.md` v2 定稿并接了真实接口（见 `StoryRepository`），
/// 对应的假灵感池已随之删除；只剩生成历史契约未定，暂留这一份。
///
/// ⚠️ **历史接口接完后立即删除整个 `data/mock/` 目录**。
// TODO(story): story.api.md 补上生成历史契约后删除本文件，切回真实 DataSource。
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
}
