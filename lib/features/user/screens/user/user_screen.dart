import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// user 模块占位页（v1）。
///
/// 模块职责：**用户设定**——账号信息与生成偏好（昵称 / 头像 / 故事风格 / 语气强度 /
/// 内容边界），相当于 story 生成时的"作者设定"。首页第 3 个 tab。
///
/// 退出登录归本模块（v1 之前挂在首页 AppBar，现移入）：它是账号操作，不该出现在
/// 每个 tab 的标题栏上。
// TODO(user): 接入真实设定项（等 agent/service/user/user.api.md 定稿）。
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  /// 登出失败给轻提示，避免用户以为点击无响应。
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
      // 成功不在此导航：登录态翻转后由 route_guard 重定向回 login。
    } on Object catch (_) {
      if (!context.mounted) return;
      HappyToast.error(context, AppLocalizations.of(context).homeLogoutFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.userTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.homeLogout,
            icon: const Icon(LucideIcons.logOut),
            onPressed: () => _logout(context, ref),
          ),
          const SizedBox(width: HappySpacing.s8),
        ],
      ),
      body: HappyEmptyState(
        icon: LucideIcons.userRound,
        title: l10n.userEmptyTitle,
        description: l10n.userEmptyBody,
        actionLabel: l10n.userEmptyAction,
        onAction: () => HappyToast.info(context, l10n.commonComingSoon),
      ),
    );
  }
}
