// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignable_participants.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 某条航线上、某个角色**还能被排进来**的人。
///
/// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
/// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
///
/// autoDispose（默认）：只在选择器打开期间有意义。

@ProviderFor(assignableParticipants)
final assignableParticipantsProvider = AssignableParticipantsFamily._();

/// 某条航线上、某个角色**还能被排进来**的人。
///
/// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
/// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
///
/// autoDispose（默认）：只在选择器打开期间有意义。

final class AssignableParticipantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoadParticipant>>,
          List<LoadParticipant>,
          FutureOr<List<LoadParticipant>>
        >
    with
        $FutureModifier<List<LoadParticipant>>,
        $FutureProvider<List<LoadParticipant>> {
  /// 某条航线上、某个角色**还能被排进来**的人。
  ///
  /// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
  /// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
  ///
  /// autoDispose（默认）：只在选择器打开期间有意义。
  AssignableParticipantsProvider._({
    required AssignableParticipantsFamily super.from,
    required (String, ParticipantRole) super.argument,
  }) : super(
         retry: null,
         name: r'assignableParticipantsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assignableParticipantsHash();

  @override
  String toString() {
    return r'assignableParticipantsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LoadParticipant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LoadParticipant>> create(Ref ref) {
    final argument = this.argument as (String, ParticipantRole);
    return assignableParticipants(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is AssignableParticipantsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assignableParticipantsHash() =>
    r'6af8adb6ff8f75ba70a18fb503082ba6ed15b4fc';

/// 某条航线上、某个角色**还能被排进来**的人。
///
/// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
/// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
///
/// autoDispose（默认）：只在选择器打开期间有意义。

final class AssignableParticipantsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LoadParticipant>>,
          (String, ParticipantRole)
        > {
  AssignableParticipantsFamily._()
    : super(
        retry: null,
        name: r'assignableParticipantsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某条航线上、某个角色**还能被排进来**的人。
  ///
  /// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
  /// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
  ///
  /// autoDispose（默认）：只在选择器打开期间有意义。

  AssignableParticipantsProvider call(String loadId, ParticipantRole role) =>
      AssignableParticipantsProvider._(argument: (loadId, role), from: this);

  @override
  String toString() => r'assignableParticipantsProvider';
}
