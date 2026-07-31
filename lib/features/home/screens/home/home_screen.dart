import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 首页占位：模版业务已清空，等 HappyOS 首个 feature 落地后替换本页。
///
/// 之所以保留这一页而不是直接删掉 home 路由：登录成功后的重定向目标
/// （[RouteName.home]）由 route_guard 依赖，缺页会让整条登录链路断掉。
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// 登出失败时给出轻提示，避免用户以为点击无响应。
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } on Object catch (_) {
      if (!context.mounted) {
        return;
      }
      HappyToast.error(context, AppLocalizations.of(context).homeLogoutFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      // 占位期先给氛围。真实首页若是信息密集列表，记得调低 intensity 或去掉极光。
      body: HappyAuroraBackground(
        intensity: 0.6,
        // 内层 Scaffold 只为借用 AppBar 布局，背景透明让极光透上来
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(l10n.homeTitle),
            actions: <Widget>[
              IconButton(
                tooltip: l10n.homeLogout,
                icon: const Icon(LucideIcons.logOut),
                onPressed: () => _logout(context, ref),
              ),
              const SizedBox(width: HappySpacing.s8),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: HappySpacing.s24,
                children: <Widget>[
                  const HappyBrandMark(icon: LucideIcons.bookOpen),
                  Text(
                    l10n.homePlaceholder,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: HappyMotion.slow, curve: HappyMotion.standard);
  }
}
