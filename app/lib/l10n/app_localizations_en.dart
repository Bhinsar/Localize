// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterValidPassword => 'Please enter a valid password';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get loginError => 'Login error please try again';

  @override
  String get loginWithGoogle => 'Login with Google';
}
