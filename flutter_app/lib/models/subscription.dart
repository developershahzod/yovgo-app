class Subscription {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int visitsRemaining;
  final bool isUnlimited;
  final String? planName;
  final double? planPrice;
  
  Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.visitsRemaining,
    required this.isUnlimited,
    this.planName,
    this.planPrice,
  });
  
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? json['subscription_id'] ?? '',
      userId: json['user_id'] ?? '',
      planId: json['plan_id'] ?? '',
      status: json['status'] ?? 'active',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now().add(const Duration(days: 30)),
      visitsRemaining: json['visits_remaining'] ?? 0,
      isUnlimited: json['is_unlimited'] ?? false,
      planName: json['plan_name'],
      planPrice: json['plan_price']?.toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_id': planId,
      'status': status,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'visits_remaining': visitsRemaining,
      'is_unlimited': isUnlimited,
      'plan_name': planName,
      'plan_price': planPrice,
    };
  }
  
  int get daysRemaining {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    return endDate.difference(now).inDays;
  }
  
  bool get isActive {
    return status == 'active' && DateTime.now().isBefore(endDate);
  }
  
  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }
}
