# 09 · 主题与 UI

> ⚠️ 本模块只管**视觉令牌**（用什么颜色 / 间距 / 时长）。**交互体验**（反馈四时刻、异步四态、触感、键盘、无障碍、主动提更优 UI 方案）见 `17-ux-interaction.md`——本项目是 C 端产品，两个模块都必须过。

> 设计系统集中在 `lib/core/theme/`，全局组件在 `lib/shared/widgets/`（`Sky*` 前缀），feature 私有组件在各 feature 的 `widgets/`。底座是 Material 3，**不引入 shadcn_flutter / forui 之类的整套 UI 框架**（理由见文末）。

## 🎨 设计基调：高空 · 深浅双主场

SkyDive 是日本跳伞运营商的 C 端 app，核心画面是**从万米高空跃出**：头顶纯净的平流层蓝、脚下翻涌的云海、伞衣张开时那一抹朱橙。因此：

- **深浅两套都是一等设计目标**。浅色 = 白昼晴空（客人白天挑航线、看天气、下预约，主流场景）；深色 = 暮色高空（黄昏跳与夜间查看行程）。写任何 UI 都要在两套主题下都看一眼，两套都按 WCAG AA 校过对比度。
- **品牌语言 = 高空蓝 → 高空青的光**，配**伞衣朱橙**做重音（一屏最多一处）。渐变、光晕、天空背景是识别物，不是装饰。
- **只有一个字体族**（Inter）。航空产品的气质来自仪表盘式的中性无衬线体，标题层级靠字号 + 字重 + 负字距拉开，**不引第二种字体族**。全档位开等宽数字（`tabularFigures`）——满屏的时刻、海拔、价格、剩余名额必须能对齐。

## 🧱 令牌总览

| 文件 | 类 | 管什么 |
| --- | --- | --- |
| `app_colors.dart` | `SkyColors` | 原始色值。**业务层禁止直接引用**，只给 `app_theme` / `app_gradients` / `app_shadows` 当原料 |
| `app_theme.dart` | `SkyTheme` | `light` / `dark` 两套 `ThemeData` 装配 |
| `app_text_styles.dart` | `SkyFonts`、`SkyTextStyles` | 字体族与中文回退链、完整 `TextTheme` |
| `app_spacing.dart` | `SkySpacing`、`SkySemanticSpacing`、`SkyRadius`、`SkyBorderWidth`、`SkyIconSize`、`SkyControlSize` | 间距 / 圆角 / 描边 / 图标 / 控件尺寸 |
| `app_gradients.dart` | `SkyGradients` | 品牌渐变、天幕、星云光斑、银河带、玻璃高光、流光 |
| `app_shadows.dart` | `SkyShadows` | 阴影与品牌光晕（按 `Brightness` 分支） |
| `app_motion.dart` | `SkyMotion` | 动效时长与缓动曲线 |

全部经 `lib/core/theme/index.dart` 导出，业务层 `import "package:sky_dive/core/theme/index.dart";`。

## 🚫 红线：禁止魔法值

```dart
// ❌ 禁止
padding: const EdgeInsets.all(16),
borderRadius: BorderRadius.circular(12),
textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
color: const Color(0xFF7C3AED),
duration: const Duration(milliseconds: 300),
BoxShadow(color: Colors.black26, blurRadius: 8),

// ✅ 用令牌
padding: const EdgeInsets.all(SkySemanticSpacing.cardPadding),
borderRadius: BorderRadius.circular(SkyRadius.card),
style: Theme.of(context).textTheme.labelLarge,
color: Theme.of(context).colorScheme.primary,
duration: SkyMotion.normal,
boxShadow: SkyShadows.card(Theme.of(context).brightness),
```

对应关系：

- 间距 → `SkySemanticSpacing`（优先）/ `SkySpacing`
- 圆角 → `SkyRadius`；描边宽度 → `SkyBorderWidth`；图标 → `SkyIconSize`；控件高度 → `SkyControlSize`
- 颜色 → `Theme.of(context).colorScheme`
- 文字 → `Theme.of(context).textTheme`
- 渐变 → `SkyGradients`；阴影 / 光晕 → `SkyShadows`
- 时长 / 曲线 → `SkyMotion`

## 📌 间距：数值后缀命名

`SkySpacing` 用 `s4 / s8 / s12 / s16 / s20 / s24 / s32 …` 而不是 `sm / md / lg`。T 恤码会把刻度藏起来（历史上就因此缺了 12 和 20 两档没人发现），数值命名让整条 4pt 阶梯一眼可见，也能和设计稿的 "gap 20" 一一对应。

**优先用语义别名**，只有覆盖不到时才用原始刻度：

```dart
SkySemanticSpacing.screenPadding  // 页面左右边距 20
SkySemanticSpacing.cardPadding    // 卡片内边距 16
SkySemanticSpacing.sectionGap     // 区块间距 32
SkySemanticSpacing.itemGap        // 条目间距 12
SkySemanticSpacing.labelGap       // 标签与控件 8
```

## 📌 字体

```dart
// 航班牌大标题——只给首屏主标题、开屏、空态主文案
Text(title, style: theme.textTheme.displaySmall)
// 页面 / 区块标题（Inter）
Text(section, style: theme.textTheme.headlineMedium)
// 长说明文（行高 1.6，安全须知 / 退改规则这类长文专用）
Text(body, style: theme.textTheme.bodyLarge)
```

- **`display*` 是"航班牌"档位**：Inter w700 + 强负字距，只给首屏主标题、空态主文案、成绩数字这类"要被看见"的地方用。
- 全部 Inter（400/500/600/700 静态字重，打包在 `assets/fonts/`），**没有第二个字体族**。
- **只打包拉丁字体**（约 700KB）。日文 / 中文走系统回退（`SkyFonts.textFallback`），不打包思源黑体——一个字重就 8–16MB。⚠️ 回退链**日文优先**（主市场是日本），代价是简中界面下共用汉字会显示日文字形，取舍写在 `app_text_styles.dart` 里。
- 新增字重 / 字体族必须同时改 `pubspec.yaml` 的 `fonts:` 段和 `SkyFonts`。

## 📌 颜色与主题

`SkyTheme` **不用 `ColorScheme.fromSeed`**，而是逐角色显式指定。`fromSeed` 的明度台阶由算法决定，做不出"暮色海军蓝 + 精确三级表面"这种有个性的深色画布，也保不住浅色下"晴空白蓝"那一点冷调；显式指定后结果可预测、可评审、可校对比度。

深色三级表面（层级靠色阶而不是阴影表达）：

| 角色 | 用途 |
| --- | --- |
| `surfaceContainerLowest` / `scaffoldBackgroundColor` | 页面画布 |
| `surfaceContainerLow` | 常规卡片 |
| `surfaceContainer` / `surfaceContainerHigh` | 输入框、列表项、次级按钮 |
| `surfaceContainerHighest` | 弹层、菜单、toast |

`surfaceTint` 已置为透明：M3 的色调抬升会给深色卡片蒙一层紫雾，和上面的色阶打架。

## 📌 阴影与光晕

深色底上投黑影等于什么都没发生。所以：

- **浅色**用 `SkyShadows.card(brightness)` / `lifted(brightness)` 表达层级；
- **深色**层级靠表面色阶，"这个元素是活的/可点的"靠 `SkyShadows.glow(color)`。

```dart
boxShadow: SkyShadows.glow(scheme.primary),          // 主按钮、选中态
boxShadow: SkyShadows.lifted(theme.brightness),      // 弹层、toast
```

## 📌 动效

```dart
AnimatedContainer(duration: SkyMotion.normal, curve: SkyMotion.standard, …)

// 入场（flutter_animate）
widget.animate().fadeIn(duration: SkyMotion.slow, curve: SkyMotion.standard)

// 环境动效必须尊重系统"减弱动态效果"
final shouldAnimate = !MediaQuery.disableAnimationsOf(context);
```

时长档位：`instant`(90) / `fast`(160) / `normal`(240) / `slow`(400) / `hero`(700) / `ambient`(6000)。

## 📌 全局组件（`lib/shared/widgets/`）

| 组件 | 用途 | 注意 |
| --- | --- | --- |
| `SkyButton` | 主按钮。`variant`：`primary`（品牌渐变+光晕）/ `secondary` / `ghost` / `danger`；`size`：`small` / `medium` / `large` | 自带按下缩放 + 触感反馈；一屏最多一个 `primary` |
| `SkyCheckbox` / `SkyCheckboxFormField` | 复选框，后者接 `Form` 校验 | |
| `SkyOtpField` | 分离式验证码输入（N 格 OTP），本身是 `FormField` | **透明原生 `TextField` 盖在格子上**，格子只是皮肤——这样粘贴 6 位数、iOS 短信自动填充（`oneTimeCode`）才照常工作；自绘 N 个独立输入框会丢掉这两项。填满触发 `onCompleted`（供调用方自动提交）并给一次轻触感；一次性填入多位时逐格入场；`isSuccess` 把格子换成对勾（换页前的成功确认） |
| `SkyToast` | 全局轻提示 | 见下 |
| `SkyEmptyState` | 空态骨架：品牌标记 + 标题 + 说明 + **引导行动** | 行动是一等参数——只写"暂无数据"的空态不合规；功能未上线时按钮给 `SkyToast.info` 而不是静默 |
| `SkyBrandMark` | 品牌标记（渐变方块 + 图标 + 光晕） | 开屏 / 认证页头 / 空态 |
| `SkyBackground` | 品牌天空背景（天幕渐变 + 三层视差云 + 光晕；深色另加高空星点与地平线余晖） | **只用在需要氛围的页面**（开屏、登录注册、首页外壳、空态）；列表 / 表单等信息密集页把 `intensity` 压到 0.5 以下（**云带有亮度下限**，不会跟着消失——云是主题的结构而非氛围光），长内容页可另加 `parallax: false` |
| `SkyRetryCard` | 内联失败重试卡 | **内联**在内容下方，不是弹窗、不是整页错误态；已有内容必须留在原地 |
| `SkyGlassCard` | 毛玻璃卡片 | `BackdropFilter` 每帧重采样背景，**一屏 1–3 个封顶**；普通内容卡用 `Card`（主题已配好描边圆角） |

新增全局组件：`Sky` 前缀 + `sky_*.dart` + 放 `lib/shared/widgets/<类别>/` + 更新 barrel。详见 `03-naming-conventions.md`。

## 📌 加载态：用骨架屏，不用 loading 转圈

接口请求 / 异步加载「内容型」界面（列表、详情、表单预填）时，**优先用骨架屏**（`skeletonizer`）占位，**不要**用 `CircularProgressIndicator` 等 loading 转圈。

```dart
import "package:skeletonizer/skeletonizer.dart";

// 用真实布局包一层 Skeletonizer：加载时自动渲染成骨架，数据到位后原样展示。
Skeletonizer(
  enabled: isLoading,
  child: ListView.builder(
    // 加载中喂「若干条占位数据」给同一套 item widget，骨架形状自动贴合真实布局。
    itemCount: isLoading ? 6 : items.length,
    itemBuilder: (_, i) => TodoListItem(todo: isLoading ? Todo.placeholder() : items[i]),
  ),
)
```

- **页面级 / 列表级加载一律骨架屏**；骨架用同一套 item widget + 占位数据渲染，不另写占位形状。
- 例外：按钮内联忙碌态（提交中）仍可用小转圈（`SkyButton.isLoading`）。
- 冷启动等待用 `SplashScreen` 的呼吸品牌标记，不用转圈。

## 📌 轻提示：统一走 SkyToast

用户提示（成功 / 失败 / 警告 / 信息）**一律用 `SkyToast`**（`lib/shared/widgets/toast/`，基于 `toastification` 的 `showCustom`），**不要**直接用 `ScaffoldMessenger.showSnackBar` 或裸调 `toastification`。app 根已挂 `ToastificationWrapper`（`app.dart`）。

```dart
SkyToast.success(context, l10n.bookingSaveSuccess);
SkyToast.error(context, failure.displayMessage);
SkyToast.warning(context, message);
SkyToast.info(context, message);
```

> 样式（顶部、深色卡片 + 语义色图标胶囊、3 秒自动关、点击即关、成功/失败带触感）集中在 `SkyToast`，改样式只改一处。

## 📦 可用的 UI 相关三方库

| 库 | 用途 |
| --- | --- |
| `flutter_animate` | 声明式动画链（入场、呼吸、微交互） |
| `animations` | M3 转场（页面转场已在 `SkyTheme` 里配好共享横轴） |
| `flutter_svg` | SVG 图标与插画 |
| `lucide_icons_flutter` | 图标集（`LucideIcons.xxx`）。**Lucide 不含品牌 logo**，三方登录等场景用 SVG |
| `skeletonizer` | 骨架屏 |
| `toastification` | toast 底层（只经 `SkyToast` 使用） |
| `cached_network_image` | 网络图 |

### 为什么不引入整套 UI 框架

`shadcn_flutter` 会用 `ShadcnApp` + `ShadTheme` 替换 `MaterialApp` / `ThemeData`，直接废掉本仓库"走 `colorScheme` / `textTheme`"的红线，`skeletonizer` 与 `toastification` 也依赖 Material `Theme`。且这类库的气质是 Web SaaS / 后台面板（中性灰、细边框、小圆角、桌面密度），和 C 端叙事产品相反。

需要某个组件（Sheet、Command Palette、Toggle Group…）时的正确做法：**读 shadcn_ui / forui 的源码当参考，用本仓库的令牌重写成 `Sky*` 组件，不引依赖**。

## ✅ 其它约定

- **组件拆分**：`build` 过长时拆成小 Widget（class 优先于返回 Widget 的方法，利于 const 与重建优化）。
- **const 化**：静态子树尽量 `const`。
- **列表** 用 `ListView.builder` / `SliverList` 懒加载；给 item 稳定 `key`。
- **网络图** 用 `CachedNetworkImage`，配 `placeholder` 与 `errorWidget`。
- **无障碍**：交互控件提供 `Semantics` / `tooltip`，可点热区 ≥ `SkyControlSize.minTapTarget`（44）。
- **响应式**：用 `LayoutBuilder` / `MediaQuery` 适配，避免写死尺寸。

## ❌ 避免

- ❌ 硬编码颜色 `Color(0xFF...)`、字号、间距、时长散落各处。
- ❌ 业务层直接引用 `SkyColors`（应走 `colorScheme`）。
- ❌ 在 `screens/` · `widgets/` 里直接引 `SkyColors`（业务层只能走 `colorScheme`）。
- ❌ 满屏 `SkyGlassCard` / `SkyBackground`（性能与注意力双输）。
- ❌ 在 `build` 里创建 controller / 大对象（应在 `initState` / provider）。
- ❌ 用 `Column` + 大量子项代替可滚动懒加载列表。
- ❌ 业务逻辑写进 Widget。

