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
  String get passwordMustBeAtLeast6Chars =>
      'Password must be at least 6 characters';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get loginError => 'Invalid credentials';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get register => 'Register';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get fullName => 'Full Name';

  @override
  String get pleaseEnterConfirmPassword => 'Please enter your confirm password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get userAlreadyExists => 'User already exists';

  @override
  String get registrationError => 'Registration error please try again';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get role => 'Role';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get client => 'Client';

  @override
  String get provider => 'Provider';

  @override
  String get somethingWentWrongPlease =>
      'Something went wrong please try again';

  @override
  String get submit => 'Submit';
}
