import "package:happy_os/features/user/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 档案字段 key → 展示文案。
///
/// 单独抽出来是因为有两个调用方：档案卡列字段、档案设置页显示"你要补的是哪一项"。
/// 两处各写一遍 switch 迟早对不上。
String userProfileFieldLabel(AppLocalizations l10n, UserProfileFieldKey key) {
  return switch (key) {
    UserProfileFieldKey.gender => l10n.userFieldGender,
    UserProfileFieldKey.age => l10n.userFieldAge,
    UserProfileFieldKey.birthday => l10n.userFieldBirthday,
    UserProfileFieldKey.zodiac => l10n.userFieldZodiac,
    UserProfileFieldKey.city => l10n.userFieldCity,
    UserProfileFieldKey.occupation => l10n.userFieldOccupation,
    UserProfileFieldKey.industry => l10n.userFieldIndustry,
    UserProfileFieldKey.company => l10n.userFieldCompany,
    UserProfileFieldKey.hobbies => l10n.userFieldHobbies,
  };
}
