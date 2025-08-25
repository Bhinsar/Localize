import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/api/root_url.dart';

class DioClient {
  final Dio _dio = Dio();
  final _storage = FlutterSecureStorage();
  static final String _baseUrl = RootUrl.url;

  DioClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the current context from the global key
          final languageCode = await _storage.read(key: 'language_code');
          options.headers['language'] = languageCode ?? 'en';

          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            print("Token expired, attempting to refresh...");
            String? newAccessToken = await _refreshToken();

            if (newAccessToken != null) {
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              print("Token refreshed. Retrying the original request...");
              return handler.resolve(await _dio.fetch(error.requestOptions));
            } else {
              print("Failed to refresh token. Logging out.");
              await _storage.deleteAll();
            }          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    try {
      // Important: Create a new Dio instance for the refresh token call
      // to avoid an infinite loop if the refresh token itself is expired.
      final refreshTokenDio = Dio();
      refreshTokenDio.options.baseUrl = _baseUrl;

      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return null;

      final response = await refreshTokenDio.post(
        '/refreshToken', // Use your actual refresh endpoint
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];
        await _storage.write(key: 'token', value: newAccessToken);
        await _storage.write(key: 'refresh_token', value: newRefreshToken);
        return newAccessToken;
      }
      return null;
    } catch (e) {
      await _storage.deleteAll();
      return null;
    }
  }

  Dio get dio => _dio;
}
