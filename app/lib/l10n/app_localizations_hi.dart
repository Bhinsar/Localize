// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get email => 'ईमेल';

  @override
  String get pleaseEnterEmail => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get pleaseEnterValidEmail => 'कृपया एक मान्य ईमेल दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get pleaseEnterPassword => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get pleaseEnterValidPassword => 'कृपया एक मान्य पासवर्ड दर्ज करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get or => 'या';

  @override
  String get loginSuccessful => 'लॉगिन सफल';

  @override
  String get loginError => 'लॉगिन त्रुटि कृपया पुनः प्रयास करें';

  @override
  String get loginWithGoogle => 'गूगल के साथ लॉगिन करें';
}
