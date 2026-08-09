import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 启动占位页：登录态未定（冷启动静默刷新进行中）时展示，
/// 避免在 login / home 之间闪烁。无文案，故无 i18n 约束。
///
/// 不用转圈：冷启动通常只有几百毫秒，一个转圈反而在暗示"卡住了"。
/// 换成呼吸的品牌标记——既是等待反馈，也是品牌的第一印象。
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 与登录页同一档星云强度：这两页连着出现，氛围光不该有明暗跳变。
      body: HappyStarfieldBackground(
        intensity: _backgroundIntensity,
        child: Center(
          child: const HappyBrandMark(size: 88)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1,
                end: 1.06,
                duration: HappyMotion.story,
                curve: HappyMotion.ambientCurve,
              )
              .fadeIn(duration: HappyMotion.normal),
        ),
      ),
    );
  }
}

/// 开屏页的星空氛围光强度，与登录页保持一致。
const double _backgroundIntensity = 0.7;
