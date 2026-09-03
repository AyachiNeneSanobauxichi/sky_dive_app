import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/features/flight/widgets/load_failure_message.dart";
import "package:sky_dive/features/flight/widgets/load_header.dart";
import "package:sky_dive/features/flight/widgets/participant_tile.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 选人弹层：从候选池里挑一个人排进航线。
///
/// 已经在这条航线上的人**不出现在列表里**（由 `assignableParticipantsProvider`
/// 剔除）——让用户选完再报"这个人已在名单上"，是先诱导他犯错再纠正。
///
/// 本弹层只负责"选出一个人"，真正的分配由调用方发起：弹层里发请求的话，
/// 请求还没回来弹层就关了，成功 / 失败提示会没有落脚的地方。
class ParticipantPickerSheet extends ConsumerStatefulWidget {
  const ParticipantPickerSheet._({required this.loadId, required this.role});

  final String loadId;
  final ParticipantRole role;

  /// 打开选择器。返回被选中的人；用户直接关掉弹层则返回 null。
  static Future<LoadParticipant?> show(
    BuildContext context, {
    required String loadId,
    required ParticipantRole role,
  }) => showModalBottomSheet<LoadParticipant>(
    context: context,
    // useRootNavigator 必需：这一屏在 `StatefulShellRoute` 的分支 Navigator 里，
    // 默认的弹层会挂到分支 Navigator 上，而底部导航条在外壳 Scaffold 上——
    // 结果就是条子盖住弹层底部（最后一个选项点不到）。挂到根 Navigator 才盖得住它。
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ParticipantPickerSheet._(loadId: loadId, role: role),
  );

  @override
  ConsumerState<ParticipantPickerSheet> createState() =>
      _ParticipantPickerSheetState();
}

class _ParticipantPickerSheetState
    extends ConsumerState<ParticipantPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _keyword = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 候选人不多，按姓名 / 备注做一次本地包含匹配就够，不必分词。
  List<LoadParticipant> _filter(List<LoadParticipant> people) {
    final keyword = _keyword.trim().toLowerCase();
    if (keyword.isEmpty) return people;
    return people
        .where((p) => p.searchText.toLowerCase().contains(keyword))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCustomer = widget.role == ParticipantRole.customer;
    final people = ref.watch(
      assignableParticipantsProvider(widget.loadId, widget.role),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * _sheetMaxHeightFactor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SkySemanticSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LoadHeader(
                    title: isCustomer
                        ? l10n.loadPickCustomerTitle
                        : l10n.loadPickPhotographerTitle,
                  ),
                  const SizedBox(height: SkySemanticSpacing.itemGap),
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onTapOutside: skyDismissKeyboardOnTapOutside,
                    autocorrect: false,
                    onChanged: (value) => setState(() => _keyword = value),
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: l10n.loadPickSearchHint,
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        size: SkyIconSize.md,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SkySemanticSpacing.itemGap),
            Flexible(
              child: switch (people) {
                AsyncData(:final value) => _PickerList(
                  people: _filter(value),
                  onPicked: (participant) =>
                      Navigator.of(context).pop(participant),
                ),
                AsyncError(:final error) => Padding(
                  padding: const EdgeInsets.all(
                    SkySemanticSpacing.screenPadding,
                  ),
                  child: SkyRetryCard(
                    message: loadFailureMessage(error, l10n),
                    retryLabel: l10n.commonRetry,
                    onRetry: () => ref.invalidate(
                      assignableParticipantsProvider(
                        widget.loadId,
                        widget.role,
                      ),
                    ),
                  ),
                ),
                _ => const _PickerSkeleton(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 弹层最多占屏幕的多少高度。留出上方一截，用户始终看得见"下面还有个页面"，
/// 心里有"这是个弹层、可以关掉"的预期。
const double _sheetMaxHeightFactor = 0.85;

class _PickerList extends StatelessWidget {
  const _PickerList({required this.people, required this.onPicked});

  final List<LoadParticipant> people;
  final ValueChanged<LoadParticipant> onPicked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (people.isEmpty) {
      return SkyEmptyState(
        icon: LucideIcons.userSearch,
        title: l10n.loadPickEmptyTitle,
        description: l10n.loadPickEmptyDescription,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
        SkySemanticSpacing.screenPadding,
        SkySpacing.none,
        SkySemanticSpacing.screenPadding,
        SkySemanticSpacing.sectionGap,
      ),
      itemCount: people.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: SkySemanticSpacing.labelGap),
      itemBuilder: (context, index) {
        final participant = people[index];
        return ParticipantTile(
          participant: participant,
          onTap: () => onPicked(participant),
          trailingIcon: LucideIcons.plus,
        );
      },
    );
  }
}

/// 加载骨架：用同一套条目 widget 喂占位数据，形状天然贴合。
class _PickerSkeleton extends StatelessWidget {
  const _PickerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: SkySemanticSpacing.screenPadding,
        ),
        itemCount: _skeletonCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SkySemanticSpacing.labelGap),
        itemBuilder: (_, _) => const ParticipantTile(
          participant: LoadParticipant(
            id: "placeholder",
            name: "佐藤 美咲",
            role: ParticipantRole.customer,
            detail: "体験ジャンプ · 初回",
          ),
        ),
      ),
    );
  }
}

const int _skeletonCount = 6;
