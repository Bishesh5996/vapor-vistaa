import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<void> call(String username, String email, String password) {
    return repository.signup(UserEntity(username: username, email: email, password: password));
  }
} 