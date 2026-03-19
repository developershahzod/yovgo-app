import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://app.yuvgo.uz',  // Production Gateway URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => true,
    ),
  );

  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _legacyStorage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _prefTokenKey = 'pref_auth_token';

  // Initialize interceptors
  static void initialize() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('📤 ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 ${response.statusCode} ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
          print('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // Token management
  static Future<void> saveToken(String token) async {
    try { await _storage.write(key: _tokenKey, value: token); } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefTokenKey, token);
    } catch (_) {}
  }

  static Future<String?> getToken() async {
    // 1. New secure storage
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) return token;
    } catch (_) {}
    // 2. SharedPreferences backup
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_prefTokenKey);
      if (token != null && token.isNotEmpty) {
        try { await _storage.write(key: _tokenKey, value: token); } catch (_) {}
        return token;
      }
    } catch (_) {}
    // 3. Legacy secure storage (old installs)
    try {
      final token = await _legacyStorage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        try { await _storage.write(key: _tokenKey, value: token); } catch (_) {}
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_prefTokenKey, token);
        } catch (_) {}
        return token;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> deleteToken() async {
    try { await _storage.delete(key: _tokenKey); } catch (_) {}
    try { await _legacyStorage.delete(key: _tokenKey); } catch (_) {}
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefTokenKey);
    } catch (_) {}
  }

  // Generic HTTP methods
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
}
