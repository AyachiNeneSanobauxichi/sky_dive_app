// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_admin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 当前登录用户能否**排班**（新建 / 编辑 / 删除航线、给航线排人）。
///
/// 角色由后端在登录响应里下发（`userInfo.role` → [UserRole]），客户端只据此
/// 显隐入口。权限的真正边界在服务端：客户端藏起来的按钮挡不住任何人，
/// 这里做的只是"别让客人看见和自己无关的东西"。
///
/// 未登录 / 登录态未定时一律 false——最小权限，宁可少给。

@ProviderFor(isLoadAdmin)
final isLoadAdminProvider = IsLoadAdminProvider._();

/// 当前登录用户能否**排班**（新建 / 编辑 / 删除航线、给航线排人）。
///
/// 角色由后端在登录响应里下发（`userInfo.role` → [UserRole]），客户端只据此
/// 显隐入口。权限的真正边界在服务端：客户端藏起来的按钮挡不住任何人，
/// 这里做的只是"别让客人看见和自己无关的东西"。
///
/// 未登录 / 登录态未定时一律 false——最小权限，宁可少给。

final class IsLoadAdminProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 当前登录用户能否**排班**（新建 / 编辑 / 删除航线、给航线排人）。
  ///
  /// 角色由后端在登录响应里下发（`userInfo.role` → [UserRole]），客户端只据此
  /// 显隐入口。权限的真正边界在服务端：客户端藏起来的按钮挡不住任何人，
  /// 这里做的只是"别让客人看见和自己无关的东西"。
  ///
  /// 未登录 / 登录态未定时一律 false——最小权限，宁可少给。
  IsLoadAdminProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLoadAdminProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLoadAdminHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isLoadAdmin(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLoadAdminHash() => r'85264af98f22b823a52ff74f489a080e9b827fe7';
