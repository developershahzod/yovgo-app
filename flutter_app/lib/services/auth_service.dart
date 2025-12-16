import 'package:dio/dio.dart';
import '../models/user.dart';
import '../config/constants.dart';
import 'api_service.dart';

class AuthService {
  // Register new user
  static Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.register,
        data: {
          'phone_number': phoneNumber,
          'email': email,
          'full_name': fullName,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['access_token'] != null) {
          await ApiService.saveToken(data['access_token']);
        }
        return data;
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['detail'] ?? 'Registration failed');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.login,
        data: {
          'phone_number': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['access_token'] != null) {
          await ApiService.saveToken(data['access_token']);
        }
        return data;
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['detail'] ?? 'Login failed');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) return null;

      final response = await ApiService.get('/api/user/me');
      
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    await ApiService.deleteToken();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }
}
