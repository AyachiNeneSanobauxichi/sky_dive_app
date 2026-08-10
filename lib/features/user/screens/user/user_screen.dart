import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/index.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/settings/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/features/user/controllers/index.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:happy_os/features/user/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// user 模块主页（v2）：档案总览 + 功能入口。
///
/// 模块职责：**用户设定**——相当于 story 生成时的"作者设定"。首页第 3 个 tab。
///
/// 页面骨架自上而下：身份（头像 / 昵称 / 完成度环）→ 两个成长指标 → 个人档案
/// → 功能列表。这个顺序对应"我是谁 → 我到哪了 → 我的素材 → 我能做什么"。
///
/// **没有 AppBar**：这一页的标题就是用户自己（头像 + 昵称），再顶一行"我的"是重复
/// 信息，还白占一条高度。身份区因此**固定在顶端不随列表滚动**——它是这一页的锚点，
/// 滚下去看档案时也该一直看得见自己是谁。
///
/// 四态齐全：加载=骨架屏（复用同一套内容组件，形状不跳）/ 错误=内联重试卡 /
/// 有数据=淡入 / "空"在这里表现为档案字段的"未填写" + 完善引导（登录用户一定有
/// 档案，不存在整页空态）。
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(userProfileControllerProvider);
    // 偏好设置和档案不是一回事：档案要拉接口、有加载/错误态，偏好是本地的、永远有值。
    // 所以它不参与下面那个 switch，骨架态里也照常可用。
    final settings = ref.watch(appSettingsControllerProvider);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      body: SafeArea(
        // 底部不留：外壳的导航条自己会让出手势条高度。
        bottom: false,
        child: switch (profile) {
          AsyncData(:final value) =>
            _UserBody(
              profile: value,
              onRefresh: () =>
                  ref.read(userProfileControllerProvider.notifier).reload(),
              onEditProfile: () => _openProfileSettings(context),
              onFieldTap: (key) => _openProfileSettings(context, field: key),
              onExplainMetric: (metric) => _explainMetric(context, metric),
              onSwitchAccount: () => _comingSoon(context),
              onContactDeveloper: () => _comingSoon(context),
              onLogout: () => _confirmLogout(context, ref),
              languageLabel: _languageLabel(l10n, settings.locale),
              themeLabel: _themeLabel(l10n, settings.themeMode),
              onPickLanguage: () => _pickLanguage(context, ref, settings),
              onPickTheme: () => _pickTheme(context, ref, settings),
            ).animate().fadeIn(
              duration: HappyMotion.normal,
              curve: HappyMotion.standard,
            ),
          AsyncError(:final error) => _ErrorState(
            message: _messageOf(error, l10n),
            onRetry: () => ref
                .read(userProfileControllerProvider.notifier)
                .reload(showSkeleton: true),
          ),
          // 骨架屏喂一份"长度像真数据"的占位档案，形状才和加载完一致。
          _ => Skeletonizer(
            child: _UserBody(
              profile: _skeletonProfile,
              onRefresh: _asyncNoop,
              onEditProfile: _noop,
              onFieldTap: _ignoreField,
              onExplainMetric: _ignoreMetric,
              onSwitchAccount: _noop,
              onContactDeveloper: _noop,
              onLogout: _noop,
              languageLabel: _languageLabel(l10n, settings.locale),
              themeLabel: _themeLabel(l10n, settings.themeMode),
              onPickLanguage: _noop,
              onPickTheme: _noop,
            ),
          ),
        },
      ),
    );
  }

  /// 语言的展示文案。`null` = 跟随系统，这一档必须单独说清——显示成"简体中文"的话，
  /// 用户换了手机系统语言发现 app 跟着变了，会以为是 bug。
  String _languageLabel(AppLocalizations l10n, Locale? locale) =>
      switch (locale?.languageCode) {
        _languageZh => l10n.userLanguageZh,
        _languageEn => l10n.userLanguageEn,
        _ => l10n.userLanguageSystem,
      };

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) =>
      mode == ThemeMode.light ? l10n.userThemeLight : l10n.userThemeDark;

  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => UserOptionsSheet<String?>(
        title: l10n.userSettingLanguage,
        // 用 languageCode 而不是 Locale 当选项值：Locale 的相等比较还看
        // countryCode/scriptCode，`Locale("zh")` 和系统给的 `zh_Hans_CN` 不相等，
        // 打勾会落不到任何一项上。
        selected: settings.locale?.languageCode,
        options: <UserOption<String?>>[
          UserOption<String?>(value: null, label: l10n.userLanguageSystem),
          UserOption<String?>(value: _languageZh, label: l10n.userLanguageZh),
          UserOption<String?>(value: _languageEn, label: l10n.userLanguageEn),
        ],
        onSelected: (code) => ref
            .read(appSettingsControllerProvider.notifier)
            .setLocale(code == null ? null : Locale(code)),
      ),
    );
  }

  Future<void> _pickTheme(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => UserOptionsSheet<ThemeMode>(
        title: l10n.userSettingTheme,
        selected: settings.themeMode,
        options: <UserOption<ThemeMode>>[
          UserOption<ThemeMode>(
            value: ThemeMode.dark,
            label: l10n.userThemeDark,
          ),
          UserOption<ThemeMode>(
            value: ThemeMode.light,
            label: l10n.userThemeLight,
          ),
        ],
        onSelected: (mode) =>
            ref.read(appSettingsControllerProvider.notifier).setThemeMode(mode),
      ),
    );
  }

  /// 打开档案设置。带上 [field] 时把目标字段透给设置页（`?field=company`），
  /// 设置页据此定位到那一项。
  void _openProfileSettings(
    BuildContext context, {
    UserProfileFieldKey? field,
  }) {
    context.pushNamed(
      RouteName.userProfileSettings,
      queryParameters: field == null
          ? const <String, String>{}
          : <String, String>{RouteQuery.profileField: field.name},
    );
  }

  /// 指标说明弹层。文案是自造概念的解释，产品定稿前先给一版可读的。
  // TODO(product): 觉醒等级 / 契合度的真实成长规则待产品定义，文案定稿后回来替换。
  Future<void> _explainMetric(BuildContext context, _Metric metric) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => switch (metric) {
        _Metric.awakening => UserMetricExplainer(
          icon: LucideIcons.sparkles,
          title: l10n.userAwakeningLevel,
          whatItIs: l10n.userAwakeningExplainWhat,
          howToRaiseTitle: l10n.userMetricExplainHowTitle,
          howToRaise: l10n.userAwakeningExplainHow,
        ),
        _Metric.starAffinity => UserMetricExplainer(
          icon: LucideIcons.star,
          title: l10n.userStarAffinity,
          whatItIs: l10n.userStarAffinityExplainWhat,
          howToRaiseTitle: l10n.userMetricExplainHowTitle,
          howToRaise: l10n.userStarAffinityExplainHow,
        ),
      },
    );
  }

  void _comingSoon(BuildContext context) =>
      HappyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  /// 退出登录是破坏性操作：先二次确认，再执行（规范要求）。
  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.userLogoutConfirmTitle),
        content: Text(l10n.userLogoutConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.homeLogout),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(authControllerProvider.notifier).logout();
      // 成功不在此导航：登录态翻转后由 route_guard 重定向回 login。
    } on Object catch (_) {
      if (!context.mounted) return;
      HappyToast.error(context, l10n.homeLogoutFailed);
    }
  }

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.userProfileLoadFailed;

  // 骨架态的空回调：此时页面不该响应任何操作。
  static void _noop() {}
  static Future<void> _asyncNoop() async {}
  static void _ignoreField(UserProfileFieldKey _) {}
  static void _ignoreMetric(_Metric _) {}

  /// 骨架屏占位档案。字段长度刻意贴近真实值，骨架条才不会比真内容明显短一截。
  static final UserProfile _skeletonProfile = UserProfile(
    nickname: "昵称占位",
    awakeningLevel: 8,
    awakeningProgress: 0.5,
    starAffinity: 0.5,
    gender: "——",
    age: 28,
    birthday: DateTime(1996),
    zodiac: "——",
    city: "——",
    occupation: "——",
    industry: "——",
    company: "——",
    hobbies: const <String>["占位", "占位标签", "占位"],
  );
}

/// 两个成长指标，用来区分点开哪一张说明卡。
enum _Metric { awakening, starAffinity }

/// 可选语言的 languageCode。和 `AppLocalizations.supportedLocales` 一一对应，
/// 新增语言时两处都要加。
const String _languageZh = "zh";
const String _languageEn = "en";

/// 页面主体：**固定的身份区** + 可滚动的其余内容。
class _UserBody extends StatelessWidget {
  const _UserBody({
    required this.profile,
    required this.onRefresh,
    required this.onEditProfile,
    required this.onFieldTap,
    required this.onExplainMetric,
    required this.onSwitchAccount,
    required this.onContactDeveloper,
    required this.onLogout,
    required this.languageLabel,
    required this.themeLabel,
    required this.onPickLanguage,
    required this.onPickTheme,
  });

  final UserProfile profile;
  final Future<void> Function() onRefresh;
  final VoidCallback onEditProfile;
  final ValueChanged<UserProfileFieldKey> onFieldTap;
  final ValueChanged<_Metric> onExplainMetric;
  final VoidCallback onSwitchAccount;
  final VoidCallback onContactDeveloper;
  final VoidCallback onLogout;

  /// 当前语言 / 深浅色的展示文案。设置项右侧要直接看得见现在是什么，
  /// 而不是点进去才知道。
  final String languageLabel;
  final String themeLabel;

  final VoidCallback onPickLanguage;
  final VoidCallback onPickTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      children: <Widget>[
        // 固定不滚：身份区是这一页的锚点。
        Padding(
          padding: const EdgeInsets.only(
            left: HappySemanticSpacing.screenPadding,
            right: HappySemanticSpacing.screenPadding,
            top: HappySemanticSpacing.cardPadding,
            bottom: HappySemanticSpacing.cardPadding,
          ),
          child: UserProfileHeader(
            nickname: profile.nickname,
            avatarUrl: profile.avatarUrl,
            completeness: profile.profileCompleteness,
            // 百分数跟着进度环一起跳，所以这里给的是"按当前数字拼一句话"的函数。
            subtitleBuilder: (percent) => profile.isProfileComplete
                ? l10n.userProfileComplete
                : l10n.userProfileCompleteness(percent),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            // 下拉刷新不清内容（reload 默认不置 loading），刷新中已有档案留在原地。
            onRefresh: onRefresh,
            child: ListView(
              // 始终可滚动：内容不足一屏时也要能下拉刷新。
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: HappySemanticSpacing.screenPadding,
                right: HappySemanticSpacing.screenPadding,
                bottom: HappySemanticSpacing.sectionGap,
              ),
              children: <Widget>[
                Row(
                  spacing: HappySemanticSpacing.itemGap,
                  children: <Widget>[
                    Expanded(
                      child: UserMetricCard(
                        icon: LucideIcons.sparkles,
                        label: l10n.userAwakeningLevel,
                        value: l10n.userAwakeningLevelValue(
                          profile.awakeningLevel,
                        ),
                        progress: profile.awakeningProgress,
                        caption: l10n.userAwakeningCaption(
                          ((1 - profile.awakeningProgress) * 100).round(),
                        ),
                        onTap: () => onExplainMetric(_Metric.awakening),
                      ),
                    ),
                    Expanded(
                      child: UserMetricCard(
                        icon: LucideIcons.star,
                        label: l10n.userStarAffinity,
                        value: l10n.userPercentValue(
                          (profile.starAffinity * 100).round(),
                        ),
                        progress: profile.starAffinity,
                        caption: l10n.userStarAffinityCaption,
                        onTap: () => onExplainMetric(_Metric.starAffinity),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HappySemanticSpacing.sectionGap),
                UserProfileFieldsCard(
                  title: l10n.userProfileSection,
                  actionLabel: l10n.userProfileEdit,
                  onAction: onEditProfile,
                  onFieldTap: onFieldTap,
                  emptyValueLabel: l10n.userFieldEmpty,
                  hobbiesLabel: l10n.userFieldHobbies,
                  hobbiesIcon: LucideIcons.heart,
                  hobbies: profile.hobbies,
                  // 顺序：身份（性别/年龄/生日/星座）→ 所在地 → 职业三连。
                  // 生日紧跟年龄、公司紧跟行业，同源信息挨着看才不用来回跳。
                  // 每行配一个小图标做扫读锚点（找"城市"时看图标比读标签快）。
                  fields: <UserProfileField>[
                    UserProfileField(
                      key: UserProfileFieldKey.gender,
                      icon: LucideIcons.venusAndMars,
                      label: l10n.userFieldGender,
                      value: profile.gender,
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.age,
                      icon: LucideIcons.hourglass,
                      label: l10n.userFieldAge,
                      value: profile.age == null
                          ? null
                          : l10n.userAgeValue(profile.age!),
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.birthday,
                      icon: LucideIcons.cake,
                      label: l10n.userFieldBirthday,
                      value: profile.birthday == null
                          ? null
                          : DateFormat.yMMMd(locale).format(profile.birthday!),
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.zodiac,
                      icon: LucideIcons.moonStar,
                      label: l10n.userFieldZodiac,
                      value: profile.zodiac,
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.city,
                      icon: LucideIcons.mapPin,
                      label: l10n.userFieldCity,
                      value: profile.city,
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.occupation,
                      icon: LucideIcons.briefcase,
                      label: l10n.userFieldOccupation,
                      value: profile.occupation,
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.industry,
                      icon: LucideIcons.factory,
                      label: l10n.userFieldIndustry,
                      value: profile.industry,
                    ),
                    UserProfileField(
                      key: UserProfileFieldKey.company,
                      icon: LucideIcons.building2,
                      label: l10n.userFieldCompany,
                      value: profile.company,
                    ),
                  ],
                ),
                const SizedBox(height: HappySemanticSpacing.sectionGap),
                Padding(
                  padding: const EdgeInsets.only(bottom: HappySpacing.s8),
                  child: Text(
                    l10n.userPreferencesSection,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                // 偏好和功能分成两张卡：语言/深浅色是"设成什么就一直是什么"，
                // 而功能区是"点一下做一件事"，混在一起会让退出登录挨着语言设置。
                Card(
                  child: Column(
                    children: <Widget>[
                      UserActionTile(
                        icon: LucideIcons.languages,
                        label: l10n.userSettingLanguage,
                        trailingValue: languageLabel,
                        onTap: onPickLanguage,
                      ),
                      UserActionTile(
                        icon: LucideIcons.palette,
                        label: l10n.userSettingTheme,
                        trailingValue: themeLabel,
                        onTap: onPickTheme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HappySemanticSpacing.sectionGap),
                Padding(
                  padding: const EdgeInsets.only(bottom: HappySpacing.s8),
                  child: Text(
                    l10n.userActionsSection,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      UserActionTile(
                        icon: LucideIcons.userPen,
                        label: l10n.userProfileSettings,
                        onTap: onEditProfile,
                      ),
                      UserActionTile(
                        icon: LucideIcons.usersRound,
                        label: l10n.userSwitchAccount,
                        trailingHint: l10n.commonInDevelopment,
                        onTap: onSwitchAccount,
                      ),
                      UserActionTile(
                        icon: LucideIcons.messageCircle,
                        label: l10n.userContactDeveloper,
                        trailingHint: l10n.commonInDevelopment,
                        onTap: onContactDeveloper,
                      ),
                      UserActionTile(
                        icon: LucideIcons.logOut,
                        label: l10n.homeLogout,
                        isDestructive: true,
                        showChevron: false,
                        onTap: onLogout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 错误态：内联重试卡，仍然可下拉刷新。
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
      children: <Widget>[
        const SizedBox(height: HappySpacing.s40),
        HappyRetryCard(
          message: message,
          retryLabel: l10n.commonRetry,
          onRetry: onRetry,
        ),
      ],
    );
  }
}
