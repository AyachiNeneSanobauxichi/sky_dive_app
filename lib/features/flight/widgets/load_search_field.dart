import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 搜索框的胶囊描边。
///
/// 圆角取 [SkyRadius.pill]：搜索是"随手一敲"的入口，方角带框会读成表单里的必填项。
OutlineInputBorder _searchBorder(Color color, double width) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(SkyRadius.pill),
      borderSide: BorderSide(color: color, width: width),
    );

/// 航线搜索框。
///
/// 过滤是**纯本地**的，所以逐字即时生效、不做防抖——防抖只在"每敲一个字就发一次
/// 请求"时才有意义，本地过滤加了防抖只会让用户觉得列表反应迟钝。
///
/// 搜索词存在 provider 里（不是本地 `setState`）：航线 tab 常驻挂载，
/// 切到别的 tab 再回来，搜索词与结果必须还在。
class LoadSearchField extends ConsumerStatefulWidget {
  const LoadSearchField({super.key});

  @override
  ConsumerState<LoadSearchField> createState() => _LoadSearchFieldState();
}

class _LoadSearchFieldState extends ConsumerState<LoadSearchField> {
  late final TextEditingController _controller = TextEditingController(
    // 回到本 tab 时用 provider 里的值回填，输入框和列表才不会对不上。
    text: ref.read(loadQueryControllerProvider).keyword,
  );

  /// 自己持有焦点节点：「取消」按钮要跟着聚焦态出现/消失，也要能主动收键盘。
  final FocusNode _focusNode = FocusNode();

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus == _hasFocus) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _onClear() {
    _controller.clear();
    ref.read(loadQueryControllerProvider.notifier).clearKeyword();
    // 清空后收起键盘：用户点 ✕ 的意图是"我看全部"，不是"我要重新搜"。
    _focusNode.unfocus();
  }

  /// 取消这次搜索：清词 + 收键盘，一步回到"看全部"。
  void _onCancel() {
    HapticFeedback.selectionClick();
    _onClear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final hasKeyword = ref.watch(
      loadQueryControllerProvider.select((q) => q.hasKeyword),
    );

    final field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      textInputAction: TextInputAction.search,
      onTapOutside: skyDismissKeyboardOnTapOutside,
      autocorrect: false,
      style: theme.textTheme.bodyMedium,
      onChanged: ref.read(loadQueryControllerProvider.notifier).setKeyword,
      // 敲回车只收键盘：结果早就实时更新了，没有"提交"这一步。
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: l10n.loadSearchHint,
        prefixIcon: const Icon(LucideIcons.search, size: SkyIconSize.md),
        // 半透明磨砂填充 + 发丝描边。吸顶条不再铺白底之后，这个胶囊是**直接浮在
        // 天幕上**的：让天空的蓝透上来一点，它才像贴在天上，而不是压在一块白板上
        // （原先是"白底 + 灰槽"两层近白叠着，最显脏）。描边是必需的——纯半透明
        // 填充会和天幕糊成一片，看不出这是个能敲字的槽。
        filled: true,
        fillColor: scheme.surface.withValues(
          alpha: isDark ? _fillAlphaDark : _fillAlphaLight,
        ),
        border: _searchBorder(scheme.outlineVariant, SkyBorderWidth.hairline),
        enabledBorder: _searchBorder(
          scheme.outlineVariant,
          SkyBorderWidth.hairline,
        ),
        focusedBorder: _searchBorder(scheme.primary, SkyBorderWidth.thick),
        // 有内容才出清除按钮：空框上挂一个 ✕ 只会让人以为能点。
        suffixIcon: hasKeyword
            ? IconButton(
                onPressed: _onClear,
                tooltip: l10n.loadSearchClear,
                icon: const Icon(LucideIcons.x, size: SkyIconSize.md),
              )
            : null,
      ),
    );

    // 浅色天幕的上半段颜色最浅，半透明胶囊 + 发丝描边在那一带对比偏弱。补一道
    // 卡片级阴影把它从天上"抬"起来（iOS 搜索栏的做法）。阴影透过 0.66 的填充只
    // 剩两三个百分点，且 y+6 让它主要落在下沿外侧——读起来是"胶囊有厚度"，不显脏。
    //
    // 深色不加：深色底上投黑影等于什么都没发生，层级靠表面色阶表达。
    final Widget slot = isDark
        ? field
        : DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SkyRadius.pill),
              boxShadow: SkyShadows.card(theme.brightness),
            ),
            child: field,
          );

    return Row(
      children: <Widget>[
        Expanded(child: slot),
        // 聚焦时才给「取消」。空框聚焦时用户是**没有退出出口**的（✕ 只在有内容时
        // 才出现），只能去猜"点哪儿能收键盘"；这颗按钮把出口摆明。
        // 用 AnimatedSize 横向展开而不是硬跳出来，搜索框收窄的过程才跟得上眼睛。
        AnimatedSize(
          duration: SkyMotion.fast,
          curve: SkyMotion.standard,
          alignment: AlignmentDirectional.centerStart,
          child: _hasFocus
              ? Padding(
                  padding: const EdgeInsets.only(left: SkySpacing.s4),
                  child: TextButton(
                    onPressed: _onCancel,
                    child: Text(l10n.commonCancel),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// 磨砂填充的不透明度。比吸顶"雾带"淡一档：雾要压住内容，输入槽只要能被认出来。
const double _fillAlphaLight = 0.66;
const double _fillAlphaDark = 0.5;
