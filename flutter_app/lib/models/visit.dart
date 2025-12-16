class Visit {
  final String id;
  final String userId;
  final String partnerId;
  final String? subscriptionId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String status;
  final String? partnerName;
  final String? partnerAddress;
  
  Visit({
    required this.id,
    required this.userId,
    required this.partnerId,
    this.subscriptionId,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.partnerName,
    this.partnerAddress,
  });
  
  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] ?? json['visit_id'] ?? '',
      userId: json['user_id'] ?? '',
      partnerId: json['partner_id'] ?? '',
      subscriptionId: json['subscription_id'],
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'])
          : DateTime.now(),
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'])
          : null,
      status: json['status'] ?? 'completed',
      partnerName: json['partner_name'],
      partnerAddress: json['partner_address'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'partner_id': partnerId,
      'subscription_id': subscriptionId,
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'status': status,
      'partner_name': partnerName,
      'partner_address': partnerAddress,
    };
  }
  
  String get formattedCheckInTime {
    return '${checkInTime.day} ${_getMonthName(checkInTime.month)} ${checkInTime.year}, ${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}';
  }
  
  String _getMonthName(int month) {
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return months[month - 1];
  }
  
  Duration? get duration {
    if (checkOutTime == null) return null;
    return checkOutTime!.difference(checkInTime);
  }
}
