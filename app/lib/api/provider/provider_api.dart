import 'package:app/api/dio_client.dart';
import 'package:app/models/provider_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProviderApi {
  final Dio _dio = DioClient().dio;
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> registerProvider(ProviderDetails data) async {
    try {
      final response = await _dio.post(
        "/register/provider",
        data: data.toJson(),
      );
      if (response.statusCode == 201) {
        await _storage.write(key: 'bios', value: "true");
        return response.data;
      }
      throw Exception(response.data);
    } on DioException catch (e) {
      print("provider resgistration error $e");
      return ({"error": "Error registration user"});
    }
  }
}
