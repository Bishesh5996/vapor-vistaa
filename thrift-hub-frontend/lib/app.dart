import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/view/login_page.dart';
import 'features/auth/presentation/view/signup_page.dart';
import 'features/home/presentation/view/dashboard_page.dart';
import 'features/home/presentation/view/splash_screen.dart';
import 'features/profile/presentation/view/profile_page.dart';
import 'core/theme/vapor_colors.dart';

class VaporVistaApp extends StatelessWidget {
  const VaporVistaApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: sl<AuthRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Vapor Vista',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF1A1A2E, {
            50: const Color(0xFFE3E4E8),
            100: const Color(0xFFBABBC5),
            200: const Color(0xFF8D8F9F),
            300: const Color(0xFF606279),
            400: const Color(0xFF3E415D),
            500: const Color(0xFF1A1A2E),
            600: const Color(0xFF171729),
            700: const Color(0xFF131323),
            800: const Color(0xFF0F0F1D),
            900: const Color(0xFF080812),
          }),
          primaryColor: VaporColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: VaporColors.primary,
            secondary: VaporColors.accent,
            brightness: Brightness.light,
          ),
          fontFamily: 'OpenSans Condensed',
          
          // AppBar Theme - Dark Premium Look
          appBarTheme: AppBarTheme(
            backgroundColor: VaporColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: VaporColors.primary.withOpacity(0.3),
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          // Button Themes
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: VaporColors.accent,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: VaporColors.accent.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          
          // FIXED: CardThemeData instead of CardTheme
          cardTheme: CardThemeData(
            elevation: 3,
            shadowColor: VaporColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Bottom Navigation Theme
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: VaporColors.accent,
            unselectedItemColor: VaporColors.textSecondary,
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/signup': (context) => const SignUpPage(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
