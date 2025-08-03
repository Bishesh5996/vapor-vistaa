class ApiConstants {
  static const String baseUrl = 'http://192.168.1.68:3000';
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String packagesEndpoint = '/api/package';
  static const String customersEndpoint = '/api/customers';
  static const String bookingsEndpoint = '/api/bookings';
  static const Duration connectionTimeout = Duration(seconds: 30);
}
