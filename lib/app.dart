import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/view/login_page.dart';
import 'features/auth/presentation/view/signup_page.dart';
import 'features/home/presentation/view/dashboard_page.dart';

class TrekApp extends StatelessWidget {
  const TrekApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = AuthLocalDataSourceImpl();
    final repository = AuthRepositoryImpl(localDataSource);
    final loginUseCase = LoginUseCase(repository);
    final signupUseCase = SignupUseCase(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(
            loginUseCase: loginUseCase,
            signupUseCase: signupUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/signup',
        routes: {
          '/signup': (context) => const SignUpPage(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}