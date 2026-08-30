import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/weather/controllers/index.dart";
import "package:sky_dive/features/weather/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/utils/index.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 今日放飞窗口卡（登录页首屏）。
///
/// ## 为什么它在登录页上
/// 跳伞客人打开 app 的第一诉求是「**今天能不能跳**」，不是登录。把答案前置到
/// 第一屏，登录就从"门槛"变成"顺手做的事"；而且这条信息不需要鉴权，
/// 没有任何理由藏在登录之后。
///
/// ## 三态齐全
/// 加载走骨架屏（用**同一个** [_WeatherContent] 喂占位数据，形状天然贴合）、
/// 失败内联重试（不清屏、不弹窗）、有数据入场淡入。
/// 空态不适用：这个接口要么给出判断，要么就是失败。
class WeatherWindowCard extends ConsumerWidget {
  const WeatherWindowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(weatherWindowControllerProvider);

    return SkyGlassCard(
      padding: const EdgeInsets.all(SkySemanticSpacing.cardPadding),
      // 高度随三态变化，用 AnimatedSize 过渡——骨架换成真数据时
      // 下面的整张表单不该"跳"一下。
      child: AnimatedSize(
        duration: SkyMotion.normal,
        curve: SkyMotion.standard,
        alignment: Alignment.topCenter,
        child: switch (state) {
          AsyncData(:final value) => _WeatherContent(window: value),
          AsyncError(:final error) => _WeatherError(
            message: localizedFailureMessage(error, l10n),
            onRetry: () =>
                ref.read(weatherWindowControllerProvider.notifier).retry(),
          ),
          _ => const Skeletonizer(child: _WeatherContent.placeholder()),
        },
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.window});

  /// 骨架屏用的占位数据。字段长度贴近真实值，骨架条的宽度才不会失真。
  const _WeatherContent.placeholder()
    : window = const WeatherWindow(
        dropZone: "藤岡スカイダイビングクラブ",
        status: JumpStatus.go,
        temperatureC: 20,
        windSpeedMps: 3.0,
        observedAt: null,
      );

  final WeatherWindow window;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final visual = _StatusVisual.of(window.status, theme.colorScheme);
    final observedAt = window.observedAt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(visual.icon, size: SkyIconSize.md, color: visual.color),
            const SizedBox(width: SkySpacing.s8),
            Expanded(
              child: Text(
                visual.label(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: visual.color,
                ),
              ),
            ),
            if (observedAt != null)
              Text(
                // 时刻跟随 locale 格式化，不手拼字符串。
                l10n.weatherObservedAt(DateFormat.Hm().format(observedAt)),
                style: theme.textTheme.labelSmall,
              ),
          ],
        ),
        const SizedBox(height: SkySpacing.s6),
        Text(
          window.dropZone,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SkySemanticSpacing.itemGap),
        Row(
          children: <Widget>[
            _Metric(
              icon: LucideIcons.wind,
              // 跳伞看的是风速（m/s）不是风级，这是行业惯例，别换算。
              value: l10n.weatherWind(window.windSpeedMps.toStringAsFixed(1)),
            ),
            const SizedBox(width: SkySpacing.s20),
            _Metric(
              icon: LucideIcons.thermometer,
              value: l10n.weatherTemperature(window.temperatureC),
            ),
          ],
        ),
      ],
    );
  }
}

/// 一条指标（风速 / 温度）。
class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: SkyIconSize.sm,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: SkySpacing.s6),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

/// 失败态：**内联**在卡片里，不是弹窗也不是整页错误。
class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Row(
      children: <Widget>[
        Icon(
          LucideIcons.cloudOff,
          size: SkyIconSize.md,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: SkySpacing.s12),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(
          height: SkyControlSize.minTapTarget,
          child: SkyButton(
            label: l10n.commonRetry,
            variant: SkyButtonVariant.ghost,
            size: SkyButtonSize.small,
            isFullWidth: false,
            onPressed: onRetry,
          ),
        ),
      ],
    );
  }
}

/// 放飞状态 → 图标与配色。
///
/// 三种状态刻意用**语义色**而不是品牌色：这是安全相关的判断，
/// 绿=可跳 / 橙=临界 / 红=停飞是全世界通用的读法，
/// 用品牌蓝去表达"可跳"只会让人多想一秒。
class _StatusVisual {
  const _StatusVisual({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String Function(AppLocalizations) label;

  static _StatusVisual of(JumpStatus status, ColorScheme scheme) =>
      switch (status) {
        JumpStatus.go => _StatusVisual(
          icon: LucideIcons.circleCheck,
          // colorScheme 里没有"成功"这一角色，跳伞的"可跳"又必须是绿的。
          // 这是本项目唯一一处业务层直接指定颜色，理由是安全语义 > 品牌一致性。
          // TODO(theme): 语义色（success / warning）应下沉成 ThemeExtension，
          //   届时这里改成 Theme.of(context).extension<SkySemanticColors>()。
          color: scheme.brightness == Brightness.dark
              ? const Color(0xFF34D399)
              : const Color(0xFF0B7D55),
          label: (l10n) => l10n.weatherStatusGo,
        ),
        JumpStatus.marginal => _StatusVisual(
          icon: LucideIcons.circleAlert,
          color: scheme.tertiary,
          label: (l10n) => l10n.weatherStatusMarginal,
        ),
        JumpStatus.hold => _StatusVisual(
          icon: LucideIcons.circleSlash,
          color: scheme.error,
          label: (l10n) => l10n.weatherStatusHold,
        ),
      };
}
