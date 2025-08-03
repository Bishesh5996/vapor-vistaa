import 'dart:io';

class ApiEndpoints {
  /// Returns the correct base URL depending on environment.
  ///
  /// - If you run with --dart-define=API_BASE_URL=... it will use that.
  /// - Otherwise, uses 10.0.2.2 for Android emulator, your local IP for iOS device,
  ///   or localhost for other platforms.
  static String get baseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) return envBaseUrl;

    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host machine
      return 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      // Real iOS device uses your Mac's LAN IP address
      return 'http://192.168.1.68:3000/api'; // <-- Replace with your Mac's actual LAN IP if different
    }
    // Fallback to localhost (e.g., when running on macOS desktop)
    return 'http://localhost:3000/api';
  }

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getCustomer = '/customers/';
  static const String updateCustomer = '/customers/update/';
  static const String uploadImage = '/customers/uploadImage';

  // Package/Trip endpoints (will become products)
  static const String packages = '/products';
  static const String packageById = '/products/';

  // Booking endpoints (will become orders)
  static const String bookings = '/orders';
  static const String createBooking = '/orders';
  static const String getBookings = '/orders';

  // Wishlist endpoints
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist';
  static const String removeFromWishlist = '/wishlist/';

  // Payment endpoints
  static const String khaltiPayment = '/api/khalti/payment';
}