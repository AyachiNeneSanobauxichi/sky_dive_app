import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";

/// 流光文字：一道品牌色的光在文字上循环扫过。
///
/// 用途是表达"**系统在忙，但没卡死**"——比转圈更安静、比静态文字更有生命。
/// 典型场景：模型思考阶段的"正在读你的经历…"、生成中的状态提示。
///
/// ⚠️ 每帧都要重建 shader，别用在长段落上；只给一行状态文案用。
/// 文案由调用方从 `AppLocalizations` 传入（红线 #9）。
class HappyShimmerText extends StatelessWidget {
  const HappyShimmerText({super.key, required this.text, this.style});

  final String text;

  /// 默认 `titleMedium`：状态提示要比正文醒目一点，但别抢标题。
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? theme.textTheme.titleMedium;

    return Text(text, style: effectiveStyle)
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: HappyMotion.ambient,
          // 底色用次要文字色、扫过的高光用品牌色：既能读清，又有品牌感
          colors: <Color>[
            theme.colorScheme.onSurfaceVariant,
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
            theme.colorScheme.onSurfaceVariant,
          ],
        );
  }
}
