/// 由生日推导出来的东西。
///
/// 为什么要推导而不是让用户填：年龄和星座**都是生日的函数**，让用户各填一遍，
/// 只会制造"生日 1996-10-08、星座填了金牛座"这种自相矛盾的数据，
/// 而 story 生成正是拿这些当素材。生日一处填对，其余自动跟上。
library;

/// 由生日推算周岁（今年生日未到则减一岁）。生日填成未来日期时返回 null。
int? ageFromBirthday(DateTime birthday, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final hadBirthdayThisYear =
      today.month > birthday.month ||
      (today.month == birthday.month && today.day >= birthday.day);
  final age = today.year - birthday.year - (hadBirthdayThisYear ? 0 : 1);
  return age < 0 ? null : age;
}

/// 由生日推算星座。
///
/// 返回的是**后端约定的中文名**（契约里 `zodiac: "天秤座"`），不是展示文案——
/// 它要原样发回服务端，也要能和后端已有数据对得上。
// TODO(user): 展示层日后若要按语言显示星座（英文界面现在也显示中文），
//   在这里加一层 中文值 → 枚举 → l10n 的映射，别在 UI 里各写各的。
String zodiacFromBirthday(DateTime birthday) {
  final md = birthday.month * 100 + birthday.day;
  for (final (start, name) in _zodiacRanges) {
    if (md >= start) return name;
  }
  // 1 月 1 日 ~ 1 月 19 日落在这里：跨年的摩羯座。
  return _capricorn;
}

const String _capricorn = "摩羯座";

/// 各星座的**起始日**（含），按倒序排列，配合上面的"第一个不大于它的区间"查找。
/// 用 `月*100+日` 这种整数比较，避免为 12 个区间写 24 个日期比较。
const List<(int, String)> _zodiacRanges = <(int, String)>[
  (1222, _capricorn),
  (1122, "射手座"),
  (1023, "天蝎座"),
  (923, "天秤座"),
  (823, "处女座"),
  (723, "狮子座"),
  (622, "巨蟹座"),
  (521, "双子座"),
  (420, "金牛座"),
  (321, "白羊座"),
  (219, "双鱼座"),
  (120, "水瓶座"),
];
