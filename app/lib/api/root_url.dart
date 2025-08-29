class RootUrl {
  // Use this for development with the Android Emulator
  static const String _devUrl = "http://192.168.1.4:8080/api";

  // Use this for production
  static const String _prodUrl = "https://localize-swyt.onrender.com/api";

  // A flag to easily switch between environments
  static const bool _isProduction = bool.fromEnvironment('dart.vm.product');

  static String get url {
    return _isProduction ? _prodUrl : _devUrl;
  }
}