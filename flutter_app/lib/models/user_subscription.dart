class UserSubscription {
  final String id;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalVisits;
  final int usedVisits;
  final bool isActive;
  final String status;

  UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.totalVisits,
    required this.usedVisits,
    required this.isActive,
    required this.status,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id']?.toString() ?? '',
      planId: json['plan_id']?.toString() ?? '',
      planName: json['plan_name'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      totalVisits: json['total_visits'] ?? 0,
      usedVisits: json['used_visits'] ?? 0,
      isActive: json['is_active'] ?? false,
      status: json['status'] ?? '',
    );
  }

  int get remainingVisits => totalVisits - usedVisits;
  
  int get daysRemaining {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    return endDate.difference(now).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_name': planName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_visits': totalVisits,
      'used_visits': usedVisits,
      'is_active': isActive,
      'status': status,
    };
  }
}
