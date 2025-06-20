import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> signup(UserEntity user) async {
    await localDataSource.registerUser(
      UserModel(username: user.username, email: user.email, password: user.password),
    );
  }

  @override
  Future<UserEntity?> login(String username, String password) async {
    final user = await localDataSource.authenticateUser(username, password);
    if (user == null) return null;
    return UserEntity(username: user.username, email: user.email, password: user.password);
  }
} 