class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final int visitLimit;
  final List<String> features;
  final bool isPopular;
  final double? discount;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.visitLimit,
    required this.features,
    this.isPopular = false,
    this.discount,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      durationDays: json['duration_days'] ?? 0,
      visitLimit: json['visit_limit'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      isPopular: json['is_popular'] ?? false,
      discount: json['discount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'visit_limit': visitLimit,
      'features': features,
      'is_popular': isPopular,
      'discount': discount,
    };
  }

  String get durationText {
    if (durationDays >= 365) {
      return '${(durationDays / 365).round()} yil';
    } else if (durationDays >= 30) {
      return '${(durationDays / 30).round()} oy';
    } else {
      return '$durationDays kun';
    }
  }
}
