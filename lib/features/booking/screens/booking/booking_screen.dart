import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 预约 tab：我的预约、行程状态与改期退款。
///
/// 当前是**骨架**——业务文档（`agent/service/booking/`）尚未产出，这里先把
/// 页头与空态立住，保证 tab 切过来不是一片白。空态按规范带引导行动
/// （"还没有预约"要能一步跳去航线列表，而不是只写一句"暂无数据"）。
// TODO(booking): 待 `agent/service/booking/booking.md` + `.api.md` 产出后，
//   在此实现预约列表（骨架屏 / 空 / 错误 / 有数据 四态齐全），
//   并把空态的行动改成 goNamed(RouteName.flights)。
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SkySemanticSpacing.screenPadding,
              SkySpacing.s24,
              SkySemanticSpacing.screenPadding,
              SkySpacing.none,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l10n.bookingsTitle, style: theme.textTheme.displaySmall),
                const SizedBox(height: SkySpacing.s4),
                Text(
                  l10n.bookingsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SkyEmptyState(
              icon: LucideIcons.calendarCheck,
              title: l10n.bookingsEmptyTitle,
              description: l10n.bookingsEmptyDescription,
              actionLabel: l10n.bookingsEmptyAction,
              onAction: () => SkyToast.info(context, l10n.commonComingSoon),
            ),
          ),
        ],
      ),
    );
  }
}
