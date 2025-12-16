class Plan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final int? visitLimit;
  final bool isUnlimited;
  final bool isActive;
  
  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.durationDays,
    this.visitLimit,
    required this.isUnlimited,
    this.isActive = true,
  });
  
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? json['plan_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'UZS',
      durationDays: json['duration_days'] ?? 30,
      visitLimit: json['visit_limit'],
      isUnlimited: json['is_unlimited'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'duration_days': durationDays,
      'visit_limit': visitLimit,
      'is_unlimited': isUnlimited,
      'is_active': isActive,
    };
  }
  
  String get formattedPrice {
    return '${price.toStringAsFixed(0)} $currency';
  }
  
  String get visitsText {
    if (isUnlimited) return 'Безлимит';
    return '$visitLimit посещений';
  }
  
  String get durationText {
    if (durationDays == 30) return '30 дней';
    if (durationDays == 7) return '7 дней';
    return '$durationDays дней';
  }
}
