class User {
  final String id;
  final String phoneNumber;
  final String? email;
  final String? fullName;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.fullName,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['user_id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      fullName: json['full_name'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'email': email,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
