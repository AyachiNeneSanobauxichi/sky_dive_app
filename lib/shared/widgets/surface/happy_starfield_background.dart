import "dart:math" as math;

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";

/// 星空背景：HappyOS 的招牌视觉。
///
/// 三层叠出来的"夜空"：
/// 1. **天幕**——竖向渐变（`HappyGradients.skyFor`），天顶暗、地平亮，让整屏一眼读成天空；
/// 2. **星野**——一道斜向银河带 + 三层视差星点，缓慢呼吸闪烁；
/// 3. **星云**——左上紫罗兰、右下品红两团柔光，是品牌色在背景上的落点。
///
/// 浅色模式下自动换成白昼版：晨蓝天幕 + 云絮，星点隐去（星空只在夜色下成立）。
///
/// ## 性能
/// 星野是**一个** [CustomPainter]，靠 `repaint` 直接监听动画与滚动量，
/// **不触发任何 widget 重建**，每帧成本约等于一次渐变填充加百来次 `drawCircle`。
/// 星点位置在 `initState` 用固定种子生成一次（存的是 0–1 归一化坐标），
/// 所以旋屏、键盘弹出都不会让星星跳位。
/// 系统开启"减弱动态效果"时，闪烁与视差一起关掉，只留静止星野。
///
/// 用在需要氛围的页面（开屏、登录、首页外壳、故事阅读、空态）。
class HappyStarfieldBackground extends StatefulWidget {
  const HappyStarfieldBackground({
    super.key,
    required this.child,
    this.animate = true,
    this.intensity = 1,
    this.parallax = true,
  });

  final Widget child;

  /// 是否让星点呼吸、星云漂移。系统开启"减弱动态效果"时会被强制关掉。
  final bool animate;

  /// 氛围光强系数（0–1）。信息密集的页面调到 0.5 以下更稳妥。
  ///
  /// 主要压的是**星云与银河**这类大面积柔光；星点只按 [_starIntensityFloor] 打折。
  /// 因为星点是这个主题的"结构"而不是氛围光——压强度时星云该退到底噪，
  /// 星星不能跟着一起消失，否则信息密集页就没有星空了。
  final double intensity;

  /// 是否随内容滚动做星野视差。列表页开着能强化"星空在内容之后"的纵深；
  /// 长文阅读页可以关掉，避免眼睛被背景牵着走。
  final bool parallax;

  @override
  State<HappyStarfieldBackground> createState() =>
      _HappyStarfieldBackgroundState();
}

class _HappyStarfieldBackgroundState extends State<HappyStarfieldBackground>
    with SingleTickerProviderStateMixin {
  /// 闪烁相位驱动。线性 0→1 循环，**不加曲线**：曲线会让循环接缝处的速度突变
  /// 变成肉眼可见的"一顿"。
  late final AnimationController _twinkle = AnimationController(
    duration: HappyMotion.ambient,
    vsync: this,
  );

  /// 当前竖向滚动量，星野据此做视差。
  /// 用 [ValueNotifier] 而不是 `setState`：滚动每帧都在变，走 setState 会把
  /// 整棵子树（含 child 里的整个页面）拖进重建。
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0);

  /// 星点。固定种子生成一次，见类注释。
  late final List<_Star> _stars = _generateStars();

  @override
  void initState() {
    super.initState();
    _twinkle.repeat();
  }

  @override
  void dispose() {
    _twinkle.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  /// 只吃**竖向**滚动：横向的标签筛选条也会冒 `ScrollNotification`，
  /// 拿它去驱动视差会让星空在拖 chip 时莫名其妙地动。
  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    _scrollOffset.value = notification.metrics.pixels;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // 尊重系统无障碍设置：开了"减弱动态效果"就静止，避免引发不适
    final shouldAnimate =
        widget.animate && !MediaQuery.disableAnimationsOf(context);
    // 浅色模式下同样强度会显得脏，压到四成
    final nebulaIntensity = widget.intensity * (isDark ? 0.38 : 0.16);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: HappyGradients.skyFor(theme.brightness),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 星野只在夜色下有意义；白昼版靠下面的云絮撑氛围。
          if (isDark)
            RepaintBoundary(
              child: CustomPaint(
                painter: _StarfieldPainter(
                  stars: _stars,
                  twinkle: _twinkle,
                  scrollOffset: _scrollOffset,
                  starIntensity:
                      _starIntensityFloor +
                      (1 - _starIntensityFloor) * widget.intensity,
                  bandIntensity: widget.intensity,
                  animate: shouldAnimate,
                  parallax: widget.parallax && shouldAnimate,
                ),
              ),
            ),
          ..._blobs(isDark, nebulaIntensity, shouldAnimate),
          if (widget.parallax)
            NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: widget.child,
            )
          else
            widget.child,
        ],
      ),
    );
  }

  /// 氛围光斑：深色是两团星云，浅色是两团淡品牌光 + 一团云絮。
  List<Widget> _blobs(bool isDark, double intensity, bool animate) {
    final size = MediaQuery.sizeOf(context);

    return <Widget>[
      Positioned(
        top: -size.height * _blobTopInset,
        left: -size.width * _blobLeftInset,
        child: _NebulaBlob(
          color: isDark ? HappyColors.violetBright : HappyColors.violet,
          diameter: size.width * _blobLargeRatio,
          intensity: intensity,
          animate: animate,
          driftY: _blobDrift,
        ),
      ),
      Positioned(
        bottom: -size.height * _blobBottomInset,
        right: -size.width * _blobRightInset,
        child: _NebulaBlob(
          color: isDark ? HappyColors.magentaBright : HappyColors.magenta,
          diameter: size.width * _blobSmallRatio,
          intensity: intensity * _blobSecondaryFalloff,
          animate: animate,
          // 反向漂移，两团光才不会像同一块东西在整体平移
          driftY: -_blobDrift,
        ),
      ),
      if (!isDark)
        Positioned(
          top: -size.height * _cloudTopInset,
          right: -size.width * _cloudRightInset,
          child: _NebulaBlob(
            color: HappyColors.dayCloud,
            diameter: size.width * _cloudRatio,
            intensity: _cloudIntensity,
            animate: animate,
            driftY: _cloudDrift,
          ),
        ),
    ];
  }

  /// 生成三层星点。固定种子 → 每次启动的星空长得一样（当成品牌资产而不是随机噪点）。
  List<_Star> _generateStars() {
    final random = math.Random(_starSeed);
    final stars = <_Star>[];

    for (final layer in _StarLayer.values) {
      for (var i = 0; i < layer.count; i++) {
        stars.add(
          _Star(
            // 归一化坐标：与画布尺寸解耦，旋屏不跳位。
            dx: random.nextDouble(),
            dy: random.nextDouble(),
            radius:
                layer.minRadius +
                random.nextDouble() * (layer.maxRadius - layer.minRadius),
            baseAlpha:
                layer.minAlpha +
                random.nextDouble() * (layer.maxAlpha - layer.minAlpha),
            phase: random.nextDouble(),
            // 闪烁速度取整数倍：非整数倍在 6s 循环回到 0 时会有一次相位跳变。
            twinkleCycles:
                _twinkleCycles[random.nextInt(_twinkleCycles.length)],
            color: _starPalette[random.nextInt(_starPalette.length)],
            parallax: layer.parallax,
            hasGlow: layer.hasGlow,
          ),
        );
      }
    }

    return stars;
  }
}

/// 星野的三层。远层多而暗、近层少而亮，靠数量与亮度的反差做出纵深，
/// 视差系数也按远近拉开（远处几乎不动，这是纵深感真正的来源）。
enum _StarLayer {
  far(
    count: 70,
    minRadius: 0.6,
    maxRadius: 1.1,
    minAlpha: 0.22,
    maxAlpha: 0.45,
    parallax: 0.25,
    hasGlow: false,
  ),
  mid(
    count: 34,
    minRadius: 1.1,
    maxRadius: 1.7,
    minAlpha: 0.4,
    maxAlpha: 0.7,
    parallax: 0.55,
    hasGlow: false,
  ),
  near(
    count: 10,
    minRadius: 1.9,
    maxRadius: 2.8,
    minAlpha: 0.7,
    maxAlpha: 0.95,
    parallax: 1,
    hasGlow: true,
  );

  const _StarLayer({
    required this.count,
    required this.minRadius,
    required this.maxRadius,
    required this.minAlpha,
    required this.maxAlpha,
    required this.parallax,
    required this.hasGlow,
  });

  final int count;
  final double minRadius;
  final double maxRadius;
  final double minAlpha;
  final double maxAlpha;
  final double parallax;

  /// 近层星点带一圈光晕，让"亮星"真的像有光而不是大一点的白点。
  final bool hasGlow;
}

/// 单颗星。位置是 0–1 归一化坐标，绘制时再乘画布尺寸。
@immutable
class _Star {
  const _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.baseAlpha,
    required this.phase,
    required this.twinkleCycles,
    required this.color,
    required this.parallax,
    required this.hasGlow,
  });

  final double dx;
  final double dy;
  final double radius;
  final double baseAlpha;

  /// 闪烁相位偏移（0–1）。每颗错开，否则整片星空会一起明灭，像在闪屏。
  final double phase;

  /// 一个 ambient 周期内闪几次。
  final int twinkleCycles;

  final Color color;
  final double parallax;
  final bool hasGlow;
}

/// 星野画笔。
///
/// 关键点：`super(repaint: ...)` 把动画和滚动量直接接到 repaint 上，
/// 于是每帧只重绘这一层，**不进 build 阶段**。
class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter({
    required this.stars,
    required this.twinkle,
    required this.scrollOffset,
    required this.starIntensity,
    required this.bandIntensity,
    required this.animate,
    required this.parallax,
  }) : super(
         repaint: Listenable.merge(<Listenable>[
           if (animate) twinkle,
           if (parallax) scrollOffset,
         ]),
       );

  final List<_Star> stars;
  final Animation<double> twinkle;
  final ValueListenable<double> scrollOffset;

  /// 星点亮度系数（已按 [_starIntensityFloor] 折过）。
  final double starIntensity;

  /// 银河带亮度系数（跟随调用方的 intensity 原值）。
  final double bandIntensity;

  final bool animate;
  final bool parallax;

  @override
  void paint(Canvas canvas, Size size) {
    _paintMilkyWay(canvas, size);

    final t = twinkle.value;
    final offset = parallax ? scrollOffset.value : 0.0;
    final starPaint = Paint();
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _glowSigma);

    for (final star in stars) {
      // 视差位移后对画布高度取模：星点滚出上边就从下边转回来，
      // 天空于是"滚不完"，而不是滚一屏就空了。
      final dy = _wrap(
        star.dy * size.height - offset * star.parallax * _parallaxStrength,
        size.height,
      );
      final center = Offset(star.dx * size.width, dy);
      final alpha = (star.baseAlpha * _twinkleFactor(star, t) * starIntensity)
          .clamp(0.0, 1.0);

      if (star.hasGlow) {
        glowPaint.color = star.color.withValues(alpha: alpha * _glowAlphaRatio);
        canvas.drawCircle(center, star.radius * _glowRadiusRatio, glowPaint);
      }
      starPaint.color = star.color.withValues(alpha: alpha);
      canvas.drawCircle(center, star.radius, starPaint);
    }
  }

  /// 呼吸系数：在 [_twinkleFloor]–1 之间正弦往复。不掉到 0，
  /// 因为星星整颗消失再出现看着像渲染故障，而不是闪烁。
  double _twinkleFactor(_Star star, double t) {
    if (!animate) return 1;
    final wave = math.sin((t * star.twinkleCycles + star.phase) * 2 * math.pi);
    return _twinkleFloor + (1 - _twinkleFloor) * (0.5 + 0.5 * wave);
  }

  /// 银河：一条斜着横过屏幕的柔光带，给星野一点疏密结构，
  /// 不然均匀撒点会看出"是程序画的"。
  void _paintMilkyWay(Canvas canvas, Size size) {
    final band = Rect.fromLTWH(
      -size.width * _bandOverhang,
      size.height * _bandCenterRatio - size.height * _bandThicknessRatio / 2,
      size.width * (1 + _bandOverhang * 2),
      size.height * _bandThicknessRatio,
    );

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(_bandTiltRadians)
      ..translate(-size.width / 2, -size.height / 2)
      ..drawRect(
        band,
        Paint()
          ..shader = HappyGradients.milkyWayBand(
            intensity: bandIntensity,
          ).createShader(band)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _bandSigma),
      )
      ..restore();
  }

  double _wrap(double value, double max) {
    if (max <= 0) return value;
    final wrapped = value % max;
    return wrapped < 0 ? wrapped + max : wrapped;
  }

  @override
  bool shouldRepaint(_StarfieldPainter oldDelegate) =>
      oldDelegate.stars != stars ||
      oldDelegate.starIntensity != starIntensity ||
      oldDelegate.bandIntensity != bandIntensity ||
      oldDelegate.animate != animate ||
      oldDelegate.parallax != parallax;
}

/// 单团星云 / 云絮光斑。
class _NebulaBlob extends StatelessWidget {
  const _NebulaBlob({
    required this.color,
    required this.diameter,
    required this.intensity,
    required this.animate,
    required this.driftY,
  });

  final Color color;
  final double diameter;
  final double intensity;
  final bool animate;
  final double driftY;

  @override
  Widget build(BuildContext context) {
    final blob = IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: HappyGradients.nebulaBlob(color, intensity: intensity),
        ),
      ),
    );

    if (!animate) return blob;

    return blob
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          end: driftY,
          duration: HappyMotion.ambient,
          curve: HappyMotion.ambientCurve,
        )
        .scaleXY(
          begin: 1,
          end: _blobBreathScale,
          duration: HappyMotion.ambient,
          curve: HappyMotion.ambientCurve,
        );
  }
}

// ───────────────────────── 绘制参数 ─────────────────────────
// 这些是星野的"构图"常数，只服务本文件的画法，不构成跨页面复用的设计令牌，
// 所以留在这里而不是进 core/theme。

/// 星野随机种子。固定值 = 每次启动的星空一模一样。
const int _starSeed = 20260809;

/// 星点色板：白色权重最高（重复三次），暖/冷各一份做点缀。
const List<Color> _starPalette = <Color>[
  HappyColors.starCore,
  HappyColors.starCore,
  HappyColors.starCore,
  HappyColors.starWarm,
  HappyColors.starCool,
];

/// 一个 ambient 周期内的闪烁次数候选。取整数避免循环接缝处相位跳变。
const List<int> _twinkleCycles = <int>[1, 2, 3];

/// 呼吸的暗端系数：最暗时仍保留六成亮度。
const double _twinkleFloor = 0.6;

/// 星点亮度的下限：即使调用方把 intensity 压到 0，星点仍保留这个比例。
/// 见 [HappyStarfieldBackground.intensity] 的说明。
const double _starIntensityFloor = 0.65;

/// 滚动量换算到位移的系数。0.06 = 滚一屏（约 800px）近层星野走约 48px：
/// 察觉得到纵深，但不会把注意力从内容上拽走。
const double _parallaxStrength = 0.06;

/// 亮星光晕：半径倍数、相对星点的不透明度、模糊半径。
const double _glowRadiusRatio = 3.2;
const double _glowAlphaRatio = 0.22;
const double _glowSigma = 3.4;

/// 银河带：倾角（约 18°）、厚度、中心位置、左右出屏余量、模糊半径。
const double _bandTiltRadians = 0.31;
const double _bandThicknessRatio = 0.42;
const double _bandCenterRatio = 0.34;
const double _bandOverhang = 0.25;
const double _bandSigma = 28;

/// 星云光斑的构图：出屏偏移、直径占屏宽的比例、漂移距离、呼吸缩放。
const double _blobTopInset = 0.18;
const double _blobLeftInset = 0.35;
const double _blobBottomInset = 0.12;
const double _blobRightInset = 0.4;
const double _blobLargeRatio = 1.15;
const double _blobSmallRatio = 1;
const double _blobSecondaryFalloff = 0.85;
const double _blobDrift = 32;
const double _blobBreathScale = 1.1;

/// 白昼云絮的构图与强度。
const double _cloudTopInset = 0.05;
const double _cloudRightInset = 0.3;
const double _cloudRatio = 0.9;
const double _cloudIntensity = 0.5;
const double _cloudDrift = 18;
