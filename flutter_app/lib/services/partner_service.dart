import 'package:dio/dio.dart';
import '../config/constants.dart';
import 'api_service.dart';

class PartnerService {
  // Get all partners (car washes)
  static Future<List<Map<String, dynamic>>> getPartners({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await ApiService.get(
        '/api/partner/partners',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching partners: ${e.message}');
      return [];
    }
  }

  // Get partner by ID
  static Future<Map<String, dynamic>?> getPartner(String partnerId) async {
    try {
      final response = await ApiService.get('/api/partner/partners/$partnerId');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print('Error fetching partner: ${e.message}');
      return null;
    }
  }

  // Get nearby partners
  static Future<List<Map<String, dynamic>>> getNearbyPartners({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await ApiService.get(
        '/api/partner/partners/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius_km': radiusKm,
        },
      );
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching nearby partners: ${e.message}');
      return [];
    }
  }
}
