import "package:happy_os/features/user/domain/index.dart";

/// 用户档案的假数据源（无真实接口期间的临时占位）。
///
/// ⚠️ **接完真实接口立即删除整个 `data/mock/` 目录**，并按
/// `agent/service/user/user.api.md` 定稿的契约补 DTO / DataSource / Repository。
// TODO(user): 等 user.api.md 定稿后删除本文件，切回真实 DataSource。
abstract final class UserProfileMockApi {
  /// 假网络延迟。留足时间是为了让骨架屏真的被看见——否则加载态形同虚设，
  /// 上线后真实网络一慢就暴露没做过的状态。
  static const Duration _latency = Duration(milliseconds: 900);

  /// 置 true 后下一次请求抛错，用来人工验证「错误态 + 重试」这条链路。
  /// mock 专用开关，随 mock 目录一起删。
  static bool simulateFailure = false;

  static Future<UserProfile> fetch() async {
    await Future<void>.delayed(_latency);
    if (simulateFailure) {
      throw Exception("mock: failed to load user profile");
    }
    return _profile;
  }

  /// 一份"填了大半"的档案：故意留空 [UserProfile.company] 与
  /// [UserProfile.industry]，这样"未填写"的样式和"完善档案"的引导都能被看到。
  static final UserProfile _profile = UserProfile(
    nickname: "夜航的鲸",
    awakeningLevel: 7,
    awakeningProgress: 0.64,
    starAffinity: 0.87,
    gender: "女",
    age: 29,
    birthday: DateTime(1996, 8, 12),
    zodiac: "狮子座",
    city: "上海",
    occupation: "产品经理",
    hobbies: const <String>["夜跑", "看展", "写日记", "爵士"],
  );
}
