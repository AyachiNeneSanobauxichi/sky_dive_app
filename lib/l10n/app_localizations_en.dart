// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HappyOS';

  @override
  String get commonOr => 'or';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authIdentifierLabel => 'Email or username';

  @override
  String get authPasswordWeak =>
      'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Log in to continue managing your tasks';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginGoRegister => 'Sign up';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start managing your tasks';

  @override
  String get registerUsernameLabel => 'Username';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerPasswordMismatch => 'Passwords do not match';

  @override
  String get registerAgreementPrefix => 'I have read and agree to the ';

  @override
  String get registerUserAgreement => 'User Agreement';

  @override
  String get registerAgreementAnd => ' and ';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get registerAgreementRequired =>
      'Please read and agree to the User Agreement first';

  @override
  String get registerSubmit => 'Sign up';

  @override
  String get registerHaveAccount => 'Already have an account? ';

  @override
  String get registerGoLogin => 'Log in';

  @override
  String get authErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get registerSuccess => 'Account created. Please log in.';

  @override
  String get homeTitle => 'HappyOS';

  @override
  String get homeBackToLogin => 'Back to login';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonReset => 'Reset';

  @override
  String get homePlaceholder =>
      'Your stories will show up here. Nothing has been built yet.';

  @override
  String get homeLogout => 'Log out';

  @override
  String get homeLogoutFailed => 'Log out failed. Please try again.';

  @override
  String get routeNotFound => 'Page not found';
}
