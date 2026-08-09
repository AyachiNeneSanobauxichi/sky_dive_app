import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/home/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 首页外壳（v2）：底部导航承载三个业务模块。
///
/// | tab | 路由 | 模块 | 职责 |
/// | --- | --- | --- | --- |
/// | 1 | `/track` | `features/track` | 用户成长轨迹，是生成爽文的素材 key |
/// | 2 | `/story` | `features/story` | 生成并管理用户生成的爽文（主路径，默认落地） |
/// | 3 | `/user` | `features/user` | 用户设定（作者设定 / 偏好）+ 退出登录 |
///
/// 外壳本身**不持有"当前是哪个 tab"**：那份状态在路由里，由
/// [StatefulNavigationShell] 提供（见 `app/router/routes.dart` 的分支声明）。
/// 好处是深链接、系统返回、埋点都自然一致；页面内 setState 方案做不到这些。
///
/// 外壳**持有**的是每个分支的滚动控制器（见 [HomeBranchScope]），只为支撑
/// "再次点击当前 tab 回到顶部"——这个交互的触发方在导航条、执行方在页面里。
///
/// 极光背景放在 `Scaffold` **外面**、Scaffold 自身透明：这样光能透到底部导航条
/// 后面（导航条是半透明的），画布不被屏幕底部的一条色带切断。刻意不用
/// `extendBody`——那会让各 tab 的内容伸到导航条底下，列表最后一项被压住，
/// 得逐页补底部内边距；把极光提到外层能拿到同样的观感，且零布局风险。
///
/// 外壳只管"在哪个 tab"，标题栏与内容都由各模块自己的 `Scaffold` 负责——这样每个
/// 模块日后能原样升级成独立路由，不必拆外壳。
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.navigationShell});

  /// go_router 提供的分支外壳：既是当前 tab 内容（容器见 [HomeBranchStack]），
  /// 也是切换 tab 的入口。
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// story tab 的角标数（生成完成、待查看的故事条数）。
  // TODO(home): 待 story 模块的生成状态 provider 就绪后接上
  //   （由 agent/service/story/story.md 驱动，属业务层，本期 infra 不越界写）。
  //   现在恒为 0 即不显示角标；接上后 tab 上会自动冒出来。
  static const int _storyBadgeCount = 0;

  /// 分支索引 → 滚动控制器。惰性创建：分支数由路由决定，外壳不该写死 3。
  final Map<int, ScrollController> _scrollControllers =
      <int, ScrollController>{};

  ScrollController _controllerFor(int index) =>
      _scrollControllers.putIfAbsent(index, ScrollController.new);

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// tab 切换。
  ///
  /// 再次点击当前 tab 不是"无操作"，而是**回到该分支的栈顶 + 内容滚回顶部**
  /// （移动端惯例：从详情页一键回列表、从长列表一键回开头）。
  void _onSelect(int index) {
    final shell = widget.navigationShell;
    if (index == shell.currentIndex) {
      shell.goBranch(index, initialLocation: true);
      _scrollBranchToTop(index);
      return;
    }
    // 跨 tab 前收键盘：分支常驻挂载，焦点若留在上一个 tab 的输入框里，
    // 键盘会赖在新 tab 上面遮住内容。
    FocusManager.instance.primaryFocus?.unfocus();
    HapticFeedback.selectionClick();
    shell.goBranch(index);
  }

  /// 把该分支里已经滚动过的可滚动区送回顶部。
  ///
  /// 遍历 `positions` 而不是直接读 `offset`：同一分支里 push 了详情页时会有两个
  /// position 同时挂着，读 `offset` 会直接抛异常。
  /// 已经在顶部就什么都不做、**也不震**——否则用户会以为点出了什么反应。
  void _scrollBranchToTop(int index) {
    final controller = _scrollControllers[index];
    if (controller == null || !controller.hasClients) return;

    var moved = false;
    for (final position in controller.positions) {
      if (position.pixels <= position.minScrollExtent) continue;
      position.animateTo(
        position.minScrollExtent,
        duration: HappyMotion.normal,
        curve: HappyMotion.standard,
      );
      moved = true;
    }
    if (moved) HapticFeedback.selectionClick();
  }

  /// 长按中间 story 圆：弹快捷创作菜单，省掉"先进列表再找按钮"这一层。
  Future<void> _onStoryLongPress() async {
    HapticFeedback.mediumImpact(); // 长按成立要有明确一击，否则不知道触发了没
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => HomeStoryQuickActions(
        onNewStory: () => _closeSheetThenComingSoon(sheetContext),
        onContinueLast: () => _closeSheetThenComingSoon(sheetContext),
      ),
    );
  }

  /// 两项都还没有落地页，先关弹层再给轻提示——可点元素不能点了没反应。
  // TODO(home): 「新建故事」接 story 创作页、「继续上次生成」接最近草稿，
  //   两者都要等 agent/service/story/story.md 定稿（业务层，本期 infra 不越界写）。
  void _closeSheetThenComingSoon(BuildContext sheetContext) {
    Navigator.of(sheetContext).pop();
    HappyToast.info(context, AppLocalizations.of(context).commonComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    // 星云压到 0.4：这三页后面都会变成信息密集列表，氛围光只做底噪。
    // 星点不受这个折扣的全额影响（见 HappyStarfieldBackground.intensity），
    // 否则列表页会把"星空"这层身份整个丢掉。
    return HappyStarfieldBackground(
      intensity: 0.4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: HomeBranchScope(
          controllerFor: _controllerFor,
          child: widget.navigationShell,
        ),
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onSelect: _onSelect,
          onStoryLongPress: _onStoryLongPress,
          storyBadgeCount: _storyBadgeCount,
        ),
      ),
    );
  }
}
