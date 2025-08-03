import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/view/login_page.dart';
import 'features/auth/presentation/view/signup_page.dart';
import 'features/home/presentation/view/dashboard_page.dart';
import 'core/theme/vapor_colors.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRemoteDataSource>()));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrift Hub',
      theme: ThemeData(
        primaryColor: VaporColors.primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: VaporColors.primary,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        ),
        '/signup': (context) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const SignUpPage(),
        ),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
