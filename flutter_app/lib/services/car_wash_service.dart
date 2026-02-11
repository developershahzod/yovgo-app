import 'package:dio/dio.dart';
import '../models/car_wash.dart';
import 'api_service.dart';

class CarWashService {
  static Future<List<CarWash>> getNearbyCarWashes({
    double? latitude,
    double? longitude,
    int? limit,
  }) async {
    try {
      final response = await ApiService.get(
        '/api/mobile/car-washes/nearby',
        queryParameters: {
          'latitude': latitude ?? 41.2995,
          'longitude': longitude ?? 69.2401,
          if (limit != null) 'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['partners'] ?? response.data;
        return data.map((json) => CarWash.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<CarWash>> getPremiumCarWashes() async {
    try {
      final response = await ApiService.get('/api/mobile/car-washes/premium');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['partners'] ?? response.data;
        return data.map((json) => CarWash.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<CarWash?> getCarWashById(String id) async {
    try {
      final response = await ApiService.get('/api/mobile/car-washes/$id');

      if (response.statusCode == 200) {
        return CarWash.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<CarWash>> searchCarWashes(String query) async {
    try {
      final response = await ApiService.get(
        '/api/mobile/car-washes/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['partners'] ?? response.data;
        return data.map((json) => CarWash.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
