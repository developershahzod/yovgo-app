import 'api_service.dart';

class UserService {
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await ApiService.get('/api/mobile/users/me');

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return _getMockUser();
    }
  }

  static Future<Map<String, dynamic>?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('/api/mobile/users/me', data: data);

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error updating profile: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getStats() async {
    try {
      final response = await ApiService.get('/api/mobile/users/stats');

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error fetching stats: $e');
      return _getMockStats();
    }
  }

  static Map<String, dynamic> _getMockUser() {
    return {
      'id': '1',
      'full_name': 'Shakhzod Ismoilov',
      'phone_number': '+998 93 956 6961',
      'email': 'user@yuvgo.uz',
      'avatar_url': null,
    };
  }

  static Map<String, dynamic> _getMockStats() {
    return {
      'total_car_washes': 0,
      'total_visits': 8,
      'total_savings': 0,
      'active_subscription': true,
    };
  }
}
