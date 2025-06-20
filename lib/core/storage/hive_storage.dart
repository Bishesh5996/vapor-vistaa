import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static final Box _box = Hive.box('authBox');

  static bool isLoggedIn() {
    return _box.get('isLoggedIn', defaultValue: false);
  }

  static void saveLogin(String username) {
    _box.put('isLoggedIn', true);
    _box.put('username', username);
  }

  static void logout() {
    _box.clear();
  }

  static String getUsername() {
    return _box.get('username', defaultValue: '');
  }
}
