class ApiConfig {
  // Base URL - Change this to your backend URL
  static const String baseUrl = 'http://localhost:8000';
  
  // API Endpoints
  static const String auth = '/api/auth';
  static const String users = '/api/users';
  static const String partners = '/api/partners';
  static const String subscriptions = '/api/subscriptions';
  static const String visits = '/api/visits';
  static const String payments = '/api/payments';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
