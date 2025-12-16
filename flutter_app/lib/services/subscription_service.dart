import 'package:dio/dio.dart';
import '../models/subscription.dart';
import '../models/plan.dart';
import '../config/constants.dart';
import 'api_service.dart';

class SubscriptionService {
  // Get all available plans
  static Future<List<Plan>> getPlans() async {
    try {
      final response = await ApiService.get('/api/subscription/plans');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Plan.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching plans: ${e.message}');
      return [];
    }
  }

  // Get user's active subscriptions
  static Future<List<Subscription>> getUserSubscriptions() async {
    try {
      final response = await ApiService.get('/api/subscription/subscriptions/my');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Subscription.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching subscriptions: ${e.message}');
      return [];
    }
  }

  // Get subscription status
  static Future<Map<String, dynamic>?> getSubscriptionStatus() async {
    try {
      final response = await ApiService.get('/api/subscription/subscriptions/status');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print('Error fetching subscription status: ${e.message}');
      return null;
    }
  }

  // Create new subscription
  static Future<Subscription?> createSubscription(String planId) async {
    try {
      final response = await ApiService.post(
        '/api/subscription/subscriptions',
        data: {'plan_id': planId},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Subscription.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Error creating subscription: ${e.message}');
      throw Exception(e.response?.data['detail'] ?? 'Failed to create subscription');
    }
  }

  // Cancel subscription
  static Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final response = await ApiService.delete(
        '/api/subscription/subscriptions/$subscriptionId',
      );
      
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error canceling subscription: ${e.message}');
      return false;
    }
  }
}
