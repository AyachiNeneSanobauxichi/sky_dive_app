// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_jumper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前登录用户**作为跳伞者**在名单上的样子。未登录则为 null。
///
/// 客人自助预约走的就是"把自己加进航线名单的顾客位"这条路（见
/// `agent/service/booking/booking.api.md`），所以需要把登录用户折成一条
/// [LoadParticipant]。
///
/// [LoadParticipant.detail] 刻意留空：那一栏在运营侧写的是"体験ジャンプ · 初回"
/// 这类由后端下发的说明，客户端不该把一句本地化文案塞进数据——存进名单后，
/// 换个语言的人看到的就是别人语言的字。

@ProviderFor(currentJumper)
final currentJumperProvider = CurrentJumperProvider._();

/// 当前登录用户**作为跳伞者**在名单上的样子。未登录则为 null。
///
/// 客人自助预约走的就是"把自己加进航线名单的顾客位"这条路（见
/// `agent/service/booking/booking.api.md`），所以需要把登录用户折成一条
/// [LoadParticipant]。
///
/// [LoadParticipant.detail] 刻意留空：那一栏在运营侧写的是"体験ジャンプ · 初回"
/// 这类由后端下发的说明，客户端不该把一句本地化文案塞进数据——存进名单后，
/// 换个语言的人看到的就是别人语言的字。

final class CurrentJumperProvider
    extends
        $FunctionalProvider<
          LoadParticipant?,
          LoadParticipant?,
          LoadParticipant?
        >
    with $Provider<LoadParticipant?> {
  /// 当前登录用户**作为跳伞者**在名单上的样子。未登录则为 null。
  ///
  /// 客人自助预约走的就是"把自己加进航线名单的顾客位"这条路（见
  /// `agent/service/booking/booking.api.md`），所以需要把登录用户折成一条
  /// [LoadParticipant]。
  ///
  /// [LoadParticipant.detail] 刻意留空：那一栏在运营侧写的是"体験ジャンプ · 初回"
  /// 这类由后端下发的说明，客户端不该把一句本地化文案塞进数据——存进名单后，
  /// 换个语言的人看到的就是别人语言的字。
  CurrentJumperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentJumperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentJumperHash();

  @$internal
  @override
  $ProviderElement<LoadParticipant?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoadParticipant? create(Ref ref) {
    return currentJumper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadParticipant? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadParticipant?>(value),
    );
  }
}

String _$currentJumperHash() => r'16211355cd7a278b969c5aefada34cf51b4e37c5';
