import 'package:app/api/dio_client.dart';
import 'package:dio/dio.dart';

class ServiceApi {
  final Dio _dio = DioClient().dio;
  
  Future<Map<String, dynamic>> fetchServices() async {
    try {
      final response = await _dio.get('/get/services');
      if (response.statusCode == 200) {
        return response.data;
      }
      return {'error': 'Failed to fetch services'};
    } catch (e) {
      print('Error fetching services: $e');
      return {'error': 'Failed to fetch services'};
    }
  }

}
