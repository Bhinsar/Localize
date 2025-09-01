import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterValidPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid password'**
  String get pleaseEnterValidPassword;

  /// No description provided for @passwordMustBeAtLeast6Chars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Chars;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get loginError;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @pleaseEnterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your confirm password'**
  String get pleaseEnterConfirmPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'User already exists'**
  String get userAlreadyExists;

  /// No description provided for @registrationError.
  ///
  /// In en, this message translates to:
  /// **'Registration error please try again'**
  String get registrationError;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @somethingWentWrongPlease.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong please try again'**
  String get somethingWentWrongPlease;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @phoneNumberAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Phone number is already in use by another user'**
  String get phoneNumberAlreadyInUse;

  /// No description provided for @whatservicedoyouprovide.
  ///
  /// In en, this message translates to:
  /// **'What service do you provide?'**
  String get whatservicedoyouprovide;

  /// No description provided for @selectThePrimaryServiceYouWantToOfferToCustomers.
  ///
  /// In en, this message translates to:
  /// **'Select the primary service you want to offer to customers'**
  String get selectThePrimaryServiceYouWantToOfferToCustomers;

  /// No description provided for @pleaseEnterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter service name'**
  String get pleaseEnterServiceName;

  /// No description provided for @pleaseSelectAService.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get pleaseSelectAService;

  /// No description provided for @formSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Form submitted successfully'**
  String get formSubmitted;

  /// No description provided for @pleaseCompleteTheForm.
  ///
  /// In en, this message translates to:
  /// **'Please complete the form'**
  String get pleaseCompleteTheForm;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @thisfieldcannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get thisfieldcannotbeempty;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get enterPrice;

  /// No description provided for @perLiter.
  ///
  /// In en, this message translates to:
  /// **'per Liter'**
  String get perLiter;

  /// No description provided for @permonth.
  ///
  /// In en, this message translates to:
  /// **'per Month'**
  String get permonth;

  /// No description provided for @perHours.
  ///
  /// In en, this message translates to:
  /// **'per Hours'**
  String get perHours;

  /// No description provided for @setYourPrice.
  ///
  /// In en, this message translates to:
  /// **'Set your price'**
  String get setYourPrice;

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get pleaseEnterValidPrice;

  /// No description provided for @setYourAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set your availability'**
  String get setYourAvailability;

  /// No description provided for @selectDaysYouAreAvailable.
  ///
  /// In en, this message translates to:
  /// **'Select days you are available'**
  String get selectDaysYouAreAvailable;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @selectTimeSlotYouAreAvailable.
  ///
  /// In en, this message translates to:
  /// **'Select time slot you are available'**
  String get selectTimeSlotYouAreAvailable;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @choosethedaysandtimeswhenyoureavailabletoprovideservices.
  ///
  /// In en, this message translates to:
  /// **'Choose the days and times when you\'re available to provide services'**
  String get choosethedaysandtimeswhenyoureavailabletoprovideservices;

  /// No description provided for @pleaseSelectADay.
  ///
  /// In en, this message translates to:
  /// **'Please select a day'**
  String get pleaseSelectADay;

  /// No description provided for @pleaseSelectATime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectATime;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get chooseTime;

  /// No description provided for @endTimeMustBeAfterStartTime.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get endTimeMustBeAfterStartTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
