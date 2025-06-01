import 'package:flutter/material.dart';
import 'package:trek/view/dashboard_page.dart';
import 'package:trek/view/login_page.dart';
import 'package:trek/view/splash_screen.dart';
import 'package:trek/view/signup_page.dart';

class TrekApp extends StatelessWidget {
  const TrekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trek App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Arial',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}