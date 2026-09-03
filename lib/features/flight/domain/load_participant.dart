import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/participant_role.dart";

part "load_participant.freezed.dart";

/// 航线名单上的一个人（顾客或摄影师）。
///
/// 同一个模型既表示"已在名单上的人"，也表示"可被分配的候选人"——两者字段完全
/// 相同，[id] 都是这个人的主键。分开建两个模型只会让 UI 在两套等价结构之间
/// 来回映射，没有换来任何约束。
@freezed
abstract class LoadParticipant with _$LoadParticipant {
  const factory LoadParticipant({
    required String id,
    required String name,
    required ParticipantRole role,

    /// 一句话补充：顾客写跳伞类型 / 执照等级，摄影师写机位（如「手持 + 头盔」）。
    /// 排班的人靠它一眼判断"这个人能不能上这条航线"。
    String? detail,
  }) = _LoadParticipant;

  const LoadParticipant._();

  /// 头像占位用的首字（无头像时显示）。
  ///
  /// 取的是首个 **rune** 而不是 `substring(0, 1)`：日文名与 emoji 都可能是
  /// 代理对，按 code unit 截会截出半个字符，渲染成豆腐块。
  String get initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "?";
    return String.fromCharCode(trimmed.runes.first);
  }

  /// 搜索用的可匹配文本。
  String get searchText => "$name ${detail ?? ""}";
}
