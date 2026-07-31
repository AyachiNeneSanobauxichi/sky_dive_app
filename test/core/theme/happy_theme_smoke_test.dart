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
      expect(find.byType(HappyButton), findsNWidgets(6));
      expect(find.byType(HappyCheckbox), findsNWidgets(2));
      expect(find.byType(HappyGlassCard), findsOneWidget);
    });
  }

  testWidgets("按下主按钮会触发缩放反馈", (tester) async {
    await tester.pumpWidget(harness(HappyTheme.dark));
    await tester.pump(HappyMotion.normal);

    final target = find.text(HappyButtonVariant.primary.name);
    final gesture = await tester.startGesture(tester.getCenter(target));
    await tester.pump(HappyMotion.instant);

    final scale = tester.widget<AnimatedScale>(
      find.ancestor(of: target, matching: find.byType(AnimatedScale)).first,
    );
    expect(scale.scale, HappyMotion.pressScale);

    await gesture.up();
    await tester.pump(HappyMotion.normal);
  });
}
