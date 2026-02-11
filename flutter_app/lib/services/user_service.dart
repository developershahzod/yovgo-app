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
      return null;
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
      return null;
    }
  }
}
