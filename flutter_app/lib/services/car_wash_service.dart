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
      print('Error fetching nearby car washes: $e');
      return _getMockCarWashes();
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
      print('Error fetching premium car washes: $e');
      return _getMockCarWashes().where((cw) => cw.isPremium).toList();
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
      print('Error fetching car wash: $e');
      return _getMockCarWashes().first;
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
      print('Error searching car washes: $e');
      return _getMockCarWashes()
          .where((cw) => cw.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Mock data for development/testing
  static List<CarWash> _getMockCarWashes() {
    return [
      CarWash(
        id: '1',
        name: 'Black Star Car Wash',
        address: 'Motouruchilar Street 32, Toshkent',
        latitude: 41.2995,
        longitude: 69.2401,
        distance: 0.5,
        rating: 4.6,
        reviewCount: 128,
        isOpen: true,
        status: '22:00 GACHA OCHIQ',
        images: [],
        amenities: ['Kutish zali', 'Ko\'ngilochar o\'yinlar', 'Do\'kon'],
        phoneNumber: '+998 93 956 6961',
        openingHours: '08:00 - 22:00',
        isPremium: true,
        is24Hours: false,
      ),
      CarWash(
        id: '2',
        name: 'Wash N Go Car Wash',
        address: 'Tutzor mahallasi, 35 uy, Choshtepa',
        latitude: 41.3111,
        longitude: 69.2797,
        distance: 0.9,
        rating: 4.8,
        reviewCount: 256,
        isOpen: false,
        status: 'YOPIQ 8:00 GACHA',
        images: [],
        amenities: ['Kutish zali', 'WiFi'],
        phoneNumber: '+998 90 123 4567',
        openingHours: '08:00 - 20:00',
        isPremium: true,
        is24Hours: false,
      ),
      CarWash(
        id: '3',
        name: 'DJ Car Wash',
        address: 'Chimrobod ko\'chasi 28, Toshkent',
        latitude: 41.3264,
        longitude: 69.2887,
        distance: 1.2,
        rating: 4.5,
        reviewCount: 89,
        isOpen: true,
        status: 'OCHIQ',
        images: [],
        amenities: ['Kutish zali'],
        phoneNumber: '+998 91 234 5678',
        openingHours: '24/7',
        isPremium: false,
        is24Hours: true,
      ),
    ];
  }
}
