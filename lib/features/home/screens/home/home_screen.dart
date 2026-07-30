import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: l10n.homeLogout,
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(HappySpacing.lg),
          child: Text(
            l10n.homePlaceholder,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
