import "package:sky_dive/core/error/index.dart";
import "package:sky_dive/features/auth/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/utils/index.dart";

/// 认证失败 → 用户可见文案。
///
/// 认证的业务错误码有**明确且稳定**的含义（密码错、验证码错、邮箱已占用…），
/// 所以这里优先按码出本地化文案，而不是直接用服务端下发的那句
/// ——服务端的文案未必翻译过，也未必符合本产品的语气。
/// 码表以外的一切交给 [localizedFailureMessage] 兜底。
String authFailureMessage(Object error, AppLocalizations l10n) {
  if (error case BusinessFailure(:final code)) {
    final known = _messageForCode(code, l10n);
    if (known != null) return known;
  }
  return localizedFailureMessage(error, l10n);
}

String? _messageForCode(int code, AppLocalizations l10n) => switch (code) {
  AuthErrorCode.credentialsInvalid => l10n.authErrorCredentials,
  AuthErrorCode.smsCodeIncorrect => l10n.authErrorCodeIncorrect,
  AuthErrorCode.smsCodeExpired => l10n.authErrorCodeExpired,
  AuthErrorCode.emailAlreadyRegistered => l10n.authErrorEmailTaken,
  AuthErrorCode.phoneAlreadyRegistered => l10n.authErrorPhoneTaken,
  AuthErrorCode.accountDisabled => l10n.authErrorAccountDisabled,
  _ => null,
};
