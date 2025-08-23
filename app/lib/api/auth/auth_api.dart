import 'package:app/api/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  final Dio _dio = DioClient().dio;
  final _storage = FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        _storage.write(key: 'token', value: response.data['token']);
        _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        await _storage.write(
          key: 'existNumber',
          value: response.data['existNumber'].toString(),
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
        '/register',
        data: {'email': email, 'password': password, 'full_name': fullName},
      );
      return response.data;
    } on DioException catch (e) { 
      if (e.response != null) {

        if (e.response?.statusCode == 400) {
          return {'error': e.response?.data['message'] ?? 'User already registered or bad data'};
        }
      }
      print('Registration error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      // 2. The .signIn() method is now correct because the object was created properly.
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();

      if (googleUser == null) {
        print('Google sign-in canceled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception(
          'Failed to get Google ID token. Ensure your SHA-1 and package name are correct in Firebase/Google Cloud.',
        );
      }

      final response = await _dio.post('/google', data: {'id_token': idToken});

      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: response.data['token']);
        await _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        await _storage.write(
          key: 'existNumber',
          value: response.data['existNumber'].toString(),
        );
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

  Future<Map<String, String>?> addNumberAndRole(String userId, String number, String role) async {
    try {
      final response = await _dio.post(
        '/addNumberAndRole',
        data: {'userId': userId, 'number': number, 'role': role},
      );
      if (response.statusCode == 200) {
        _storage.write(key: 'token', value: response.data['token']);
        _storage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );
        return response.data;
      } else {
        throw Exception('Failed to add number and role');
      }
    } catch (e) {
      print('Add number and role error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refresh_token');
  }
}
