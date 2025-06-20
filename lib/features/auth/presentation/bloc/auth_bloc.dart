import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSignupSuccess extends AuthState {}
class AuthLoginSuccess extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthCubit({required this.loginUseCase, required this.signupUseCase}) : super(AuthInitial());

  Future<void> signup(String username, String email, String password) async {
    emit(AuthLoading());
    try {
      await signupUseCase(username, email, password);
      emit(AuthSignupSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    final user = await loginUseCase(username, password);
    if (user != null) {
      emit(AuthLoginSuccess());
    } else {
      emit(AuthError('Invalid credentials'));
    }
  }
} 