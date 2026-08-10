import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/user/controllers/index.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:happy_os/features/user/widgets/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 个人档案编辑页（v4）。
///
/// ## 表单只做用户能亲手填的那些
/// 年龄和星座**不给输入框**：两者都由生日推导（见 `profile_derivations.dart`），
/// 各填一遍只会制造"生日 1996-10、星座填金牛"这种自相矛盾的素材，而这些素材正是
/// 拿去写故事的。生日填对，两者自动跟上，并就地显示出来让用户确认推导是对的。
///
/// 契约里还有童年/高光/低谷/未来愿景等"人生节点"字段，那是 track 模块的地盘，
/// 不在本表单范围内，保存时也不回传——发 null 过去等于把别处填的内容清空
/// （见 `UpdateUserProfileRequestDto`）。
///
/// ## 四态
/// 加载=骨架屏（表单形状的骨架，不是转圈）· 错误=内联重试卡 · 有数据=表单。
/// 空态不存在：档案实体永远有值，只是字段可能全空。
///
/// [targetField] 是从档案卡某一行点进来时带的字段（`?field=company`）：进页面后
/// 自动滚到那一项并高亮一下，用户不用自己在长表单里找。
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key, this.targetField});

  final UserProfileFieldKey? targetField;

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  /// 目标字段那一行的位置，用来进页面后滚过去。
  final _targetKey = GlobalKey();

  /// 表单的工作副本。**编辑的是它，不是 provider 里的档案**——不落盘的中间态不该
  /// 污染全局状态，否则用户改到一半返回，个人页显示的就是没保存的内容。
  UserProfile? _draft;

  /// 进页面时那一份档案。和 [_draft] 一比就知道有没有改动，
  /// 不用给每个输入框各挂一个"脏了"的标志。
  UserProfile? _original;

  bool _isSaving = false;

  /// 已经把远端档案灌进 [_draft]。只灌一次：保存成功后 provider 会推新值，
  /// 再灌一次会把用户接着改的内容冲掉。
  bool _hydrated = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 首次拿到档案时建立工作副本，并滚到目标字段。
  void _hydrate(UserProfile profile) {
    if (_hydrated) return;
    _hydrated = true;
    _draft = profile;
    _original = profile;
    if (widget.targetField == null) return;
    // 等表单真正布局完再滚：这一帧目标行还没有位置。
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
  }

  void _scrollToTarget() {
    final context = _targetKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: HappyMotion.normal,
      curve: HappyMotion.standard,
      // 滚到靠上的位置而不是刚好露出来：目标项下面还有输入框，
      // 贴着屏幕底边的话键盘一弹就被盖住了。
      alignment: _targetAlignment,
    );
  }

  void _edit(UserProfile Function(UserProfile draft) change) =>
      setState(() => _draft = change(_draft!));

  Future<void> _pickBirthday() async {
    final draft = _draft!;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: draft.birthday ?? DateTime(now.year - _defaultAgeGuess),
      firstDate: DateTime(now.year - _maxAge),
      // 生日不可能在未来。不设上限的话用户能挑到明年，年龄就成了负数。
      lastDate: now,
    );
    if (picked == null) return;
    _edit(
      (d) => d.copyWith(
        birthday: picked,
        // 年龄与星座是生日的函数，跟着一起更新——它们也要随保存发回后端。
        age: ageFromBirthday(picked),
        zodiac: zodiacFromBirthday(picked),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    final draft = _draft!;

    // 没有档案 id 就没法走 update。这是"后端还没给这个账号建档"的情况，
    // 说清楚而不是让用户点了保存看着转圈然后报一句看不懂的错。
    if ((draft.id ?? "").isEmpty) {
      HappyToast.error(context, l10n.userProfileEditNoProfile);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      await ref.read(userProfileControllerProvider.notifier).save(draft);
      if (!mounted) return;
      // 存进去了就不再算"未保存"。这里的 `pop()` 是显式的、不经 PopScope，
      // 不改也能退出去；但留着一个"永远是脏的"状态迟早会被下一个人踩到。
      _original = draft;
      HappyToast.success(context, l10n.userProfileEditSaved);
      Navigator.of(context).pop();
    } on Object catch (e) {
      if (!mounted) return;
      // 失败**不清空表单**：用户填的内容原样留着，改完网络再点一次就行。
      HappyToast.error(context, _messageOf(e, l10n));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _messageOf(Object error, AppLocalizations l10n) =>
      error is Failure ? error.displayMessage : l10n.userProfileLoadFailed;

  /// 有没有没保存的改动。Freezed 的 `==` 是值相等（列表也按内容比），
  /// 所以改了再改回来不算脏——那时确实没什么可丢的。
  bool get _isDirty => _original != null && _draft != _original;

  /// 带着未保存的改动返回：二次确认。
  ///
  /// 这一页填一次的成本很高（十来项），手滑点一下返回箭头就全没了。
  /// 和生成页「离开会丢掉这次生成」是同一套模式。
  Future<bool> _confirmLeave(AppLocalizations l10n) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.userProfileEditLeaveTitle),
        content: Text(l10n.userProfileEditLeaveBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            // 丢弃是破坏性的，用错误色标出来——别让它和"取消"看起来一样安全。
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.userProfileEditLeaveConfirm),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(userProfileControllerProvider);

    return PopScope(
      // 没改过就正常返回：没有东西可丢的时候还弹确认，是纯粹的骚扰。
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // 先取出 navigator：await 之后再碰 context 会踩 use_build_context_synchronously。
        final navigator = Navigator.of(context);
        if (!await _confirmLeave(l10n)) return;
        if (!mounted) return;
        navigator.pop();
      },
      child: _buildScaffold(context, l10n, profile),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<UserProfile> profile,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.userProfileSettings)),
      body: HappyStarfieldBackground(
        parallax: false,
        intensity: _backgroundIntensity,
        child: SafeArea(
          child: switch (profile) {
            AsyncData(:final value) => _buildForm(context, l10n, value),
            AsyncError(:final error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  HappySemanticSpacing.screenPadding,
                ),
                child: HappyRetryCard(
                  message: _messageOf(error, l10n),
                  retryLabel: l10n.commonRetry,
                  onRetry: () => ref
                      .read(userProfileControllerProvider.notifier)
                      .reload(showSkeleton: true),
                ),
              ),
            ),
            // 骨架喂一份"长度像真数据"的档案，骨架条才不会比真表单明显短一截。
            _ => Skeletonizer(
              child: _buildForm(
                context,
                l10n,
                _skeletonProfile,
                isSkeleton: true,
              ),
            ),
          },
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n,
    UserProfile profile, {
    bool isSkeleton = false,
  }) {
    if (!isSkeleton) _hydrate(profile);
    final draft = isSkeleton ? profile : (_draft ?? profile);
    final theme = Theme.of(context);
    final enabled = !isSkeleton && !_isSaving;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: HappySemanticSpacing.itemGap,
                children: <Widget>[
                  Text(
                    l10n.userProfileEditIntro,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  _field(
                    UserProfileFieldKey.gender,
                    label: l10n.userFieldNickname,
                    child: TextFormField(
                      initialValue: draft.nickname,
                      enabled: enabled,
                      maxLength: _nicknameMaxLength,
                      decoration: const InputDecoration(counterText: ""),
                      validator: FormBuilderValidators.required(
                        errorText: l10n.userProfileEditNicknameRequired,
                      ),
                      onChanged: (v) => _edit((d) => d.copyWith(nickname: v)),
                    ),
                    // 昵称不是可跳转的档案字段，不参与锚点。
                    isAnchor: false,
                  ),
                  _field(
                    UserProfileFieldKey.gender,
                    label: l10n.userFieldGender,
                    child: _GenderPicker(
                      value: draft.gender,
                      enabled: enabled,
                      labels: <String, String>{
                        _genderMale: l10n.userGenderMale,
                        _genderFemale: l10n.userGenderFemale,
                        _genderOther: l10n.userGenderOther,
                      },
                      onChanged: (v) => _edit((d) => d.copyWith(gender: v)),
                    ),
                  ),
                  _field(
                    UserProfileFieldKey.birthday,
                    label: l10n.userFieldBirthday,
                    child: _BirthdayRow(
                      birthday: draft.birthday,
                      enabled: enabled,
                      emptyLabel: l10n.userProfileEditBirthdayUnset,
                      derivedLabel: (age, zodiac) =>
                          l10n.userProfileEditBirthdayDerived(age, zodiac),
                      onTap: _pickBirthday,
                    ),
                  ),
                  _textField(
                    UserProfileFieldKey.city,
                    label: l10n.userFieldCity,
                    value: draft.city,
                    enabled: enabled,
                    onChanged: (v) => _edit((d) => d.copyWith(city: v)),
                  ),
                  _textField(
                    UserProfileFieldKey.occupation,
                    label: l10n.userFieldOccupation,
                    value: draft.occupation,
                    enabled: enabled,
                    onChanged: (v) => _edit((d) => d.copyWith(occupation: v)),
                  ),
                  _textField(
                    UserProfileFieldKey.industry,
                    label: l10n.userFieldIndustry,
                    value: draft.industry,
                    enabled: enabled,
                    onChanged: (v) => _edit((d) => d.copyWith(industry: v)),
                  ),
                  _textField(
                    UserProfileFieldKey.company,
                    label: l10n.userFieldCompany,
                    value: draft.company,
                    enabled: enabled,
                    onChanged: (v) => _edit((d) => d.copyWith(company: v)),
                  ),
                  _field(
                    UserProfileFieldKey.hobbies,
                    label: l10n.userFieldHobbies,
                    child: UserTagEditor(
                      tags: draft.hobbies,
                      enabled: enabled,
                      hint: l10n.userProfileEditTagHint,
                      removeLabel: l10n.userProfileEditTagRemove,
                      onChanged: (tags) =>
                          _edit((d) => d.copyWith(hobbies: tags)),
                    ),
                  ),
                  _field(
                    UserProfileFieldKey.hobbies,
                    label: l10n.userFieldMbti,
                    isAnchor: false,
                    child: _MbtiPicker(
                      value: draft.mbti,
                      enabled: enabled,
                      unsetLabel: l10n.userProfileEditMbtiUnset,
                      onChanged: (v) => _edit((d) => d.copyWith(mbti: v)),
                    ),
                  ),
                  _field(
                    UserProfileFieldKey.hobbies,
                    label: l10n.userFieldPersonalityTags,
                    isAnchor: false,
                    child: UserTagEditor(
                      tags: draft.personalityTags,
                      enabled: enabled,
                      hint: l10n.userProfileEditTagHint,
                      removeLabel: l10n.userProfileEditTagRemove,
                      onChanged: (tags) =>
                          _edit((d) => d.copyWith(personalityTags: tags)),
                    ),
                  ),
                  _field(
                    UserProfileFieldKey.hobbies,
                    label: l10n.userFieldIdealLife,
                    isAnchor: false,
                    child: TextFormField(
                      initialValue: draft.idealLife,
                      enabled: enabled,
                      minLines: _idealLifeMinLines,
                      maxLines: _idealLifeMaxLines,
                      maxLength: _idealLifeMaxLength,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: l10n.userProfileEditIdealLifeHint,
                        counterText: "",
                      ),
                      onChanged: (v) => _edit((d) => d.copyWith(idealLife: v)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 保存键常驻底部：表单很长，把主行动放在最下面等于让用户先滚到底才能提交。
          Padding(
            padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
            child: HappyButton(
              label: l10n.userProfileEditSave,
              icon: LucideIcons.check,
              size: HappyButtonSize.large,
              isLoading: _isSaving,
              onPressed: enabled ? _save : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 一个字段行：标签 + 控件。[isAnchor] 为 true 且它正是跳转目标时挂上锚点 key。
  Widget _field(
    UserProfileFieldKey key, {
    required String label,
    required Widget child,
    bool isAnchor = true,
  }) {
    final isTarget = isAnchor && widget.targetField == key;
    return Column(
      key: isTarget ? _targetKey : null,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                // 跳转过来的那一项用品牌色点名，滚到位之后一眼能认出"就是它"。
                color: isTarget
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
        child,
      ],
    );
  }

  Widget _textField(
    UserProfileFieldKey key, {
    required String label,
    required String? value,
    required bool enabled,
    required ValueChanged<String> onChanged,
  }) => _field(
    key,
    label: label,
    child: TextFormField(
      initialValue: value,
      enabled: enabled,
      maxLength: _shortTextMaxLength,
      decoration: const InputDecoration(counterText: ""),
      onChanged: onChanged,
    ),
  );

  /// 骨架态占位档案：长度贴近真实值。
  static final UserProfile _skeletonProfile = UserProfile(
    nickname: "昵称占位",
    gender: "——",
    birthday: DateTime(1996),
    city: "——",
    occupation: "——",
    industry: "——",
    company: "——",
    hobbies: const <String>["占位", "占位标签"],
    mbti: "----",
    personalityTags: const <String>["占位", "占位"],
    idealLife: "占位的一段理想生活描述，长度大致如此。",
  );
}

/// 性别选择。三选一用 chip 而不是下拉：选项少的时候，
/// 一眼能看全比"点开再选"少一步。
class _GenderPicker extends StatelessWidget {
  const _GenderPicker({
    required this.value,
    required this.enabled,
    required this.labels,
    required this.onChanged,
  });

  final String? value;
  final bool enabled;

  /// 后端值 → 展示文案。**发回后端的是 key**（契约里就是中文的"男"/"女"），
  /// 展示用的是 value，两者分开才能在英文界面显示 Male 而不改数据。
  final Map<String, String> labels;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = value;
    // 后端存了个我们不认识的值（老数据 / 别的端写的）：原样加一项并选中，
    // 而不是显示成"没选"——那会让用户以为数据丢了，一保存就真丢了。
    final options = <String, String>{
      ...labels,
      if (current != null && current.isNotEmpty && !labels.containsKey(current))
        current: current,
    };

    return Wrap(
      spacing: HappySpacing.s8,
      runSpacing: HappySpacing.s8,
      children: <Widget>[
        for (final entry in options.entries)
          ChoiceChip(
            label: Text(entry.value),
            selected: entry.key == current,
            onSelected: enabled ? (_) => onChanged(entry.key) : null,
          ),
      ],
    );
  }
}

/// 生日行：点开系统日期选择器，下面就地显示由它推出来的年龄与星座。
///
/// 把推导结果显示出来是**给用户一个校验的机会**：日期选择器很容易点错年份，
/// 而"28 岁 · 天秤座"是否对得上，用户一眼就知道。
class _BirthdayRow extends StatelessWidget {
  const _BirthdayRow({
    required this.birthday,
    required this.enabled,
    required this.emptyLabel,
    required this.derivedLabel,
    required this.onTap,
  });

  final DateTime? birthday;
  final bool enabled;
  final String emptyLabel;
  final String Function(int age, String zodiac) derivedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = birthday;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final age = date == null ? null : ageFromBirthday(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySpacing.s4,
      children: <Widget>[
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(HappyRadius.input),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: HappyControlSize.input,
            ),
            padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(HappyRadius.input),
              border: Border.all(
                color: scheme.outlineVariant,
                width: HappyBorderWidth.hairline,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    date == null
                        ? emptyLabel
                        : DateFormat.yMMMd(locale).format(date),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: date == null
                          ? scheme.onSurfaceVariant
                          : scheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.calendar,
                  size: HappyIconSize.md,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (date != null && age != null)
          Text(
            derivedLabel(age, zodiacFromBirthday(date)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// MBTI 选择。16 型用下拉而不是铺 16 个 chip——铺开会占掉大半屏，
/// 而这是个"知道自己是什么就直接选"的字段，不需要浏览。
class _MbtiPicker extends StatelessWidget {
  const _MbtiPicker({
    required this.value,
    required this.enabled,
    required this.unsetLabel,
    required this.onChanged,
  });

  final String? value;
  final bool enabled;
  final String unsetLabel;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // 后端存了不在 16 型里的值时把它也列进去，避免下拉显示成空、一保存就被抹掉。
    final current = value;
    final items = <String>[
      ..._mbtiTypes,
      if (current != null &&
          current.isNotEmpty &&
          !_mbtiTypes.contains(current))
        current,
    ];

    return DropdownButtonFormField<String>(
      initialValue: (current?.isEmpty ?? true) ? null : current,
      isExpanded: true,
      hint: Text(unsetLabel),
      items: <DropdownMenuItem<String>>[
        for (final type in items)
          DropdownMenuItem<String>(value: type, child: Text(type)),
      ],
      onChanged: enabled
          ? (v) {
              if (v != null) onChanged(v);
            }
          : null,
    );
  }
}

/// 后端约定的性别取值（契约样例里就是中文）。展示文案走 l10n，这里只是数据。
const String _genderMale = "男";
const String _genderFemale = "女";
const String _genderOther = "其他";

/// MBTI 十六型。固定集合，不需要国际化——它本来就是四个英文字母的代号。
const List<String> _mbtiTypes = <String>[
  "INTJ", "INTP", "ENTJ", "ENTP", //
  "INFJ", "INFP", "ENFJ", "ENFP",
  "ISTJ", "ISFJ", "ESTJ", "ESFJ",
  "ISTP", "ISFP", "ESTP", "ESFP",
];

/// 目标字段滚到屏幕靠上 1/4 处：下面还有输入框，贴底会被键盘盖住。
const double _targetAlignment = 0.25;

/// 没填生日时日期选择器的落点年份（往前推的岁数）。
const int _defaultAgeGuess = 25;

/// 可选生日的最早年份（往前推的岁数）。
const int _maxAge = 100;

const int _nicknameMaxLength = 20;
const int _shortTextMaxLength = 30;
const int _idealLifeMinLines = 3;
const int _idealLifeMaxLines = 6;
const int _idealLifeMaxLength = 300;

/// 表单页的星野强度：比首页更淡，长表单要的是安静。
const double _backgroundIntensity = 0.4;
