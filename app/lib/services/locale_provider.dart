import 'package:flutter/material.dart';
import 'package:app/services/language_service.dart'; // We will create this next

class LocaleProvider with ChangeNotifier {
  final LanguageService _languageService = LanguageService();
  Locale? _locale;

  Locale? get locale => _locale;

  // Called once when the app starts
  Future<void> initializeLocale() async {
    // Get the stored language, which should be the device's language
    final languageCode = await _languageService.getLanguageCode();
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
    // No need to notify listeners here, as this happens before the UI is built
  }

  // Called from the settings screen
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await _languageService.setLanguageCode(newLocale.languageCode);
    notifyListeners(); // Update the UI
  }
}