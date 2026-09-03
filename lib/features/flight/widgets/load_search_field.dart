import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 搜索框的胶囊描边（未聚焦时是透明的，只剩一个填充"槽"）。
final OutlineInputBorder _searchBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(SkyRadius.pill),
  borderSide: const BorderSide(color: Colors.transparent),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    ref.read(loadQueryControllerProvider.notifier).clearKeyword();
    // 清空后收起键盘：用户点 ✕ 的意图是"我看全部"，不是"我要重新搜"。
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasKeyword = ref.watch(
      loadQueryControllerProvider.select((q) => q.hasKeyword),
    );

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      style: theme.textTheme.bodyMedium,
      onChanged: ref.read(loadQueryControllerProvider.notifier).setKeyword,
      // 敲回车只收键盘：结果早就实时更新了，没有"提交"这一步。
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: l10n.loadSearchHint,
        prefixIcon: const Icon(LucideIcons.search, size: SkyIconSize.md),
        // 胶囊形 + 去掉描边：搜索框是"随手一敲"的入口，方角带框会读成
        // 表单里的一个必填项。圆角取 SkyRadius.pill（仍是令牌，不是魔法值）。
        border: _searchBorder,
        enabledBorder: _searchBorder,
        focusedBorder: _searchBorder.copyWith(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: SkyBorderWidth.thick,
          ),
        ),
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
  }
}
