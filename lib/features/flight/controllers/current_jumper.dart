import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "current_jumper.g.dart";

/// 当前登录用户**作为跳伞者**在名单上的样子。未登录则为 null。
///
/// 客人自助预约走的就是"把自己加进航线名单的顾客位"这条路（见
/// `agent/service/booking/booking.api.md`），所以需要把登录用户折成一条
/// [LoadParticipant]。
///
/// [LoadParticipant.detail] 刻意留空：那一栏在运营侧写的是"体験ジャンプ · 初回"
/// 这类由后端下发的说明，客户端不该把一句本地化文案塞进数据——存进名单后，
/// 换个语言的人看到的就是别人语言的字。
@riverpod
LoadParticipant? currentJumper(Ref ref) {
  final user = ref.watch(authControllerProvider).asData?.value.userOrNull;
  if (user == null) return null;
  return LoadParticipant(
    id: user.id,
    name: user.displayName,
    role: ParticipantRole.customer,
  );
}
