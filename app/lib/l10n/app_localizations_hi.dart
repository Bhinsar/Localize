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
  String get passwordMustBeAtLeast6Chars =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

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

  @override
  String get register => 'रजिस्टर करें';

  @override
  String get dontHaveAccount => 'क्या आपके पास खाता नहीं है?';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get pleaseEnterFullName => 'कृपया अपना पूरा नाम दर्ज करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get pleaseEnterConfirmPassword =>
      'कृपया अपना पुष्टि पासवर्ड दर्ज करें';

  @override
  String get confirmPassword => 'पुष्टि पासवर्ड';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get userAlreadyExists => 'उपयोगकर्ता पहले से मौजूद है';

  @override
  String get registrationError => 'पंजीकरण त्रुटि कृपया पुनः प्रयास करें';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get pleaseEnterPhoneNumber => 'कृपया अपना फोन नंबर दर्ज करें';

  @override
  String get role => 'भूमिका';

  @override
  String get pleaseEnterValidNumber => 'कृपया एक मान्य संख्या दर्ज करें';

  @override
  String get client => 'क्लाइंट';

  @override
  String get provider => 'प्रदाता';

  @override
  String get somethingWentWrongPlease =>
      'कुछ गलत हो गया कृपया पुनः प्रयास करें';

  @override
  String get submit => 'जमा करें';
}
