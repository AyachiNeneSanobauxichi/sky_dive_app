import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 航线 tab：可跳的机场、机型与高度档位。
///
/// 当前是**骨架**——业务文档（`agent/service/flight/`）尚未产出，这里先把
/// 页头与空态立住，保证 tab 切过来不是一片白。空态按规范带引导行动，
/// 功能未上线时给轻提示而不是静默（见 skill `17-ux-interaction.md`）。
// TODO(flight): 待 `agent/service/flight/flight.md` + `.api.md` 产出后，
//   在此实现航线列表（骨架屏 / 空 / 错误 / 有数据 四态齐全）。
class FlightScreen extends StatelessWidget {
  const FlightScreen({super.key});

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
                Text(l10n.flightsTitle, style: theme.textTheme.displaySmall),
                const SizedBox(height: SkySpacing.s4),
                Text(
                  l10n.flightsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SkyEmptyState(
              icon: LucideIcons.planeTakeoff,
              title: l10n.flightsEmptyTitle,
              description: l10n.flightsEmptyDescription,
              actionLabel: l10n.flightsEmptyAction,
              onAction: () => SkyToast.info(context, l10n.commonComingSoon),
            ),
          ),
        ],
      ),
    );
  }
}
