import '../models/user_model.dart';

class AuthService {
  static final List<UserModel> _users = [
    UserModel(email: 'Bishesh5996@gmail.com', password: '1234567890'),
  ];

  static bool loginUser(String email, String password) {
    return _users.any(
      (user) => user.email == email && user.password == password,
    );
  }

  static void registerUser(String email, String password) {
    _users.add(UserModel(email: email, password: password));
  }
}
