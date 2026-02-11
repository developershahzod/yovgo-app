import '../models/subscription_plan.dart';
import '../models/user_subscription.dart';
import 'api_service.dart';

class SubscriptionApiService {
  static Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final response = await ApiService.get('/api/mobile/subscriptions/plans');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['plans'] ?? response.data;
        return data.map((json) => SubscriptionPlan.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<UserSubscription?> getActiveSubscription() async {
    try {
      final response = await ApiService.get('/api/mobile/subscriptions/active');

      if (response.statusCode == 200 && response.data['subscription'] != null) {
        return UserSubscription.fromJson(response.data['subscription']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<UserSubscription>> getUserSubscriptions() async {
    try {
      final response = await ApiService.get('/api/mobile/subscriptions/my');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['subscriptions'] ?? response.data;
        return data.map((json) => UserSubscription.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createSubscription(String planId) async {
    try {
      final response = await ApiService.post(
        '/api/mobile/subscriptions/create',
        data: {'plan_id': int.parse(planId)},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final response = await ApiService.post(
        '/api/mobile/subscriptions/$subscriptionId/cancel',
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
