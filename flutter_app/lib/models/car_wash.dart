class CarWash {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String status;
  final List<String> images;
  final List<String> amenities;
  final String phoneNumber;
  final String openingHours;
  final bool isPremium;
  final bool is24Hours;

  CarWash({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.status,
    required this.images,
    required this.amenities,
    required this.phoneNumber,
    required this.openingHours,
    required this.isPremium,
    required this.is24Hours,
  });

  factory CarWash.fromJson(Map<String, dynamic> json) {
    return CarWash(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      isOpen: json['is_open'] ?? false,
      status: json['status'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      phoneNumber: json['phone_number'] ?? '',
      openingHours: json['opening_hours'] ?? '',
      isPremium: json['is_premium'] ?? false,
      is24Hours: json['is_24_hours'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'rating': rating,
      'review_count': reviewCount,
      'is_open': isOpen,
      'status': status,
      'images': images,
      'amenities': amenities,
      'phone_number': phoneNumber,
      'opening_hours': openingHours,
      'is_premium': isPremium,
      'is_24_hours': is24Hours,
    };
  }
}
