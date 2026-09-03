import "package:sky_dive/features/auth/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "load_admin.g.dart";

/// 当前登录用户能否**排班**（新建 / 编辑 / 删除航线、给航线排人）。
///
/// 角色由后端在登录响应里下发（`userInfo.role` → [UserRole]），客户端只据此
/// 显隐入口。权限的真正边界在服务端：客户端藏起来的按钮挡不住任何人，
/// 这里做的只是"别让客人看见和自己无关的东西"。
///
/// 未登录 / 登录态未定时一律 false——最小权限，宁可少给。
@riverpod
bool isLoadAdmin(Ref ref) {
  final user = ref.watch(authControllerProvider).asData?.value.userOrNull;
  return user?.canManageLoads ?? false;
}
