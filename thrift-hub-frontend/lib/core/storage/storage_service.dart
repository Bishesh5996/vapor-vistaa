import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  Future<bool> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userIdKey, userId);
    } catch (e) {
      print('Error saving user ID: $e');
      return false;
    }
  }

  Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<bool> saveUserRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userRoleKey, role);
    } catch (e) {
      print('Error saving user role: $e');
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userRoleKey);
      return true;
    } catch (e) {
      print('Error clearing storage: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;
  }
}
