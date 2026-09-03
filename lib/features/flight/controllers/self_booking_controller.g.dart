// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 客人给**自己**预约 / 取消一条航线。
///
/// 放在 flight 而不是 booking，是为了守住模块依赖的单向：booking 消费 flight
/// 的航线（见 `references/01-project-structure.md` 的模块地图），反过来 flight
/// 不该知道 booking 的存在。而"预约"在 v1 就等于**在航线名单上占一个顾客位**，
/// 本来就是一次航线名单的写操作（见 `agent/service/booking/booking.api.md`）。
///
/// 状态是"有没有请求在途"：客人一屏能看见好几条航线的预约按钮，
/// 一个全局忙碌位顺手挡掉"连点两条"这种双重下单。

@ProviderFor(SelfBookingController)
final selfBookingControllerProvider = SelfBookingControllerProvider._();

/// 客人给**自己**预约 / 取消一条航线。
///
/// 放在 flight 而不是 booking，是为了守住模块依赖的单向：booking 消费 flight
/// 的航线（见 `references/01-project-structure.md` 的模块地图），反过来 flight
/// 不该知道 booking 的存在。而"预约"在 v1 就等于**在航线名单上占一个顾客位**，
/// 本来就是一次航线名单的写操作（见 `agent/service/booking/booking.api.md`）。
///
/// 状态是"有没有请求在途"：客人一屏能看见好几条航线的预约按钮，
/// 一个全局忙碌位顺手挡掉"连点两条"这种双重下单。
final class SelfBookingControllerProvider
    extends $NotifierProvider<SelfBookingController, bool> {
  /// 客人给**自己**预约 / 取消一条航线。
  ///
  /// 放在 flight 而不是 booking，是为了守住模块依赖的单向：booking 消费 flight
  /// 的航线（见 `references/01-project-structure.md` 的模块地图），反过来 flight
  /// 不该知道 booking 的存在。而"预约"在 v1 就等于**在航线名单上占一个顾客位**，
  /// 本来就是一次航线名单的写操作（见 `agent/service/booking/booking.api.md`）。
  ///
  /// 状态是"有没有请求在途"：客人一屏能看见好几条航线的预约按钮，
  /// 一个全局忙碌位顺手挡掉"连点两条"这种双重下单。
  SelfBookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selfBookingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selfBookingControllerHash();

  @$internal
  @override
  SelfBookingController create() => SelfBookingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$selfBookingControllerHash() =>
    r'f28c36557e3b7fb036d7441ee8bb6a39ce2be294';

/// 客人给**自己**预约 / 取消一条航线。
///
/// 放在 flight 而不是 booking，是为了守住模块依赖的单向：booking 消费 flight
/// 的航线（见 `references/01-project-structure.md` 的模块地图），反过来 flight
/// 不该知道 booking 的存在。而"预约"在 v1 就等于**在航线名单上占一个顾客位**，
/// 本来就是一次航线名单的写操作（见 `agent/service/booking/booking.api.md`）。
///
/// 状态是"有没有请求在途"：客人一屏能看见好几条航线的预约按钮，
/// 一个全局忙碌位顺手挡掉"连点两条"这种双重下单。

abstract class _$SelfBookingController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
