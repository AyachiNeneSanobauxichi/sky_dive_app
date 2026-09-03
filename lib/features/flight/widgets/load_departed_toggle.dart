import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 日期段末的「已起飞」折叠行。
///
/// 用文字按钮而不是一整块可点的行：它是**次要**入口，长得像一条内容行反而会抢走
/// "还能约的班次"的注意力。展开状态由箭头方向交代（下 = 还能展开，上 = 可收起）。
///
/// 左边那截虚线见 [_TimelineBreak]。
class LoadDepartedToggle extends StatelessWidget {
  const LoadDepartedToggle({
    super.key,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
  });

  /// 这一天有几班已经飞走了。
  final int count;

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: <Widget>[
        const _TimelineBreak(),
        const SizedBox(width: SkySemanticSpacing.labelGap),
        Flexible(
          child: TextButton.icon(
            onPressed: onToggle,
            icon: Icon(
              isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
              size: SkyIconSize.sm,
            ),
            label: Text(
              isExpanded
                  ? l10n.loadDepartedHide(count)
                  : l10n.loadDepartedShow(count),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

/// 折叠行左侧的一小段**虚线**：时间顺序在这里断开了。
///
/// 为什么需要它：「最早优先」排序下，已起飞的班次本来排在最前，被搬到段末之后
/// 这一列时刻会突然往回跳一截（14:00 之后接着 08:00）。虚线把"下面这段不在
/// 顺序里"画出来——换成实线只会被读成又一条普通的分组分隔。
class _TimelineBreak extends StatelessWidget {
  const _TimelineBreak();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(_breakWidth, SkyBorderWidth.hairline),
      painter: _DashedLinePainter(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }
}

/// 横向虚线。Flutter 没有内置虚线，短短一段不值得引依赖，自己画。
class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;
    final y = size.height / 2;
    for (double x = 0; x < size.width; x += _dashLength + _dashGap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + _dashLength).clamp(0, size.width), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// 虚线总长。只要"一小截"就够暗示断点，长了会读成分隔整页的横线。
const double _breakWidth = SkySpacing.s24;

/// 单段划线与间隙。
const double _dashLength = SkySpacing.s4;
const double _dashGap = SkySpacing.s4;
