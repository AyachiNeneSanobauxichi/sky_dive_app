import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sky_dive/core/settings/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/account/widgets/index.dart";
import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 账号 tab：身份卡 + 外观 / 语言偏好 + 关于 + 退出登录。
///
/// 这一页刻意把**外观与语言**放在很靠前的位置：深浅两套主题都是一等设计目标，
/// 得让用户一眼找得到开关；语言同理——现场的外国游客第一件事就是找语言切换。
///
/// 个人资料的编辑（改名、补邮箱、体重与紧急联系人）尚未有业务文档，
/// 入口先给轻提示，不做静默的死按钮。
// TODO(account): 待 `agent/service/account/account.md` 产出后接入资料编辑页。
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  /// 登出请求在途。成功后的跳转由路由守卫依据全局登录态完成，故无需本地导航。
  bool _isLoggingOut = false;

  Future<void> _onLogout() async {
    final l10n = AppLocalizations.of(context);

    // 退出登录是破坏性操作（要重新登录才能回来），必须二次确认。
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.accountLogoutConfirmTitle),
        content: Text(l10n.accountLogoutConfirmBody),
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
            child: Text(l10n.accountLogout),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    // 破坏性操作确认后给一次中等强度触感，与普通点击区分开。
    HapticFeedback.mediumImpact();
    setState(() => _isLoggingOut = true);
    // 跨 await 先拿住 notifier：登出成功会触发重定向，这一帧之后本页可能已卸载。
    await ref.read(authControllerProvider.notifier).logout();
    // 登出永远"成功"（服务端失败也照清本地，见 AuthController.logout），
    // 所以这里不解锁按钮——马上就要换页了。
  }

  void _onComingSoon() =>
      SkyToast.info(context, AppLocalizations.of(context).commonComingSoon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsControllerProvider);
    final settingsNotifier = ref.read(appSettingsControllerProvider.notifier);
    final user = ref.watch(authControllerProvider).asData?.value.userOrNull;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          SkySemanticSpacing.screenPadding,
          SkySpacing.s24,
          SkySemanticSpacing.screenPadding,
          SkySemanticSpacing.sectionGap,
        ),
        children: <Widget>[
          Text(l10n.accountTitle, style: theme.textTheme.displaySmall),
          const SizedBox(height: SkySemanticSpacing.sectionGap),

          // user 为 null 只可能出现在"守卫还没把人踢走"的那一两帧，
          // 用骨架占位而不是空白，避免整块内容闪一下。
          if (user != null)
            AccountProfileCard(user: user)
          else
            const _ProfileCardPlaceholder(),
          const SizedBox(height: SkySemanticSpacing.sectionGap),

          AccountSection(
            title: l10n.accountAppearance,
            children: <Widget>[
              for (final mode in _appearanceModes)
                AccountOptionTile(
                  icon: _appearanceIcon(mode),
                  label: _appearanceLabel(mode, l10n),
                  description: mode == ThemeMode.system
                      ? l10n.accountAppearanceSystemHint
                      : null,
                  isSelected: settings.themeMode == mode,
                  onTap: () => settingsNotifier.setThemeMode(mode),
                ),
            ],
          ),
          const SizedBox(height: SkySemanticSpacing.sectionGap),

          AccountSection(
            title: l10n.accountLanguage,
            children: <Widget>[
              for (final option in AppLanguageOption.values)
                AccountOptionTile(
                  icon: option.locale == null
                      ? LucideIcons.smartphone
                      : LucideIcons.languages,
                  label: option.label(l10n),
                  isSelected:
                      settings.locale?.languageCode ==
                      option.locale?.languageCode,
                  onTap: () => settingsNotifier.setLocale(option.locale),
                ),
            ],
          ),
          const SizedBox(height: SkySemanticSpacing.sectionGap),

          AccountSection(
            title: l10n.accountAbout,
            children: <Widget>[
              AccountOptionTile(
                icon: LucideIcons.userPen,
                label: l10n.accountEditProfile,
                onTap: _onComingSoon,
              ),
              AccountOptionTile(
                icon: LucideIcons.fileText,
                label: l10n.authTerms,
                onTap: _onComingSoon,
              ),
              AccountOptionTile(
                icon: LucideIcons.shieldCheck,
                label: l10n.authPrivacy,
                onTap: _onComingSoon,
              ),
            ],
          ),
          const SizedBox(height: SkySemanticSpacing.sectionGap),

          SkyButton(
            label: l10n.accountLogout,
            variant: SkyButtonVariant.danger,
            icon: LucideIcons.logOut,
            isLoading: _isLoggingOut,
            onPressed: _onLogout,
          ),
        ],
      ),
    ).animate().fadeIn(duration: SkyMotion.normal, curve: SkyMotion.standard);
  }
}

/// 外观三档。用列表常量而不是 `ThemeMode.values`：`ThemeMode` 的枚举顺序是
/// system / light / dark，正好是我们要的展示顺序，但依赖它就等于依赖 SDK 的实现细节。
const List<ThemeMode> _appearanceModes = <ThemeMode>[
  ThemeMode.system,
  ThemeMode.light,
  ThemeMode.dark,
];

IconData _appearanceIcon(ThemeMode mode) => switch (mode) {
  ThemeMode.system => LucideIcons.smartphone,
  ThemeMode.light => LucideIcons.sun,
  ThemeMode.dark => LucideIcons.moonStar,
};

String _appearanceLabel(ThemeMode mode, AppLocalizations l10n) =>
    switch (mode) {
      ThemeMode.system => l10n.accountAppearanceSystem,
      ThemeMode.light => l10n.accountAppearanceLight,
      ThemeMode.dark => l10n.accountAppearanceDark,
    };

/// 身份卡的占位骨架。只在登录态刚翻转的那一两帧出现。
class _ProfileCardPlaceholder extends StatelessWidget {
  const _ProfileCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SkyGlassCard(
      padding: EdgeInsets.all(SkySpacing.s20),
      child: SizedBox(height: _placeholderHeight, width: double.infinity),
    );
  }
}

const double _placeholderHeight = 64;
