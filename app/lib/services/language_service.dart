import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageService {
  final _storage = const FlutterSecureStorage();
  static const _keyLanguageCode = 'language_code';

  Future<void> setLanguageCode(String languageCode) async {
    await _storage.write(key: _keyLanguageCode, value: languageCode);
  }

  Future<String?> getLanguageCode() async {
    return await _storage.read(key: _keyLanguageCode);
  }

  // This will be used to clear the language when the app is fully terminated
  Future<void> clearLanguageCode() async {
    await _storage.delete(key: _keyLanguageCode);
  }
}