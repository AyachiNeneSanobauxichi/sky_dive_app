import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
// 页面私有组件不走 barrel，测试直接引文件。
import "package:happy_os/features/auth/screens/login/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:toastification/toastification.dart";

/// 登录页交互冒烟测试。
///
/// 覆盖最容易在改动中回退、且 `flutter analyze` 查不出来的交互约束：按钮的
/// 「可点/禁用」判定、验证码填满自动提交、验证码被拒后清空重填、发码后手机号折叠、
/// 协议未勾选时的就地报错，以及深浅两套主题都能渲染。
void main() {
  Widget harness(ThemeData theme) {
    // 不覆盖任何 provider：认证走 mock，DioClient 虽被组装但不发请求。
    // 这同时守着 `Env` 的回退——测试里没加载 .env，若 Env 又去裸读 dotenv，
    // 构造 DioClient 就会抛 NotInitializedError，发码/登录会静默变成失败。
    return ProviderScope(
      child: MaterialApp(
        theme: theme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          ...AppLocalizations.localizationsDelegates,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale("zh"),
        home: const LoginScreen(),
        // 与 app.dart 一致：HappyToast 需要它承载 overlay。
        builder: (context, child) => ToastificationWrapper(child: child!),
      ),
    );
  }

  /// 极光背景与 OTP 光标都是无限循环动画，`pumpAndSettle` 会超时，只推进有限帧。
  ///
  /// 推两帧：`flutter_animate` 的 `Animate` 在挂载那一帧建了个零延迟 Timer 用于起播，
  /// 只推一帧会让它悬在 fake-async 里，被判成"测试结束仍有 Timer 未完成"。
  Future<void> settle(WidgetTester tester) async {
    await tester.pump(HappyMotion.normal);
    // 第二帧必须带时长：零时长 pump 不推进 fake 时钟，那个零延迟 Timer 就永远不触发。
    await tester.pump(HappyMotion.instant);
  }

  /// 用真机尺寸而不是测试默认的 800×600：登录页比 600 高，默认视口下底部按钮会落在
  /// 视口外，`tap` 打空导致假红。
  Future<void> pumpLogin(WidgetTester tester, {ThemeData? theme}) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(harness(theme ?? HappyTheme.dark));
    await settle(tester);
  }

  /// 手机号输入（PhoneField 内的输入框）。
  Finder phoneInput() => find.descendant(
    of: find.byType(PhoneField),
    matching: find.byType(TextField),
  );

  /// 验证码输入（OTP 的透明输入层，格子只是皮肤）。
  Finder codeInput() => find.descendant(
    of: find.byType(HappyOtpField),
    matching: find.byType(TextField),
  );

  AppLocalizations l10nOf(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(LoginScreen)));

  /// 登录提交按钮（发送验证码按钮也是 HappyButton，用 label 区分）。
  HappyButton submitButton(WidgetTester tester) => tester.widget<HappyButton>(
    find.widgetWithText(HappyButton, l10nOf(tester).loginSubmit),
  );

  /// 点击前先滚到可见：页面可滚动，目标可能在折叠区之外。
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
  }

  /// 勾选协议。**点行中心必须能勾上**：协议链接已移到下一行，勾选行内不该再有
  /// 抢走点击的链接（回归到行内嵌链接会让这里失败，正是本断言要守的）。
  Future<void> tapAgreement(WidgetTester tester) async {
    await tapVisible(tester, find.byType(HappyCheckbox));
    await settle(tester);
    expect(
      tester.widget<HappyCheckbox>(find.byType(HappyCheckbox)).value,
      isTrue,
    );
  }

  /// 等一次组件切换动画彻底走完（AnimatedSwitcher 的换出子树要多一帧才被移除）。
  Future<void> settleSwitch(WidgetTester tester) async {
    await tester.pump(HappyMotion.slow);
    await settle(tester);
  }

  for (final entry in <String, ThemeData>{
    "dark": HappyTheme.dark,
    "light": HappyTheme.light,
  }.entries) {
    testWidgets("${entry.key} 主题下登录页可渲染且无溢出", (tester) async {
      await pumpLogin(tester, theme: entry.value);

      expect(tester.takeException(), isNull);
      expect(find.byType(PhoneField), findsOneWidget);
      expect(find.byType(HappyOtpField), findsOneWidget);
      expect(find.byType(HappyCheckbox), findsOneWidget);
      // 首屏要说清产品是什么：示例故事卡在场
      expect(find.byType(LoginSampleStory), findsOneWidget);
    });
  }

  testWidgets("验证码 6 格全部渲染，输入后逐格显示数字", (tester) async {
    await pumpLogin(tester);

    await tester.enterText(codeInput(), "1234");
    await settle(tester);

    // 已填的 4 位逐格显示，剩余两格仍为空
    for (final digit in <String>["1", "2", "3", "4"]) {
      expect(find.text(digit), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets("一次性填入多位才逐格入场，逐位输入不播动效", (tester) async {
    await pumpLogin(tester);

    // OTP 内部的 Animate 数量就是动效数量：光标算一个，每个逐格入场的数字各算一个。
    Finder otpAnimations() => find.descendant(
      of: find.byType(HappyOtpField),
      matching: find.byType(Animate),
    );

    // 逐位输入（每次只多一位）：只有活动格的闪烁光标在动
    await tester.enterText(codeInput(), "1");
    await settle(tester);
    expect(otpAnimations(), findsOneWidget);

    await tester.enterText(codeInput(), "12");
    await settle(tester);
    expect(otpAnimations(), findsOneWidget);

    // 一次性填满（粘贴 / 短信自动填充）：只给**这一批新到的 4 位**播，
    // 已经手敲进去的前 2 位不重播；此时格子填满，光标也不在了。
    await tester.enterText(codeInput(), "123456");
    await settle(tester);
    expect(otpAnimations(), findsNWidgets(4));

    await tester.pump(HappyMotion.slow);
  });

  testWidgets("手机号与验证码填全前，登录按钮保持禁用", (tester) async {
    await pumpLogin(tester);

    expect(submitButton(tester).onPressed, isNull);

    // 只填手机号还不够
    await tester.enterText(phoneInput(), "13800138000");
    await settle(tester);
    expect(submitButton(tester).onPressed, isNull);

    // 验证码位数不足仍禁用
    await tester.enterText(codeInput(), "123");
    await settle(tester);
    expect(submitButton(tester).onPressed, isNull);

    // 两项都合法才放行（此时协议仍未勾选——按钮可点，由提交时就地报错）
    await tester.enterText(codeInput(), "123456");
    await settle(tester);
    expect(submitButton(tester).onPressed, isNotNull);

    await tester.pump(HappyMotion.slow);
  });

  testWidgets("验证码填满即自动提交：未勾协议时就地报错，不发起请求", (tester) async {
    await pumpLogin(tester);

    await tester.enterText(phoneInput(), "13800138000");
    // 填满 6 位后不点任何按钮：自动提交应当已经跑过一次校验
    await tester.enterText(codeInput(), "123456");
    await settle(tester);

    final l10n = l10nOf(tester);
    expect(find.text(l10n.authAgreementRequired), findsOneWidget);
    expect(
      tester.widget<HappyCheckbox>(find.byType(HappyCheckbox)).isError,
      isTrue,
    );
    // 请求未发起：登录按钮没有进入忙碌态
    expect(submitButton(tester).isLoading, isFalse);

    // 抖动动画播完，避免测试结束时留下未完成的动画
    await tester.pump(HappyMotion.slow);
  });

  testWidgets("发码成功后手机号折叠成打码摘要，点修改可改回输入框", (tester) async {
    await pumpLogin(tester);

    await tester.enterText(phoneInput(), "13800138000");
    await settle(tester);
    await tapVisible(
      tester,
      find.widgetWithText(HappyButton, l10nOf(tester).authSendCode),
    );
    // mock 发码有 900ms 延迟，推过它
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);

    // 折叠成打码摘要：号码可核对但不完整暴露
    expect(find.byType(PhoneSummary), findsOneWidget);
    expect(find.text("+86 138****8000"), findsOneWidget);
    // 冷却期不再留一个灰掉的按钮（灰按钮读起来像坏了），换成纯文字说明
    expect(
      find.widgetWithText(HappyButton, l10nOf(tester).authSendCode),
      findsNothing,
    );

    // 点"修改"回到可编辑态，且原号码还在
    await tapVisible(
      tester,
      find.widgetWithText(HappyButton, l10nOf(tester).authChangePhone),
    );
    await settleSwitch(tester);
    expect(find.byType(PhoneSummary), findsNothing);
    expect(
      tester.widget<TextField>(phoneInput()).controller?.text,
      "13800138000",
    );

    // 让 toast 自动关闭 + 冷却倒计时跑完，避免测试结束时留下悬挂 timer
    await tester.pump(const Duration(minutes: 2));
  });

  testWidgets("验证码被后端拒绝：清空格子，已填内容不留在屏上", (tester) async {
    await pumpLogin(tester);

    // 先勾协议，让提交能真正打到（mock）后端
    await tapAgreement(tester);

    await tester.enterText(phoneInput(), "13800138000");
    // mock 里 000000 专用于触发「验证码不正确」业务错误
    await tester.enterText(codeInput(), "000000");
    await settle(tester);
    // 填满即自动提交；mock 登录有 1.2s 延迟
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);

    // 格子已清空（屏幕上不再有那 6 个 0），用户可以直接重填
    expect(find.text("0"), findsNothing);
    // 空验证码 → 按钮回到禁用；且不该多冒一条"请输入验证码"（刚弹过错误提示）
    expect(submitButton(tester).onPressed, isNull);
    expect(find.text(l10nOf(tester).authCodeRequired), findsNothing);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets("登录成功：先在原页把格子变对勾，动效播完才落地会话（触发跳转）", (tester) async {
    // 会话落地要写 flutter_secure_storage——平台插件在测试里没有实现，
    // 不 mock 会抛 MissingPluginException，成功路径根本走不完。
    const storageChannel = MethodChannel(
      "plugins.it_nomads.com/flutter_secure_storage",
    );
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(storageChannel, (call) async {
      // read/readAll 返回空即"本机没有旧会话"，write/delete 视为成功。
      return call.method == "readAll" ? <String, String>{} : null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(storageChannel, null));

    await pumpLogin(tester);
    await tapAgreement(tester);
    await tester.enterText(phoneInput(), "13800138000");
    // mock 里任意 6 位数字（000000 除外）都算验证码正确
    await tester.enterText(codeInput(), "123456");
    // 填满即自动提交。这里必须**小步推进**假时钟：mock 登录 1.2s、确认动效 400ms，
    // 一次 pump(2s) 会把两段一起走完，就看不到"先确认、后跳转"这个中间态了。
    // 1300ms 落在两段之间（1200 已返回、1600 才落地会话）。
    await tester.pump(const Duration(milliseconds: 1300));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(LoginScreen)),
    );

    // 此刻：6 格已变对勾，但登录态**还没**翻转（否则路由已经把页面换掉了）。
    // 限定在 OTP 内找：协议勾选框用的也是这个对勾图标。
    expect(
      find.descendant(
        of: find.byType(HappyOtpField),
        matching: find.byIcon(LucideIcons.check),
      ),
      findsNWidgets(6),
    );
    expect(
      container.read(authControllerProvider).value,
      isNot(isA<Authenticated>()),
    );

    // 确认动效播完后才落地会话 → 登录态翻转 → 由 route_guard 换页
    await tester.pump(HappyMotion.slow);
    await settle(tester);
    expect(container.read(authControllerProvider).value, isA<Authenticated>());

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets("未勾选协议点登录：勾选框下方就地报错，不发起请求", (tester) async {
    await pumpLogin(tester);

    await tester.enterText(phoneInput(), "13800138000");
    await tester.enterText(codeInput(), "123456");
    await settle(tester);

    final l10n = l10nOf(tester);
    await tapVisible(
      tester,
      find.widgetWithText(HappyButton, l10n.loginSubmit),
    );
    await settle(tester);

    // 错误就地展示（而不是 toast），且勾选框进入错误态
    expect(find.text(l10n.authAgreementRequired), findsOneWidget);
    expect(
      tester.widget<HappyCheckbox>(find.byType(HappyCheckbox)).isError,
      isTrue,
    );
    expect(submitButton(tester).isLoading, isFalse);

    await tester.pump(HappyMotion.slow);
  });
}
