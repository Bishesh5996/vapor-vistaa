import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signup(UserEntity user);
  Future<UserEntity?> login(String username, String password);
} 