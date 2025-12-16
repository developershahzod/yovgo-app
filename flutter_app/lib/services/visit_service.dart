import 'package:dio/dio.dart';
import '../models/visit.dart';
import '../config/constants.dart';
import 'api_service.dart';

class VisitService {
  // Check in with QR code
  static Future<Map<String, dynamic>?> checkIn(String qrToken) async {
    try {
      final response = await ApiService.post(
        '/api/visit/user-checkin',
        data: {'qr_token': qrToken},
      );
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print('Error checking in: ${e.message}');
      throw Exception(e.response?.data['detail'] ?? 'Check-in failed');
    }
  }

  // Get user's visit history
  static Future<List<Visit>> getVisitHistory({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/api/visit/visits/my',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Visit.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching visit history: ${e.message}');
      return [];
    }
  }

  // Get visit by ID
  static Future<Visit?> getVisit(String visitId) async {
    try {
      final response = await ApiService.get('/api/visit/visits/$visitId');
      
      if (response.statusCode == 200) {
        return Visit.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Error fetching visit: ${e.message}');
      return null;
    }
  }

  // Get visit statistics
  static Future<Map<String, dynamic>?> getVisitStats() async {
    try {
      final response = await ApiService.get('/api/visit/visits/stats');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print('Error fetching visit stats: ${e.message}');
      return null;
    }
  }
}
