import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:sky_dive/app/router/index.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/features/flight/widgets/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 新建 / 编辑航线表单页。
///
/// 深链接 `/flights/new` 与 `/flights/:loadId/edit`。新建与编辑走**同一张表单**：
/// 字段完全一样，差别只有标题、提交文案和调哪个接口。拆成两个页面必然要维护
/// 两份校验规则，改一处忘一处。
///
/// 编辑态的草稿在**拿到那条航线之后**才初始化（深链接直达时列表可能还在路上），
/// 期间先画骨架，不白屏。
class LoadFormScreen extends ConsumerStatefulWidget {
  const LoadFormScreen({super.key, this.loadId});

  /// 要编辑的航线 id；为空表示新建。
  final String? loadId;

  @override
  ConsumerState<LoadFormScreen> createState() => _LoadFormScreenState();
}

class _LoadFormScreenState extends ConsumerState<LoadFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _aircraftController = TextEditingController();

  /// 当前草稿。编辑态要等航线到位才建得出来，故可空。
  LoadDraft? _draft;

  /// 打开表单那一刻的草稿。用来判断"改过没有"，决定返回时要不要拦一道。
  LoadDraft? _initialDraft;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.removeListener(_onTextChanged);
    _aircraftController.removeListener(_onTextChanged);
    _codeController.dispose();
    _aircraftController.dispose();
    super.dispose();
  }

  /// 懒初始化草稿。
  ///
  /// 放在 build 里而不是 initState：编辑态需要先从列表里拿到那条航线，
  /// 而列表是异步的。这里只在**第一次**拿到数据时赋值（`_draft == null` 守卫），
  /// 不触发 setState，因此不会造成重建循环。
  void _ensureDraft(Load? load) {
    if (_draft != null) return;
    final draft = load == null
        ? LoadDraft.create(now: DateTime.now())
        : LoadDraft.fromLoad(load);
    _draft = draft;
    _initialDraft = draft;
    _codeController.text = draft.code;
    _aircraftController.text = draft.aircraft;
    _codeController.addListener(_onTextChanged);
    _aircraftController.addListener(_onTextChanged);
  }

  /// 文本框内容 → 草稿。
  ///
  /// 用 listener 而不是 `onChanged` + `setState`：草稿必须**每个字符**都跟上
  /// （返回拦截要靠它判断改没改过），但整张表单没必要为每个字符重画一遍。
  /// 只有"脏 / 不脏"翻转的那一下才 setState——那正是 `PopScope.canPop` 要变的时刻。
  void _onTextChanged() {
    final draft = _draft;
    if (draft == null) return;
    final next = draft.copyWith(
      code: _codeController.text,
      aircraft: _aircraftController.text,
    );
    if (next == draft) return;

    final wasDirty = _isDirty;
    _draft = next;
    if (wasDirty != _isDirty) setState(() {});
  }

  /// 改过内容没有。返回时据此决定是直接走还是先问一句。
  bool get _isDirty => _draft != null && _draft != _initialDraft;

  Future<void> _pickDate() async {
    final draft = _draft!;
    final current = draft.departureAt ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      // 不允许把航线排到过去：排班是面向未来的，往回排一定是误操作。
      firstDate: DateTime(current.year, current.month, current.day),
      lastDate: current.add(_schedulingHorizon),
    );
    if (picked == null) return;
    setState(() {
      _draft = draft.copyWith(
        departureAt: DateTime(
          picked.year,
          picked.month,
          picked.day,
          current.hour,
          current.minute,
        ),
      );
    });
  }

  Future<void> _pickTime() async {
    final draft = _draft!;
    final current = draft.departureAt ?? DateTime.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;
    setState(() {
      _draft = draft.copyWith(
        departureAt: DateTime(
          current.year,
          current.month,
          current.day,
          picked.hour,
          picked.minute,
        ),
      );
    });
  }

  /// 返回前拦一道：填了一半直接走会白填一次。
  Future<void> _onLeave() async {
    if (!_isDirty) {
      context.pop();
      return;
    }
    final l10n = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.loadFormDiscardTitle),
        content: Text(l10n.loadFormDiscardBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.commonDiscard),
          ),
        ],
      ),
    );
    if (discard == true && mounted) context.pop();
  }

  Future<void> _submit() async {
    // 提交前收键盘：成功提示在屏幕顶部，键盘占着半屏会挡住页面的变化。
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    final draft = _draft;
    if (!isValid || draft == null || !draft.isComplete) return;

    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(loadListControllerProvider.notifier);
    setState(() => _isSubmitting = true);
    try {
      final load = draft.isEditing
          ? await notifier.edit(draft)
          : await notifier.create(draft);
      if (!mounted) return;
      // 先弹提示再返回：pop 之后本页的 context 已失效，拿它找 overlay 会炸。
      SkyToast.success(
        context,
        draft.isEditing
            ? l10n.loadUpdateSuccess(load.code)
            : l10n.loadCreateSuccess(load.code),
      );
      // 新建完直接回列表；编辑完回详情页（就是上一页）。
      context.pop();
    } on Object catch (error) {
      if (!mounted) return;
      // 失败不清表单：用户填的东西一个字都不该丢，改完就能再提交一次。
      setState(() => _isSubmitting = false);
      SkyToast.error(context, loadFailureMessage(error, l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loadId = widget.loadId;
    final state = ref.watch(loadListControllerProvider);
    final load = loadId == null
        ? null
        : ref.watch(
            loadListControllerProvider.select(
              (value) => findLoadById(value.asData?.value, loadId),
            ),
          );

    // 编辑态但航线还没到 / 已经不在了：先给骨架或"航线不在了"，别渲染空表单。
    if (loadId != null && load == null) {
      return SkyBackground(
        intensity: _backgroundIntensity,
        parallax: false,
        child: SafeArea(
          bottom: false,
          child: state.hasError
              ? Padding(
                  padding: const EdgeInsets.all(
                    SkySemanticSpacing.screenPadding,
                  ),
                  child: SkyRetryCard(
                    message: loadFailureMessage(state.error!, l10n),
                    retryLabel: l10n.commonRetry,
                    onRetry: () =>
                        ref.read(loadListControllerProvider.notifier).refresh(),
                  ),
                )
              : state.hasValue
              ? SkyEmptyState(
                  icon: LucideIcons.planeLanding,
                  title: l10n.loadDetailGoneTitle,
                  description: l10n.loadDetailGoneDescription,
                  actionLabel: l10n.loadDetailBackToList,
                  onAction: () => context.goNamed(RouteName.flights),
                )
              : const _LoadFormSkeleton(),
        ),
      );
    }

    _ensureDraft(load);
    final draft = _draft!;
    final departure = draft.departureAt ?? DateTime.now();

    return PopScope(
      // 有改动时不让系统手势 / 返回键直接走，先问一句（见 _onLeave）。
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onLeave();
      },
      child: SkyBackground(
        intensity: _backgroundIntensity,
        parallax: false,
        child: SafeArea(
          bottom: false,
          child: Form(
            key: _formKey,
            child: ListView(
              // 往下拖也收键盘：和登录/注册页保持一致的肌肉记忆，
              // 长表单里手指本来就在滑动，不必先去点一次空白。
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(
                SkySemanticSpacing.screenPadding,
                SkySpacing.s8,
                SkySemanticSpacing.screenPadding,
                SkySpacing.s96,
              ),
              children: <Widget>[
                LoadHeader(
                  title: draft.isEditing
                      ? l10n.loadFormEditTitle(load!.code)
                      : l10n.loadFormCreateTitle,
                  onBack: _onLeave,
                ),
                const SizedBox(height: SkySemanticSpacing.sectionGap),

                _FieldLabel(text: l10n.loadFormCode),
                TextFormField(
                  controller: _codeController,
                  textInputAction: TextInputAction.next,
                  onTapOutside: skyDismissKeyboardOnTapOutside,
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  enabled: !_isSubmitting,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(LoadRules.codeMaxLength),
                  ],
                  validator: FormBuilderValidators.required(
                    errorText: l10n.loadFormCodeRequired,
                  ),
                  onChanged: (value) => _draft = draft.copyWith(code: value),
                  decoration: InputDecoration(
                    hintText: l10n.loadFormCodeHint,
                    prefixIcon: const Icon(
                      LucideIcons.ticket,
                      size: SkyIconSize.md,
                    ),
                  ),
                ),
                const SizedBox(height: SkySemanticSpacing.itemGap),

                _FieldLabel(text: l10n.loadFormDropZone),
                _DropZoneField(
                  selected: draft.dropZone,
                  isEnabled: !_isSubmitting,
                  onSelected: (zone) =>
                      setState(() => _draft = draft.copyWith(dropZone: zone)),
                ),
                const SizedBox(height: SkySemanticSpacing.itemGap),

                _FieldLabel(text: l10n.loadFormDeparture),
                Row(
                  spacing: SkySemanticSpacing.itemGap,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: _PickerTile(
                        icon: LucideIcons.calendar,
                        value: formatLoadDate(context, departure),
                        onTap: _isSubmitting ? null : _pickDate,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _PickerTile(
                        icon: LucideIcons.clock,
                        value: formatLoadTime(context, departure),
                        onTap: _isSubmitting ? null : _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SkySemanticSpacing.itemGap),

                _FieldLabel(text: l10n.loadFormAircraft),
                TextFormField(
                  controller: _aircraftController,
                  textInputAction: TextInputAction.done,
                  onTapOutside: skyDismissKeyboardOnTapOutside,
                  enabled: !_isSubmitting,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(
                      LoadRules.aircraftMaxLength,
                    ),
                  ],
                  validator: FormBuilderValidators.required(
                    errorText: l10n.loadFormAircraftRequired,
                  ),
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: l10n.loadFormAircraftHint,
                    prefixIcon: const Icon(
                      LucideIcons.plane,
                      size: SkyIconSize.md,
                    ),
                  ),
                ),
                const SizedBox(height: SkySemanticSpacing.itemGap),

                _FieldLabel(text: l10n.loadFormAltitude),
                _AltitudeField(
                  selected: draft.altitudeFt,
                  isEnabled: !_isSubmitting,
                  onSelected: (altitude) => setState(
                    () => _draft = draft.copyWith(altitudeFt: altitude),
                  ),
                ),
                const SizedBox(height: SkySemanticSpacing.sectionGap),

                _FieldLabel(text: l10n.loadFormCapacity),
                Text(
                  l10n.loadFormCapacityHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SkySemanticSpacing.labelGap),
                LoadCapacityStepper(
                  icon: LucideIcons.users,
                  label: l10n.loadRoleCustomers,
                  value: draft.customerCapacity,
                  min: draft.minCapacityOf(ParticipantRole.customer),
                  max: draft.maxCapacityOf(ParticipantRole.customer),
                  helperText: draft.assignedCustomers > 0
                      ? l10n.loadFormCapacityMin(draft.assignedCustomers)
                      : null,
                  onChanged: (value) => setState(
                    () => _draft = draft.withCapacity(
                      ParticipantRole.customer,
                      value,
                    ),
                  ),
                ),
                LoadCapacityStepper(
                  icon: LucideIcons.camera,
                  label: l10n.loadRolePhotographers,
                  value: draft.photographerCapacity,
                  min: draft.minCapacityOf(ParticipantRole.photographer),
                  max: draft.maxCapacityOf(ParticipantRole.photographer),
                  helperText: draft.assignedPhotographers > 0
                      ? l10n.loadFormCapacityMin(draft.assignedPhotographers)
                      : null,
                  onChanged: (value) => setState(
                    () => _draft = draft.withCapacity(
                      ParticipantRole.photographer,
                      value,
                    ),
                  ),
                ),
                const SizedBox(height: SkySemanticSpacing.sectionGap),

                SkyButton(
                  label: draft.isEditing
                      ? l10n.loadFormSubmitSave
                      : l10n.loadFormSubmitCreate,
                  icon: draft.isEditing ? LucideIcons.check : LucideIcons.plus,
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 表单页背景氛围强度。表单是信息密集页，压到 0.5 以下（见 [SkyBackground]）。
const double _backgroundIntensity = 0.3;

/// 编辑态等待航线到位时的骨架：只画页头与几条字段框，不装真数据。
class _LoadFormSkeleton extends StatelessWidget {
  const _LoadFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          SkySemanticSpacing.screenPadding,
          SkySpacing.s8,
          SkySemanticSpacing.screenPadding,
          SkySpacing.s96,
        ),
        children: <Widget>[
          const LoadHeader(title: "L-204"),
          const SizedBox(height: SkySemanticSpacing.sectionGap),
          for (int i = 0; i < _skeletonFieldCount; i++) ...<Widget>[
            const _FieldLabel(text: "\u2000\u2000\u2000\u2000"),
            Container(
              height: SkyControlSize.input,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(SkyRadius.input),
              ),
            ),
            const SizedBox(height: SkySemanticSpacing.itemGap),
          ],
        ],
      ),
    );
  }
}

/// 骨架里画几条字段框。和真实表单的字段数同量级即可，不必一一对应。
const int _skeletonFieldCount = 4;

/// 排班可以排到多久以后。一年足够覆盖季节性预售，再远就不是排班而是许愿了。
const Duration _schedulingHorizon = Duration(days: 365);

/// 字段标题。
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SkySemanticSpacing.labelGap),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

/// 日期 / 时刻选择格子。长得像输入框，但点了开系统选择器。
class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.value, this.onTap});

  final IconData icon;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: value,
      child: Material(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(SkyRadius.input),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SkyRadius.input),
          child: Container(
            constraints: const BoxConstraints(minHeight: SkyControlSize.input),
            padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SkyRadius.input),
              border: Border.all(
                color: scheme.outlineVariant,
                width: SkyBorderWidth.hairline,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  size: SkyIconSize.md,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: SkySpacing.s12),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 跳伞地点选择。
///
/// 包在 `FormField` 里而不是自己管错误态：这样"未选地点"的报错和其它字段
/// 一样由 `Form.validate()` 统一触发、就地显示在下方，不用 toast 报校验错误。
class _DropZoneField extends ConsumerWidget {
  const _DropZoneField({
    required this.selected,
    required this.isEnabled,
    required this.onSelected,
  });

  final DropZone? selected;
  final bool isEnabled;
  final ValueChanged<DropZone> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final zones = ref.watch(dropZonesProvider);

    return FormField<DropZone>(
      initialValue: selected,
      validator: (value) =>
          value == null ? l10n.loadFormDropZoneRequired : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          switch (zones) {
            AsyncData(:final value) => Wrap(
              spacing: SkySpacing.s8,
              runSpacing: SkySpacing.s8,
              children: <Widget>[
                for (final zone in value)
                  _ChoicePill(
                    label: zone.name,
                    isSelected: zone.id == field.value?.id,
                    onTap: isEnabled
                        ? () {
                            field.didChange(zone);
                            onSelected(zone);
                          }
                        : null,
                  ),
              ],
            ),
            AsyncError(:final error) => SkyRetryCard(
              message: loadFailureMessage(error, l10n),
              retryLabel: l10n.commonRetry,
              onRetry: () => ref.invalidate(dropZonesProvider),
            ),
            // 加载态用同一套 pill 喂占位文本，骨架形状天然贴合。
            _ => const Skeletonizer(
              child: Wrap(
                spacing: SkySpacing.s8,
                runSpacing: SkySpacing.s8,
                children: <Widget>[
                  _ChoicePill(label: "藤岡スカイダイビングクラブ", isSelected: false),
                  _ChoicePill(label: "関宿滑空場", isSelected: false),
                ],
              ),
            ),
          },
          if (field.hasError) ...<Widget>[
            const SizedBox(height: SkySemanticSpacing.labelGap),
            Text(
              field.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 出舱高度档位。固定几档而不是自由输入：高度受机型与空域限制，
/// 自由输入只会填出 13,750 这种执行不了的数。
class _AltitudeField extends StatelessWidget {
  const _AltitudeField({
    required this.selected,
    required this.isEnabled,
    required this.onSelected,
  });

  final int selected;
  final bool isEnabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SkySpacing.s8,
      runSpacing: SkySpacing.s8,
      children: <Widget>[
        for (final altitude in LoadRules.altitudeOptions)
          _ChoicePill(
            label: formatAltitude(context, altitude),
            isSelected: altitude == selected,
            onTap: isEnabled ? () => onSelected(altitude) : null,
          ),
      ],
    );
  }
}

/// 单选药丸（地点 / 高度共用）。
class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: isSelected ? scheme.primary : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(SkyRadius.chip),
        child: InkWell(
          // onTap 为空即禁用：提交中不该还能改选项。
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          borderRadius: BorderRadius.circular(SkyRadius.chip),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: SkyControlSize.minTapTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SkyRadius.chip),
              border: Border.all(
                color: isSelected ? scheme.primary : scheme.outlineVariant,
                width: SkyBorderWidth.hairline,
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
