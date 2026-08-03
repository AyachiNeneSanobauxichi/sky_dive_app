import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/index.dart";
import "package:happy_os/features/track/index.dart";
import "package:happy_os/features/user/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 首页外壳（v2）：底部导航承载三个业务模块。
///
/// | tab | 模块 | 职责 |
/// | --- | --- | --- |
/// | 1 | `features/story` | 生成并管理用户生成的爽文（主路径） |
/// | 2 | `features/track` | 用户成长轨迹，是生成爽文的素材 key |
/// | 3 | `features/user` | 用户设定（作者设定 / 偏好）+ 退出登录 |
///
/// 为什么用 `IndexedStack` 而不是每次重建当前 tab：三个页面同时保持挂载，切回来时
/// 滚动位置、输入草稿都还在（规范要求 tab 切换不丢状态）。代价是三页常驻内存，
/// 页数上到 5+ 或单页很重时要换成 `StatefulShellRoute` + 懒加载。
///
/// 外壳只管"在哪个 tab"，标题栏与内容都由各模块自己的 `Scaffold` 负责——这样每个
/// 模块日后能原样升级成独立路由，不必拆外壳。
// TODO(router): tab 目前是页面内状态，深链接（happyos://story）与 tab 级返回栈
//   需要 go_router 的 StatefulShellRoute；那属 infra，改动前须人工确认。
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _onSelect(int index) {
    if (index == _index) return; // 重复点当前 tab 不做任何事，也不震
    HapticFeedback.selectionClick();
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 极光压到 0.4：这三页后面都会变成信息密集列表，氛围光只做底噪。
      body: HappyAuroraBackground(
        intensity: 0.4,
        child: IndexedStack(
          index: _index,
          children: const <Widget>[StoryScreen(), TrackScreen(), UserScreen()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onSelect,
        // 主题里还没配 NavigationBarThemeData，这里先用 colorScheme 取色，
        // 避免 M3 默认的灰底把品牌调性冲掉。
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        surfaceTintColor: Colors.transparent,
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(LucideIcons.bookOpen),
            label: l10n.homeTabStory,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.footprints),
            label: l10n.homeTabTrack,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.userRound),
            label: l10n.homeTabUser,
          ),
        ],
      ),
    ).animate().fadeIn(duration: HappyMotion.slow, curve: HappyMotion.standard);
  }
}
