import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> authenticateUser(String username, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String usersBoxName = 'usersBox';

  @override
  Future<void> registerUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(usersBoxName);
    if (box.values.any((u) => u.username == user.username || u.email == user.email)) {
      throw Exception('User already exists');
    }
    await box.add(user);
  }

  @override
  Future<UserModel?> authenticateUser(String username, String password) async {
    final box = await Hive.openBox<UserModel>(usersBoxName);
    try {
      return box.values.firstWhere((u) => u.username == username && u.password == password);
    } catch (_) {
      return null;
    }
  }
} 