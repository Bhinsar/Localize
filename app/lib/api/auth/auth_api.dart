import 'package:app/api/root_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  final Dio _dio = Dio();
  final _storage = FlutterSecureStorage();
  final String _baseUrl = RootUrl.url;      
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        _storage.write(key: 'token', value: response.data['token']);
        _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        return response.data;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/register',
        data: {'email': email, 'password': password, 'full_name': fullName},
      );
      if (response.statusCode == 200) {
        _storage.write(key: 'token', value: response.data['token']);
        _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        return response.data;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      // 2. The .signIn() method is now correct because the object was created properly.
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        print('Google sign-in canceled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get Google ID token. Ensure your SHA-1 and package name are correct in Firebase/Google Cloud.');
      }

      final response = await _dio.post(
        '$_baseUrl/google',
        data: {'id_token': idToken},
      );

      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: response.data['token']);
        await _storage.write(key: 'refresh_token', value: response.data['refreshToken']);
        return response.data;
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      print('Google sign-in error: $e');
      await _googleSignIn.signOut();
      return null;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refresh_token');
  }
}
