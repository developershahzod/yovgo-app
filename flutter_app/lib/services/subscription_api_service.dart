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
      print('Error fetching plans: $e');
      return _getMockPlans();
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
      print('Error fetching active subscription: $e');
      return _getMockSubscription();
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
      print('Error fetching subscriptions: $e');
      final mockSub = _getMockSubscription();
      return mockSub != null ? [mockSub] : [];
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
      print('Error creating subscription: $e');
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
      print('Error canceling subscription: $e');
      return false;
    }
  }

  // Mock data
  static List<SubscriptionPlan> _getMockPlans() {
    return [
      SubscriptionPlan(
        id: '1',
        name: '30 kunlik',
        description: 'Oylik obuna rejasi',
        price: 365000,
        durationDays: 30,
        visitLimit: 10,
        features: [
          '10 ta tashrif',
          'Barcha hamkor avtomoykalar',
          '24/7 qo\'llab-quvvatlash',
          'Chegirmalar va bonuslar',
        ],
        isPopular: false,
      ),
      SubscriptionPlan(
        id: '2',
        name: '90 kunlik',
        description: '3 oylik obuna rejasi',
        price: 950000,
        durationDays: 90,
        visitLimit: 30,
        features: [
          '30 ta tashrif',
          'Barcha hamkor avtomoykalar',
          '24/7 qo\'llab-quvvatlash',
          'Chegirmalar va bonuslar',
        ],
        isPopular: true,
        discount: 15,
      ),
      SubscriptionPlan(
        id: '3',
        name: '365 kunlik',
        description: 'Yillik obuna rejasi',
        price: 3200000,
        durationDays: 365,
        visitLimit: 120,
        features: [
          '120 ta tashrif',
          'Barcha hamkor avtomoykalar',
          '24/7 qo\'llab-quvvatlash',
          'Chegirmalar va bonuslar',
          'Premium qo\'shimcha xizmatlar',
        ],
        isPopular: false,
        discount: 25,
      ),
    ];
  }

  static UserSubscription? _getMockSubscription() {
    return UserSubscription(
      id: '1',
      planId: '2',
      planName: '90 kunlik',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 75)),
      totalVisits: 30,
      usedVisits: 8,
      isActive: true,
      status: 'active',
    );
  }
}
