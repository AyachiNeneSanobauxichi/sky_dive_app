import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/index.dart";

/// 设计系统冒烟测试。
///
/// 主题里的 [ColorScheme]、各 `*ThemeData` 以及自绘组件的断言只在**运行时**触发，
/// `flutter analyze` 查不出来。这组测试把深浅两套主题下的全部全局组件都渲染一遍，
/// 保证改令牌不会静默炸掉某个组件。
void main() {
  /// 在指定主题下渲染全部全局组件。
  Widget harness(ThemeData theme) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: HappyAuroraBackground(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const HappyBrandMark(),
                const TextField(decoration: InputDecoration(hintText: "hint")),
                for (final variant in HappyButtonVariant.values)
                  HappyButton(
                    label: variant.name,
                    variant: variant,
                    onPressed: () {},
                  ),
                const HappyButton(label: "disabled", onPressed: null),
                const HappyButton(
                  label: "loading",
                  onPressed: null,
                  isLoading: true,
                ),
                HappyCheckbox(
                  value: true,
                  onChanged: (_) {},
                  label: const Text("checked"),
                ),
                HappyCheckbox(
                  value: false,
                  onChanged: (_) {},
                  isError: true,
                  label: const Text("error"),
                ),
                const HappyGlassCard(child: Text("glass")),
                // AI 状态表达组件
                const HappyStreamingText(text: "streaming", isStreaming: true),
                const HappyStreamingText(text: "done"),
                const HappyThinkingIndicator(label: "thinking"),
                const HappyShimmerText(text: "shimmer"),
                const HappyMarkdownText(data: "**bold** and `code`"),
                HappyRetryCard(
                  message: "failed",
                  retryLabel: "retry",
                  onRetry: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  for (final entry in <String, ThemeData>{
    "dark": HappyTheme.dark,
    "light": HappyTheme.light,
  }.entries) {
    testWidgets("${entry.key} 主题下全局组件均可渲染", (tester) async {
      await tester.pumpWidget(harness(entry.value));
      // 极光背景是无限循环动画，pumpAndSettle 会超时，这里只推进有限帧。
      await tester.pump(HappyMotion.normal);

      expect(tester.takeException(), isNull);
      // HappyRetryCard 内部还有一个按钮，故比变体数多 1
      expect(find.byType(HappyButton), findsNWidgets(7));
      expect(find.byType(HappyCheckbox), findsNWidgets(2));
      expect(find.byType(HappyGlassCard), findsOneWidget);
      expect(find.byType(HappyStreamingText), findsNWidgets(2));
      expect(find.byType(HappyThinkingIndicator), findsOneWidget);
      expect(find.byType(HappyMarkdownText), findsOneWidget);
    });
  }

  testWidgets("按下主按钮会触发缩放反馈", (tester) async {
    await tester.pumpWidget(harness(HappyTheme.dark));
    await tester.pump(HappyMotion.normal);

    final target = find.text(HappyButtonVariant.primary.name);
    final gesture = await tester.startGesture(tester.getCenter(target));
    // 必须等过手势竞技场判定：按钮在可滚动容器里，TapGestureRecognizer 要和
    // Scrollable 的拖拽识别器竞争，`kPressTimeout`（100ms）之前不会置高亮。
    // 用 HappyMotion.instant（90ms）恰好卡在临界点上，会随机假红。
    await tester.pump(HappyMotion.slow);

    final scale = tester.widget<AnimatedScale>(
      find.ancestor(of: target, matching: find.byType(AnimatedScale)).first,
    );
    expect(scale.scale, HappyMotion.pressScale);

    await gesture.up();
    await tester.pump(HappyMotion.normal);
  });
}
