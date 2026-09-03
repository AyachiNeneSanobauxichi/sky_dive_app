import "package:sky_dive/features/flight/controllers/flight_providers.dart";
import "package:sky_dive/features/flight/controllers/load_list_controller.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "assignable_participants.g.dart";

/// 某条航线上、某个角色**还能被排进来**的人。
///
/// = 候选池里该角色的人 − 已经在这条航线名单上的人。把"已经在船上的人"从选择器
/// 里剔掉，比让用户选完再报"这个人已在名单上"友好得多——后者是让用户先犯错再纠正。
///
/// autoDispose（默认）：只在选择器打开期间有意义。
@riverpod
Future<List<LoadParticipant>> assignableParticipants(
  Ref ref,
  String loadId,
  ParticipantRole role,
) async {
  final roster = await ref.watch(loadRosterProvider.future);
  final load = ref.watch(loadListControllerProvider.notifier).loadById(loadId);
  final assignedIds = <String>{
    if (load != null)
      for (final participant in load.participants) participant.id,
  };

  return roster
      .where((p) => p.role == role && !assignedIds.contains(p.id))
      .toList(growable: false);
}
