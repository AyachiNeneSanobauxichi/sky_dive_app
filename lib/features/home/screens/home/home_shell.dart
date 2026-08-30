import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:sky_dive/features/home/widgets/index.dart";
import "package:sky_dive/shared/widgets/index.dart";

/// 首页外壳：天空背景 + 三个 tab 的容器 + 底部导航条。
///
/// 背景放在**外壳这一层**而不是各 tab 各铺一张：切 tab 时天幕就不会跟着重建，
/// 云的漂移相位与滚动视差也因此连续——三个 tab 共享同一片天，
/// 这正是"切 tab 是在同一个空间里横移"该有的感觉。
///
/// [intensity] 压到 0.55：这三个 tab 都是信息页（航线列表、预约列表、账号设置），
/// 满强度的云会和内容抢注意力。云带有下限保护，不会因此消失（见 [SkyBackground]）。
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// 切 tab。重复点当前 tab 时 `initialLocation: true`，把该分支的返回栈弹回根页
  /// ——这是移动端的通用手势，用户在深层页面里靠它一步回到列表顶层。
  void _onSelected(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 内容延伸到导航条底下，毛玻璃条才有东西可"透"。
      extendBody: true,
      body: SkyBackground(
        intensity: _backgroundIntensity,
        child: navigationShell,
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onSelected: _onSelected,
      ),
    );
  }
}

/// 首页外壳的天空氛围光强度。见 `SkyBackground.intensity`。
const double _backgroundIntensity = 0.55;
