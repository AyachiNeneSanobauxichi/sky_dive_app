// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_bookings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 我的预约：名单上有我的航线，按起飞时刻由早到晚。
///
/// 直接从**已经加载的航线列表**里筛，而不是另发一个请求（见
/// `agent/service/booking/booking.api.md` v1 的取舍）：预约就是航线名单上的
/// 一个顾客位，两边同一份真源，取消的那一刻航线剩余名额也跟着变，
/// 不会出现"我的预约里还在、航线上已经没了"这种对不上的状态。
///
/// 已起飞的行程**保留**在列表里：客人要回看自己跳过哪几班。

@ProviderFor(myBookings)
final myBookingsProvider = MyBookingsProvider._();

/// 我的预约：名单上有我的航线，按起飞时刻由早到晚。
///
/// 直接从**已经加载的航线列表**里筛，而不是另发一个请求（见
/// `agent/service/booking/booking.api.md` v1 的取舍）：预约就是航线名单上的
/// 一个顾客位，两边同一份真源，取消的那一刻航线剩余名额也跟着变，
/// 不会出现"我的预约里还在、航线上已经没了"这种对不上的状态。
///
/// 已起飞的行程**保留**在列表里：客人要回看自己跳过哪几班。

final class MyBookingsProvider
    extends $FunctionalProvider<List<Load>, List<Load>, List<Load>>
    with $Provider<List<Load>> {
  /// 我的预约：名单上有我的航线，按起飞时刻由早到晚。
  ///
  /// 直接从**已经加载的航线列表**里筛，而不是另发一个请求（见
  /// `agent/service/booking/booking.api.md` v1 的取舍）：预约就是航线名单上的
  /// 一个顾客位，两边同一份真源，取消的那一刻航线剩余名额也跟着变，
  /// 不会出现"我的预约里还在、航线上已经没了"这种对不上的状态。
  ///
  /// 已起飞的行程**保留**在列表里：客人要回看自己跳过哪几班。
  MyBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myBookingsHash();

  @$internal
  @override
  $ProviderElement<List<Load>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Load> create(Ref ref) {
    return myBookings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Load> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Load>>(value),
    );
  }
}

String _$myBookingsHash() => r'985f0853044c21795062212ad4d3ec1153a096bd';
