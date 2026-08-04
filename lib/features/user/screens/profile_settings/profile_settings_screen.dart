import "package:flutter/material.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:happy_os/features/user/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 个人档案设置页（v2 占位）。
///
/// 本期只有空态：真实表单（昵称 / 头像 / 星座 / 职业 …）要等
/// `agent/service/user/user.api.md` 定稿——不知道字段可选值与校验规则时先写一版表单，
/// 契约来了必然重写。
///
/// 它是深入页（从 user tab push 进来），所以带返回箭头且盖住底部 tab 栏——
/// 表单页要独占屏幕，底部再顶一条导航会和保存按钮抢位置。
///
/// [targetField] 是从档案卡某一行点进来时带上的字段（`?field=company`）：真实表单
/// 就绪后要据此滚动并聚焦到那一项；现在先在文案里点名"你要补的是哪一项"，
/// 让这条链路是真的通的、而不是一个被忽略的参数。
// TODO(user): 接 user.api.md 后换成真实档案表单（字段校验统一用 form_builder_validators），
//   并用 targetField 做锚点定位 + 自动聚焦。
class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key, this.targetField});

  final UserProfileFieldKey? targetField;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final field = targetField;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userProfileSettings)),
      body: HappyAuroraBackground(
        intensity: 0.4,
        child: HappyEmptyState(
          icon: LucideIcons.userPen,
          title: l10n.userProfileSettingsEmptyTitle,
          description: field == null
              ? l10n.userProfileSettingsEmptyBody
              : l10n.userProfileSettingsEmptyBodyForField(
                  userProfileFieldLabel(l10n, field),
                ),
          actionLabel: l10n.userProfileSettingsEmptyAction,
          onAction: () => HappyToast.info(context, l10n.commonComingSoon),
        ),
      ),
    );
  }
}
