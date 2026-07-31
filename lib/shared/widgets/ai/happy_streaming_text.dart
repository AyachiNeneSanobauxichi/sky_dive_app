import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";

/// 流式文本：正在生成的文字 + 末尾呼吸光标。
///
/// 光标是"AI 正在写"这件事**唯一**的视觉证据。没有它，用户分不清是在生成
/// 还是已经写完了、只是这段比较短。所以 [isStreaming] 为 true 时必须有光标，
/// 且必须紧跟在最后一个字后面（用 `WidgetSpan` 挂在文本尾部，会随换行一起走）。
///
/// 文本内容由调用方喂增量拼好的完整字符串——本组件是纯展示，不持有累积逻辑。
///
/// > 长文选中复制：`SelectableText.rich` 对 `WidgetSpan` 支持不佳，
/// > 因此生成中不可选中；生成完成后请把 [isStreaming] 置 false 并换用
/// > 可选中的展示组件（或直接提供"复制全文"按钮）。
class HappyStreamingText extends StatelessWidget {
  const HappyStreamingText({
    super.key,
    required this.text,
    this.isStreaming = false,
    this.style,
    this.textAlign,
  });

  /// 当前已生成的全部文本。
  final String text;

  /// 是否仍在生成中（决定是否显示光标）。
  final bool isStreaming;

  /// 文本样式。默认取 `bodyLarge`（行高 1.65，长阅读专用）。
  final TextStyle? style;

  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.bodyLarge;

    return Text.rich(
      TextSpan(
        style: effectiveStyle,
        children: <InlineSpan>[
          TextSpan(text: text),
          if (isStreaming)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _StreamingCaret(fontSize: effectiveStyle?.fontSize),
            ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

/// 呼吸光标。
///
/// 用淡入淡出而不是文本编辑器那种硬闪：硬闪的联想是"等你输入"，
/// 柔和呼吸的联想是"它在思考着写"，后者才是这个产品要的感觉。
class _StreamingCaret extends StatelessWidget {
  const _StreamingCaret({this.fontSize});

  final double? fontSize;

  /// 光标高度相对字号的比例。略低于字高，视觉上和汉字齐平而不顶出行外。
  static const double _heightRatio = 1.05;

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? HappyIconSize.sm;

    return Padding(
      // 和最后一个字之间留一点缝，否则会像标点粘在字上
      padding: const EdgeInsets.only(left: HappySpacing.s2),
      child:
          Container(
                width: HappyBorderWidth.thick,
                height: size * _heightRatio,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(HappyBorderWidth.thick),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(
                duration: HappyMotion.slow,
                curve: HappyMotion.ambientCurve,
              ),
    );
  }
}
