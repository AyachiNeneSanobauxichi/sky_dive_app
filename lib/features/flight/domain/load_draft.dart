import "dart:math" as math;

import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/flight/domain/drop_zone.dart";
import "package:sky_dive/features/flight/domain/load.dart";
import "package:sky_dive/features/flight/domain/load_rules.dart";
import "package:sky_dive/features/flight/domain/participant_role.dart";

part "load_draft.freezed.dart";

/// 新建 / 编辑航线的草稿。
///
/// 表单状态用不可变模型承载而不是一堆散落的 `TextEditingController` + `setState`：
/// 编辑态要"打开时预填、改到一半返回不丢、提交时整体校验"，散状态做这三件事
/// 会漏掉其中一两件。
///
/// [id] 为空表示新建，有值表示编辑既有航线——两条路走同一张表单，
/// 差别只在标题、提交按钮文案和调哪个接口。
@freezed
abstract class LoadDraft with _$LoadDraft {
  const factory LoadDraft({
    String? id,
    @Default("") String code,
    DropZone? dropZone,
    DateTime? departureAt,
    @Default("") String aircraft,
    @Default(LoadRules.defaultAltitudeFt) int altitudeFt,
    @Default(LoadRules.defaultCustomerCapacity) int customerCapacity,
    @Default(LoadRules.defaultPhotographerCapacity) int photographerCapacity,

    /// 编辑态下各角色**已分配**的人数。不是表单字段，只用来卡上限下界：
    /// 已经排了 6 个客人的航线，上限不能被改成 4——那 2 个人无处安放。
    @Default(0) int assignedCustomers,
    @Default(0) int assignedPhotographers,
  }) = _LoadDraft;

  const LoadDraft._();

  /// 从既有航线开一份编辑草稿。
  factory LoadDraft.fromLoad(Load load) => LoadDraft(
    id: load.id,
    code: load.code,
    dropZone: load.dropZone,
    departureAt: load.departureAt,
    aircraft: load.aircraft,
    altitudeFt: load.altitudeFt,
    customerCapacity: load.customerCapacity,
    photographerCapacity: load.photographerCapacity,
    assignedCustomers: load.assignedCountOf(ParticipantRole.customer),
    assignedPhotographers: load.assignedCountOf(ParticipantRole.photographer),
  );

  /// 新建草稿：起飞时刻给一个明天上午的合理默认值（见 [LoadRules]）。
  factory LoadDraft.create({required DateTime now}) {
    final base = now.add(LoadRules.defaultDepartureOffset);
    return LoadDraft(
      departureAt: DateTime(
        base.year,
        base.month,
        base.day,
        LoadRules.defaultDepartureHour,
      ),
    );
  }

  bool get isEditing => id != null;

  /// 某个角色的名额下界：不能低于已分配人数。
  int minCapacityOf(ParticipantRole role) => switch (role) {
    ParticipantRole.customer => math.max(
      LoadRules.minCustomerCapacity,
      assignedCustomers,
    ),
    ParticipantRole.photographer => math.max(
      LoadRules.minPhotographerCapacity,
      assignedPhotographers,
    ),
  };

  /// 某个角色的名额上界。
  int maxCapacityOf(ParticipantRole role) => switch (role) {
    ParticipantRole.customer => LoadRules.maxCustomerCapacity,
    ParticipantRole.photographer => LoadRules.maxPhotographerCapacity,
  };

  /// 某个角色当前填的名额。
  int capacityOf(ParticipantRole role) => switch (role) {
    ParticipantRole.customer => customerCapacity,
    ParticipantRole.photographer => photographerCapacity,
  };

  /// 改某个角色的名额（自动夹在上下界内，UI 不必自己判断边界）。
  LoadDraft withCapacity(ParticipantRole role, int value) {
    final clamped = value.clamp(minCapacityOf(role), maxCapacityOf(role));
    return switch (role) {
      ParticipantRole.customer => copyWith(customerCapacity: clamped),
      ParticipantRole.photographer => copyWith(photographerCapacity: clamped),
    };
  }

  /// 必填项是否齐全（代号 / 地点 / 时刻 / 机型）。提交按钮据此禁用。
  bool get isComplete =>
      code.trim().isNotEmpty &&
      dropZone != null &&
      departureAt != null &&
      aircraft.trim().isNotEmpty;
}
