import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Comprehensive API Service for YuvGO Flutter App
/// Handles all API calls to backend microservices through the gateway
class FullApiService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
  // For real device, use your computer's IP address
  static const String _baseUrl = 'https://app.yuvgo.uz';
  
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  // Initialize interceptors
  static void initialize() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
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

  // ==================== TOKEN MANAGEMENT ====================
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== USER SERVICE ====================
  
  /// Send SMS verification code to phone number
  static Future<Map<String, dynamic>> sendCode(String phoneNumber) async {
    try {
      final response = await _dio.post('/api/user/auth/send-code', data: {
        'phone_number': phoneNumber,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify SMS code and login/register
  /// If user exists — logs in. If not — auto-registers.
  static Future<Map<String, dynamic>> verifyCode({
    required String phoneNumber,
    required String code,
    String? fullName,
  }) async {
    try {
      final response = await _dio.post('/api/user/auth/verify-code', data: {
        'phone_number': phoneNumber,
        'code': code,
        if (fullName != null) 'full_name': fullName,
      });
      if (response.data['access_token'] != null) {
        await saveToken(response.data['access_token']);
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Login with phone number (legacy, kept for compatibility)
  static Future<Map<String, dynamic>> login(String phoneNumber) async {
    try {
      final response = await _dio.post('/api/user/auth/login', data: {
        'phone_number': phoneNumber,
      });
      
      if (response.data['access_token'] != null) {
        await saveToken(response.data['access_token']);
      }
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user (legacy, kept for compatibility)
  static Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String fullName,
    String? email,
  }) async {
    try {
      final response = await _dio.post('/api/user/auth/register', data: {
        'phone_number': phoneNumber,
        'full_name': fullName,
        'email': email,
      });
      if (response.data['access_token'] != null) {
        await saveToken(response.data['access_token']);
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/api/user/users/$userId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
    String userId, {
    String? fullName,
    String? email,
  }) async {
    try {
      final response = await _dio.put('/api/user/users/$userId', data: {
        if (fullName != null) 'full_name': fullName,
        if (email != null) 'email': email,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  static Future<void> logout() async {
    await deleteToken();
    await _storage.delete(key: _userKey);
  }

  // ==================== VEHICLE SERVICE ====================

  /// Get user's vehicles
  static Future<List<dynamic>> getVehicles() async {
    try {
      final response = await _dio.get('/api/user/vehicles');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Add new vehicle
  static Future<Map<String, dynamic>> addVehicle({
    required String plateNumber,
    required String brand,
    required String model,
    String? color,
    int? year,
  }) async {
    try {
      final response = await _dio.post('/api/user/vehicles', data: {
        'plate_number': plateNumber,
        'brand': brand,
        'model': model,
        'color': color,
        'year': year,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete vehicle
  static Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _dio.delete('/api/user/vehicles/$vehicleId');
    } catch (e) {
      rethrow;
    }
  }

  // ==================== SUBSCRIPTION SERVICE ====================

  /// Get all subscription plans
  static Future<List<dynamic>> getSubscriptionPlans() async {
    try {
      final response = await _dio.get('/api/mobile/subscriptions/plans');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get subscription plan by ID
  static Future<Map<String, dynamic>> getSubscriptionPlan(String planId) async {
    try {
      final response = await _dio.get('/api/mobile/subscriptions/plans/$planId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current subscription status
  static Future<Map<String, dynamic>> getSubscriptionStatus() async {
    try {
      final response = await _dio.get('/api/mobile/subscriptions/active');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Create new subscription
  static Future<Map<String, dynamic>> createSubscription({
    required String planId,
    bool autoRenew = false,
  }) async {
    try {
      final response = await _dio.post('/api/mobile/subscriptions/create', data: {
        'plan_id': planId,
        'auto_renew': autoRenew,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel subscription
  static Future<void> cancelSubscription(String subscriptionId) async {
    try {
      await _dio.post('/api/mobile/subscriptions/$subscriptionId/cancel');
    } catch (e) {
      rethrow;
    }
  }

  // ==================== PARTNER SERVICE ====================

  /// Get all partners (car washes)
  static Future<List<dynamic>> getPartners({String? status}) async {
    try {
      final response = await _dio.get('/api/partner/partners', queryParameters: {
        if (status != null) 'status': status,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get partner by ID
  static Future<Map<String, dynamic>> getPartner(String partnerId) async {
    try {
      final response = await _dio.get('/api/partner/partners/$partnerId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get partner locations
  static Future<List<dynamic>> getPartnerLocations({
    String? partnerId,
    String? city,
  }) async {
    try {
      final response = await _dio.get('/api/partner/locations', queryParameters: {
        if (partnerId != null) 'partner_id': partnerId,
        if (city != null) 'city': city,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== VISIT SERVICE ====================

  /// Record a visit (QR scan)
  static Future<Map<String, dynamic>> recordVisit({
    required String qrToken,
    required String vehicleId,
  }) async {
    try {
      final response = await _dio.post('/api/visit/visits', data: {
        'qr_token': qrToken,
        'vehicle_id': vehicleId,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user's visit history
  static Future<List<dynamic>> getVisitHistory({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/api/mobile/visits/history', queryParameters: {
        'limit': limit,
      });
      return (response.data['visits'] as List?) ?? [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get visit statistics
  static Future<Map<String, dynamic>> getVisitStats() async {
    try {
      final response = await _dio.get('/api/visit/visits/stats');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== NOTIFICATION SERVICE ====================

  /// Get user notifications
  static Future<List<dynamic>> getNotifications({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/api/notification/notifications', queryParameters: {
        'skip': skip,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      // Return empty list if service unavailable
      return [];
    }
  }

  /// Mark notification as read
  static Future<void> markNotificationRead(String notificationId) async {
    try {
      await _dio.put('/api/notification/notifications/$notificationId/read');
    } catch (e) {
      rethrow;
    }
  }

  /// Mark all notifications as read
  static Future<void> markAllNotificationsRead() async {
    try {
      await _dio.put('/api/notification/notifications/read-all');
    } catch (e) {
      rethrow;
    }
  }

  // ==================== PAYMENT SERVICE (IPAKYULIBANK) ====================

  /// Create payment via mobile API gateway (recommended)
  /// Handles IpakYuli integration server-side
  static Future<Map<String, dynamic>> createMobilePayment({
    required String subscriptionId,
    String? planId,
    double? amount,
  }) async {
    try {
      final response = await _dio.post('/api/mobile/payments/create', data: {
        'subscription_id': subscriptionId,
        if (planId != null) 'plan_id': planId,
        if (amount != null) 'amount': amount,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // IpakYuli Production constants (staging is broken - SSL errors, unreachable from server)
  static const _ipakYuliUrl = 'https://ecom.ipakyulibank.uz/api/transfer';
  static const _ipakYuliToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiIxODhjYWQyMS0zMGQwLTQyZDktODUxOC05ODFhYWNiNTVkOTUiLCJtZXJjaGFudElkIjoiYTBlZmUyNzgtNWUyZi00YzQ5LWIzZmItN2NlMjllOWM4ZmVkIiwiaWF0IjoxNzQ4ODYyNDI1LCJleHAiOjE3ODA0MjAwMjV9.JmfSQb_5Ei6fPLxTCCbQY6ECprq76NMJMnwT3CPFxP4';

  /// Call IpakYuli Production API directly from Flutter app
  static Future<Map<String, dynamic>> createIpakYuliPaymentDirect({
    required String orderId,
    required int amount,
    required String paymentId,
  }) async {

    final ipakDio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    final payload = {
      'jsonrpc': '2.0',
      'id': orderId,
      'method': 'transfer.create_token',
      'params': {
        'order_id': orderId,
        'amount': amount,
        'details': {
          'description': 'YuvGO obuna to\'lovi',
          'ofdInfo': {
            'Items': [
              {
                'Name': 'YuvGO Subscription',
                'SPIC': '03304999067000000',
                'PackageCode': '1344094',
                'price': amount,
                'count': 1,
                'VATPercent': 0,
                'Discount': 0,
              }
            ]
          },
        },
        'success_url': 'https://app.yuvgo.uz/api/mobile/payments/success?payment_id=$paymentId',
        'fail_url': 'https://app.yuvgo.uz/#/main',
      },
    };

    try {
      final response = await ipakDio.post(
        _ipakYuliUrl,
        data: payload,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_ipakYuliToken',
        }),
      );
      final data = response.data;
      print('[IpakYuli create] response: $data');
      if (data['error'] != null) {
        throw Exception(data['error']['message'] ?? 'IpakYuli xatolik');
      }
      final result = data['result'] ?? {};

      // Save transfer_id to backend
      try {
        final transferId = result['transfer_id']?.toString();
        if (transferId != null) {
          await _dio.post('/api/mobile/payments/update-transfer', data: {
            'payment_id': paymentId,
            'transfer_id': transferId,
          });
        }
      } catch (_) {}

      return {
        'payment_url': result['payment_url'],
        'transfer_id': result['transfer_id'],
      };
    } catch (e) {
      print('IpakYuli direct call error: $e');
      rethrow;
    }
  }

  /// Get payment status from IpakYuliBank — direct call from Flutter
  static Future<Map<String, dynamic>> getPaymentStatus(String transferId) async {
    try {
      final response = await _dio.get('/api/mobile/payments/status/$transferId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Check IpakYuli transfer status directly from Flutter
  /// and activate subscription via backend if payment succeeded
  static Future<String> checkIpakYuliPaymentDirect({
    required String transferId,
    required String paymentId,
  }) async {

    final ipakDio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    try {
      final payload = {
        'jsonrpc': '2.0',
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'method': 'transfer.get',
        'params': {'id': transferId},
      };
      final response = await ipakDio.post(
        _ipakYuliUrl,
        data: payload,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_ipakYuliToken',
        }),
      );
      final data = response.data;
      final result = data['result'] ?? {};
      final status = (result['status'] ?? '').toString().toLowerCase();
      print('[IpakYuli status check] transfer $transferId: $status');

      // If payment succeeded, tell backend to activate subscription
      if (status == 'success') {
        try {
          await _dio.get('/api/mobile/payments/success', queryParameters: {
            'payment_id': paymentId,
          });
        } catch (_) {}
      }
      return status;
    } catch (e) {
      print('[IpakYuli status check error] $e');
      return 'unknown';
    }
  }

  /// Cancel a pending payment
  static Future<Map<String, dynamic>> cancelPayment(String transferId, {String? reason}) async {
    try {
      final response = await _dio.post(
        '/api/payment/ipakyuli/cancel/$transferId',
        queryParameters: reason != null ? {'reason': reason} : null,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Create tokenization contract for recurring payments
  /// User will be redirected to enter card details for auto-renewal
  static Future<Map<String, dynamic>> createTokenizationContract({
    String? successUrl,
    String? failUrl,
  }) async {
    try {
      final response = await _dio.post('/api/payment/ipakyuli/tokenize', data: {
        if (successUrl != null) 'success_url': successUrl,
        if (failUrl != null) 'fail_url': failUrl,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Pay using tokenized card (for auto-renewal)
  static Future<Map<String, dynamic>> payWithToken({
    required String contractId,
    required String subscriptionId,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        '/api/payment/ipakyuli/pay-with-token',
        queryParameters: {
          'contract_id': contractId,
          'subscription_id': subscriptionId,
          'amount': amount,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get user's saved cards (tokenization contracts)
  static Future<Map<String, dynamic>> getSavedCards() async {
    try {
      final response = await _dio.get('/api/payment/ipakyuli/contracts');
      return response.data;
    } catch (e) {
      return {'contracts': []};
    }
  }

  /// Delete a saved card
  static Future<void> deleteSavedCard(String contractId) async {
    try {
      await _dio.delete('/api/payment/ipakyuli/contracts/$contractId');
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment history
  static Future<List<dynamic>> getPaymentHistory({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/api/payment/history', queryParameters: {
        'skip': skip,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      return [];
    }
  }

  // ==================== QR CODE SERVICE ====================

  /// Validate QR code
  static Future<Map<String, dynamic>> validateQrCode(String qrToken) async {
    try {
      final response = await _dio.post('/api/visit/qr/validate', data: {
        'qr_token': qrToken,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Process QR scan for car wash visit
  static Future<Map<String, dynamic>> processQrScan({
    required String qrToken,
    String? vehicleId,
  }) async {
    try {
      final response = await _dio.post('/api/mobile/visits/checkin', data: {
        'qr_token': qrToken,
        if (vehicleId != null) 'vehicle_id': vehicleId,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== WEATHER SERVICE ====================

  /// Get weather data for car wash recommendation
  static Future<Map<String, dynamic>> getWeatherData({
    double? latitude,
    double? longitude,
    String lang = 'uz',
  }) async {
    try {
      final response = await _dio.get('/api/mobile/weather', queryParameters: {
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'lang': lang,
      });
      return response.data;
    } catch (e) {
      return {
        'success': false,
        'wash_rating': 0,
        'recommendation': '',
        'current': {},
        'forecast': [],
      };
    }
  }

  // ==================== SAVED LOCATIONS ====================

  /// Get saved car washes
  static Future<List<dynamic>> getSavedCarWashes() async {
    try {
      final response = await _dio.get('/api/user/saved');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  /// Save car wash
  static Future<void> saveCarWash(String partnerId) async {
    try {
      await _dio.post('/api/user/saved', data: {
        'partner_id': partnerId,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Remove saved car wash
  static Future<void> removeSavedCarWash(String partnerId) async {
    try {
      await _dio.delete('/api/user/saved/$partnerId');
    } catch (e) {
      rethrow;
    }
  }

  // ==================== HELPER METHODS ====================

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }
}
