import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";
import "happy_shimmer_text.dart";

/// 思考中指示器：三点波浪 + 可选流光文案。
///
/// 用在"请求已发出、但还没有第一个字"的窗口——这段时间是流式生成体验里最脆弱的
/// 一段（可能长达数秒），必须有明确反馈，否则用户会重复点生成。
/// 首字一到就应该切换成 [HappyStreamingText]。
///
/// 文案由调用方从 `AppLocalizations` 传入（红线 #9）。
class HappyThinkingIndicator extends StatelessWidget {
  const HappyThinkingIndicator({super.key, this.label});

  /// 可选状态文案，如"正在读你的经历…"。为空则只显示三点。
  final String? label;

  /// 点数量。三个是波浪能被认出来的最小数量。
  static const int _dotCount = 3;

  /// 单点直径。
  static const double _dotSize = 7;

  /// 波浪上抬幅度。
  static const double _waveHeight = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: HappySpacing.s12,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: HappySpacing.s6,
          children: <Widget>[
            for (var i = 0; i < _dotCount; i++) _WaveDot(index: i),
          ],
        ),
        if (label != null) HappyShimmerText(text: label!),
      ],
    );
  }
}

/// 波浪中的单个点。靠 [index] 错开延迟形成行进的波，而不是三点同步跳。
class _WaveDot extends StatelessWidget {
  const _WaveDot({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: HappyThinkingIndicator._dotSize,
          height: HappyThinkingIndicator._dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: HappyGradients.brandFor(Theme.of(context).brightness),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          end: -HappyThinkingIndicator._waveHeight,
          duration: HappyMotion.slow,
          delay: HappyMotion.stagger * index,
          curve: HappyMotion.ambientCurve,
        );
  }
}
