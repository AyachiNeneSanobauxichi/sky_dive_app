import "dart:math" as math;

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:sky_dive/core/theme/index.dart";

/// 天空背景：SkyDive 的招牌视觉，也是深浅两套主题差异最大的一层。
///
/// 四层叠出来的"天"：
/// 1. **天幕**——竖向渐变（`SkyGradients.skyFor`），天顶深、地平亮，让整屏一眼读成天空；
/// 2. **云层**——三层视差云带，缓慢横向漂移；浅色是白云，深色是比天幕更暗的云海剪影；
/// 3. **星点**——只在深色出现，且只撒在天幕上半部（跳伞高度之上才看得见星），
///    越靠近地平线越稀薄；
/// 4. **光**——浅色是右上角的阳光光晕，深色是贴着屏幕下缘的日落余晖 + 一团高空蓝雾。
///
/// ## 为什么云是"结构"而不是装饰
/// 只有渐变的天幕会被读成一张色卡。云是唯一能同时交代**距离**（视差）与
/// **尺度**（人在云之上）的元素，而这两件事正是跳伞产品要卖的东西。
/// 所以 [intensity] 压低时先退的是光晕和星点，云带保留 [_cloudIntensityFloor]。
///
/// ## 性能
/// 云与星是**一个** [CustomPainter]，靠 `repaint` 直接监听动画与滚动量，
/// **不触发任何 widget 重建**，每帧成本约等于一次渐变填充加数十次模糊绘制。
/// 云与星的位置在 `initState` 用固定种子生成一次（存的是 0–1 归一化坐标），
/// 所以旋屏、键盘弹出都不会让它们跳位。
/// 系统开启"减弱动态效果"时，漂移、闪烁与视差一起关掉，只留静止的天。
///
/// 用在需要氛围的页面（开屏、登录注册、首页外壳、空态）。
/// 列表 / 表单等信息密集页把 [intensity] 压到 0.5 以下。
class SkyBackground extends StatefulWidget {
  const SkyBackground({
    super.key,
    required this.child,
    this.animate = true,
    this.intensity = 1,
    this.parallax = true,
  });

  final Widget child;

  /// 是否让云漂移、星点呼吸、光晕缓动。系统开启"减弱动态效果"时会被强制关掉。
  final bool animate;

  /// 氛围光强系数（0–1）。信息密集的页面调到 0.5 以下更稳妥。
  ///
  /// 主要压的是**光晕与星点**这类大面积柔光；云带只按 [_cloudIntensityFloor] 打折
  /// ——云是这个主题的"结构"而不是氛围光，见类注释。
  final double intensity;

  /// 是否随内容滚动做云层视差。列表页开着能强化"内容在云之上"的纵深；
  /// 长文阅读页可以关掉，避免眼睛被背景牵着走。
  final bool parallax;

  @override
  State<SkyBackground> createState() => _SkyBackgroundState();
}

class _SkyBackgroundState extends State<SkyBackground>
    with SingleTickerProviderStateMixin {
  /// 环境相位驱动。线性 0→1 循环，**不加曲线**：曲线会让循环接缝处的速度突变
  /// 变成肉眼可见的"一顿"。云的横向漂移与星点的呼吸共用这一个相位。
  late final AnimationController _ambient = AnimationController(
    duration: SkyMotion.ambient,
    vsync: this,
  );

  /// 当前竖向滚动量，云层据此做视差。
  /// 用 [ValueNotifier] 而不是 `setState`：滚动每帧都在变，走 setState 会把
  /// 整棵子树（含 child 里的整个页面）拖进重建。
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0);

  late final List<_Cloud> _clouds = _generateClouds();
  late final List<_Star> _stars = _generateStars();

  @override
  void initState() {
    super.initState();
    _ambient.repeat();
  }

  @override
  void dispose() {
    _ambient.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  /// 只吃**竖向**滚动：横向的日期 / 航线筛选条也会冒 `ScrollNotification`，
  /// 拿它去驱动视差会让天空在拖 chip 时莫名其妙地动。
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
    final haloIntensity = widget.intensity * (isDark ? 0.34 : 0.14);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: SkyGradients.skyFor(theme.brightness),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RepaintBoundary(
            child: CustomPaint(
              painter: _SkyPainter(
                clouds: _clouds,
                stars: _stars,
                ambient: _ambient,
                scrollOffset: _scrollOffset,
                isDark: isDark,
                cloudIntensity:
                    _cloudIntensityFloor +
                    (1 - _cloudIntensityFloor) * widget.intensity,
                starIntensity: widget.intensity,
                animate: shouldAnimate,
                parallax: widget.parallax && shouldAnimate,
              ),
            ),
          ),
          ..._halos(isDark, haloIntensity, shouldAnimate),
          // 地平线余晖：深色天幕唯一的暖色光源，把"夜"说成"日落后的高空"。
          if (isDark)
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: _horizonGlowHeightRatio,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: SkyGradients.horizonGlow(
                        intensity: widget.intensity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

  /// 氛围光斑：浅色是右上角的阳光 + 一团淡品牌蓝，深色是高空蓝雾 + 地平线暖光。
  List<Widget> _halos(bool isDark, double intensity, bool animate) {
    final size = MediaQuery.sizeOf(context);

    return <Widget>[
      Positioned(
        top: -size.height * _haloTopInset,
        right: -size.width * _haloRightInset,
        child: _HaloBlob(
          // 浅色：太阳在右上。深色：高空的冷蓝雾。
          color: isDark ? SkyColors.azureBright : SkyColors.sunGlow,
          diameter: size.width * _haloLargeRatio,
          intensity: intensity * (isDark ? 1 : _sunHaloBoost),
          animate: animate,
          driftY: _haloDrift,
        ),
      ),
      Positioned(
        bottom: -size.height * _haloBottomInset,
        left: -size.width * _haloLeftInset,
        child: _HaloBlob(
          color: isDark ? SkyColors.canopyBright : SkyColors.azure,
          diameter: size.width * _haloSmallRatio,
          intensity: intensity * _haloSecondaryFalloff,
          animate: animate,
          // 反向漂移，两团光才不会像同一块东西在整体平移
          driftY: -_haloDrift,
        ),
      ),
    ];
  }

  /// 生成三层云。固定种子 → 每次启动的天长得一样（当成品牌资产而不是随机噪点）。
  List<_Cloud> _generateClouds() {
    final random = math.Random(_skySeed);
    final clouds = <_Cloud>[];

    for (final layer in _CloudLayer.values) {
      for (var i = 0; i < layer.count; i++) {
        clouds.add(
          _Cloud(
            // 归一化坐标：与画布尺寸解耦，旋屏不跳位。
            dx: random.nextDouble(),
            // 每层云占据天幕的一个高度区间：远云高、近云低，
            // 这是"云在不同距离上"最直接的表达。
            dy: layer.minDy + random.nextDouble() * (layer.maxDy - layer.minDy),
            widthRatio:
                layer.minWidth +
                random.nextDouble() * (layer.maxWidth - layer.minWidth),
            alpha:
                layer.minAlpha +
                random.nextDouble() * (layer.maxAlpha - layer.minAlpha),
            // 漂移相位错开，云才不像一整块布在平移。
            phase: random.nextDouble(),
            parallax: layer.parallax,
            drift: layer.drift,
            blurSigma: layer.blurSigma,
          ),
        );
      }
    }

    return clouds;
  }

  /// 生成星点（仅深色使用）。同样固定种子。
  List<_Star> _generateStars() {
    final random = math.Random(_skySeed ~/ 2);
    return List<_Star>.generate(_starCount, (index) {
      return _Star(
        dx: random.nextDouble(),
        // 星点只撒在天幕上 [_starSkyRatio] 的范围内：跳伞高度之下的天已经被
        // 地面光染亮，撒到地平线上会读成噪点。
        dy: random.nextDouble() * _starSkyRatio,
        radius:
            _starMinRadius +
            random.nextDouble() * (_starMaxRadius - _starMinRadius),
        baseAlpha:
            _starMinAlpha +
            random.nextDouble() * (_starMaxAlpha - _starMinAlpha),
        phase: random.nextDouble(),
        // 闪烁速度取整数倍：非整数倍在 6s 循环回到 0 时会有一次相位跳变。
        twinkleCycles: _twinkleCycles[random.nextInt(_twinkleCycles.length)],
        color: _starPalette[random.nextInt(_starPalette.length)],
      );
    });
  }
}

/// 云的三层。远层多、宽、淡、几乎不动；近层少、大、实、视差最强。
/// 纵深感真正的来源是**视差系数的差**，不是模糊程度。
enum _CloudLayer {
  far(
    count: 5,
    minDy: 0.18,
    maxDy: 0.42,
    minWidth: 0.42,
    maxWidth: 0.7,
    minAlpha: 0.16,
    maxAlpha: 0.3,
    parallax: 0.2,
    drift: 14,
    blurSigma: 26,
  ),
  mid(
    count: 4,
    minDy: 0.44,
    maxDy: 0.68,
    minWidth: 0.6,
    maxWidth: 0.95,
    minAlpha: 0.28,
    maxAlpha: 0.46,
    parallax: 0.55,
    drift: 26,
    blurSigma: 32,
  ),
  near(
    count: 3,
    minDy: 0.7,
    maxDy: 1.02,
    minWidth: 0.9,
    maxWidth: 1.35,
    minAlpha: 0.42,
    maxAlpha: 0.62,
    parallax: 1,
    drift: 40,
    blurSigma: 40,
  );

  const _CloudLayer({
    required this.count,
    required this.minDy,
    required this.maxDy,
    required this.minWidth,
    required this.maxWidth,
    required this.minAlpha,
    required this.maxAlpha,
    required this.parallax,
    required this.drift,
    required this.blurSigma,
  });

  final int count;
  final double minDy;
  final double maxDy;
  final double minWidth;
  final double maxWidth;
  final double minAlpha;
  final double maxAlpha;
  final double parallax;

  /// 一个 ambient 周期内横向漂移的像素数。
  final double drift;

  /// 模糊半径。云没有边界，这个值撑起"软"的观感。
  final double blurSigma;
}

/// 单朵云。位置是 0–1 归一化坐标，绘制时再乘画布尺寸。
@immutable
class _Cloud {
  const _Cloud({
    required this.dx,
    required this.dy,
    required this.widthRatio,
    required this.alpha,
    required this.phase,
    required this.parallax,
    required this.drift,
    required this.blurSigma,
  });

  final double dx;
  final double dy;

  /// 云宽占屏宽的比例。高度由 [_cloudAspect] 派生，保证云永远是扁的。
  final double widthRatio;

  final double alpha;

  /// 漂移相位偏移（0–1）。每朵错开，否则整层云会一起平移，像一张贴图在滑。
  final double phase;

  final double parallax;
  final double drift;
  final double blurSigma;
}

/// 单颗星。位置是 0–1 归一化坐标。
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
}

/// 天空画笔：先星后云（云在星前面，才是正确的前后关系）。
///
/// 关键点：`super(repaint: ...)` 把动画和滚动量直接接到 repaint 上，
/// 于是每帧只重绘这一层，**不进 build 阶段**。
class _SkyPainter extends CustomPainter {
  _SkyPainter({
    required this.clouds,
    required this.stars,
    required this.ambient,
    required this.scrollOffset,
    required this.isDark,
    required this.cloudIntensity,
    required this.starIntensity,
    required this.animate,
    required this.parallax,
  }) : super(
         repaint: Listenable.merge(<Listenable>[
           if (animate) ambient,
           if (parallax) scrollOffset,
         ]),
       );

  final List<_Cloud> clouds;
  final List<_Star> stars;
  final Animation<double> ambient;
  final ValueListenable<double> scrollOffset;

  final bool isDark;

  /// 云带亮度系数（已按 [_cloudIntensityFloor] 折过）。
  final double cloudIntensity;

  /// 星点亮度系数（跟随调用方的 intensity 原值）。
  final double starIntensity;

  final bool animate;
  final bool parallax;

  @override
  void paint(Canvas canvas, Size size) {
    final t = ambient.value;
    final offset = parallax ? scrollOffset.value : 0.0;

    if (isDark) _paintStars(canvas, size, t, offset);
    _paintClouds(canvas, size, t, offset);
  }

  void _paintStars(Canvas canvas, Size size, double t, double offset) {
    final paint = Paint();
    for (final star in stars) {
      final dy = _wrap(
        star.dy * size.height - offset * _starParallax * _parallaxStrength,
        size.height,
      );
      // 越接近地平线星越稀薄：靠 dy 线性衰减，比"硬切一条线"自然。
      final horizonFade = (1 - dy / size.height / _starSkyRatio).clamp(
        0.0,
        1.0,
      );
      final alpha =
          (star.baseAlpha *
                  _twinkleFactor(star, t) *
                  starIntensity *
                  horizonFade)
              .clamp(0.0, 1.0);
      if (alpha <= 0) continue;
      paint.color = star.color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(star.dx * size.width, dy), star.radius, paint);
    }
  }

  void _paintClouds(Canvas canvas, Size size, double t, double offset) {
    // 深色画比天幕更暗的云海剪影，浅色画白云——同一套几何，两种读法。
    final color = isDark ? SkyColors.cloudDark : SkyColors.cloudLight;
    // 白云要比暗云更实才看得见：暗云是往下压（底子是深蓝，压暗立刻成立），
    // 白云是往上提，而白昼天幕本身已经很亮，同一档不透明度在浅色下几乎无效。
    final alphaScale = cloudIntensity * (isDark ? 1 : _lightCloudBoost);

    for (final cloud in clouds) {
      // 横向：ambient 相位驱动的正弦往复。用往复而不是单向平移，
      // 循环回到 0 时才没有"跳回起点"的接缝。
      final drift = animate
          ? math.sin((t + cloud.phase) * 2 * math.pi) * cloud.drift
          : 0.0;
      // 竖向：视差位移后对画布高度取模，云滚出上边就从下边转回来，
      // 天于是"滚不完"，而不是滚一屏就空了。
      final dy = _wrap(
        cloud.dy * size.height - offset * cloud.parallax * _parallaxStrength,
        size.height,
      );
      final width = cloud.widthRatio * size.width;
      final rect = Rect.fromCenter(
        center: Offset(cloud.dx * size.width + drift, dy),
        width: width,
        height: width * _cloudAspect,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
        Paint()
          ..color = color.withValues(
            alpha: (cloud.alpha * alphaScale).clamp(0.0, 1.0),
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, cloud.blurSigma),
      );
    }
  }

  /// 呼吸系数：在 [_twinkleFloor]–1 之间正弦往复。不掉到 0，
  /// 因为星星整颗消失再出现看着像渲染故障，而不是闪烁。
  double _twinkleFactor(_Star star, double t) {
    if (!animate) return 1;
    final wave = math.sin((t * star.twinkleCycles + star.phase) * 2 * math.pi);
    return _twinkleFloor + (1 - _twinkleFloor) * (0.5 + 0.5 * wave);
  }

  double _wrap(double value, double max) {
    if (max <= 0) return value;
    final wrapped = value % max;
    return wrapped < 0 ? wrapped + max : wrapped;
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) =>
      oldDelegate.clouds != clouds ||
      oldDelegate.stars != stars ||
      oldDelegate.isDark != isDark ||
      oldDelegate.cloudIntensity != cloudIntensity ||
      oldDelegate.starIntensity != starIntensity ||
      oldDelegate.animate != animate ||
      oldDelegate.parallax != parallax;
}

/// 单团光晕（阳光 / 蓝雾 / 余晖）。
class _HaloBlob extends StatelessWidget {
  const _HaloBlob({
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
          gradient: SkyGradients.haloBlob(color, intensity: intensity),
        ),
      ),
    );

    if (!animate) return blob;

    return blob
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          end: driftY,
          duration: SkyMotion.ambient,
          curve: SkyMotion.ambientCurve,
        )
        .scaleXY(
          begin: 1,
          end: _haloBreathScale,
          duration: SkyMotion.ambient,
          curve: SkyMotion.ambientCurve,
        );
  }
}

// ───────────────────────── 绘制参数 ─────────────────────────
// 这些是天空的"构图"常数，只服务本文件的画法，不构成跨页面复用的设计令牌，
// 所以留在这里而不是进 core/theme。

/// 云与星的随机种子。固定值 = 每次启动的天一模一样。
const int _skySeed = 20260830;

/// 云的高宽比。0.26 = 明显扁平，接近真实积云在远处的投影比例；
/// 数值再大就会读成"圆球"而不是云。
const double _cloudAspect = 0.26;

/// 云带亮度的下限：即使调用方把 intensity 压到 0，云仍保留这个比例。
/// 见 [SkyBackground.intensity] 的说明。
const double _cloudIntensityFloor = 0.55;

/// 浅色模式下云的不透明度倍数。见 `_paintClouds` 里的说明。
const double _lightCloudBoost = 1.6;

/// 滚动量换算到位移的系数。0.06 = 滚一屏（约 800px）近层云走约 48px：
/// 察觉得到纵深，但不会把注意力从内容上拽走。
const double _parallaxStrength = 0.06;

/// 星点。数量刻意少于云——高空的星是点缀，多了就变回"星空 app"。
const int _starCount = 46;
const double _starMinRadius = 0.7;
const double _starMaxRadius = 1.8;
const double _starMinAlpha = 0.3;
const double _starMaxAlpha = 0.85;

/// 星点分布的高度上限（占屏高比例）：只在天幕上四成撒星。
const double _starSkyRatio = 0.42;

/// 星点视差系数。比近层云弱得多——星在无穷远处，几乎不该跟着滚。
const double _starParallax = 0.12;

/// 星点色板：白色权重最高（重复三次），暖/冷各一份做点缀。
const List<Color> _starPalette = <Color>[
  SkyColors.starCore,
  SkyColors.starCore,
  SkyColors.starCore,
  SkyColors.starWarm,
  SkyColors.starCool,
];

/// 一个 ambient 周期内的闪烁次数候选。取整数避免循环接缝处相位跳变。
const List<int> _twinkleCycles = <int>[1, 2, 3];

/// 呼吸的暗端系数：最暗时仍保留六成亮度。
const double _twinkleFloor = 0.6;

/// 地平线余晖占屏高的比例。
const double _horizonGlowHeightRatio = 0.38;

/// 光晕的构图：出屏偏移、直径占屏宽的比例、漂移距离、呼吸缩放。
const double _haloTopInset = 0.16;
const double _haloRightInset = 0.32;
const double _haloBottomInset = 0.14;
const double _haloLeftInset = 0.38;
const double _haloLargeRatio = 1.1;
const double _haloSmallRatio = 0.95;
const double _haloSecondaryFalloff = 0.8;
const double _haloDrift = 28;
const double _haloBreathScale = 1.08;

/// 阳光光晕在浅色下要比品牌蓝更亮一点才看得见（暖色在白底上本就更弱）。
const double _sunHaloBoost = 1.8;
