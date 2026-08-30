import "package:flutter/animation.dart";

/// 动效令牌：时长与缓动曲线。
///
/// 动效是"廉价"和"精致"之间最大的分水岭，但前提是**全局一致**——同一类交互
/// 在任何页面都该用同一个时长和曲线。因此禁止在 Widget 里写
/// `Duration(milliseconds: 300)` 或 `Curves.easeInOut` 字面量，一律取本类令牌。
abstract final class SkyMotion {
  // ───────────────────────── 时长 ─────────────────────────

  /// 90ms：按下反馈、勾选态翻转等"必须让人觉得是瞬时"的微交互。
  static const Duration instant = Duration(milliseconds: 90);

  /// 160ms：hover / focus 描边、图标切换。
  static const Duration fast = Duration(milliseconds: 160);

  /// 240ms：组件级默认时长（展开、淡入、尺寸变化）。
  static const Duration normal = Duration(milliseconds: 240);

  /// 400ms：页面转场、底部弹层进出。
  static const Duration slow = Duration(milliseconds: 400);

  /// 700ms：首屏主视觉、大块内容入场这类需要"被看见"的叙事性动效。
  static const Duration hero = Duration(milliseconds: 700);

  /// 6s：云层漂移、呼吸光晕等无限循环的环境动效。放慢才不会分散注意力。
  static const Duration ambient = Duration(milliseconds: 6000);

  /// 列表逐项入场的相邻延迟。
  static const Duration stagger = Duration(milliseconds: 60);

  // ───────────────────────── 曲线 ─────────────────────────

  /// 默认曲线：快出慢收，绝大多数场景用它。
  static const Curve standard = Curves.easeOutCubic;

  /// 强调曲线（对齐 M3 emphasized）：起步更猛、尾巴更长，用于页面级转场。
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);

  /// 入场：末端几乎静止，元素"落位"感强。
  static const Curve entrance = Curves.easeOutQuart;

  /// 退场：加速离开，不拖泥带水。
  static const Curve exit = Curves.easeInCubic;

  /// 带回弹，仅用于成功/点赞这类正反馈，别滥用。
  static const Curve springy = Curves.easeOutBack;

  /// 环境动效的往返曲线，两端平滑避免循环接缝可见。
  static const Curve ambientCurve = Curves.easeInOut;

  // ───────────────────────── 位移量 ─────────────────────────

  /// 入场上滑的起始偏移（单位为自身高度的倍数，配合 `flutter_animate` 的 slideY）。
  static const double slideOffset = 0.12;

  /// 按下时缩放到的比例。0.97 是"看得出被按下"又不显得廉价的临界点。
  static const double pressScale = 0.97;
}
