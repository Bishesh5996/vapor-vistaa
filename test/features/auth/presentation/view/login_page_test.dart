import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:vaporvista/features/auth/presentation/view/login_page.dart';
import 'package:vaporvista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vaporvista/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginPage', () {
    late MockAuthRepository mockAuthRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
          '/signup': (context) => const Scaffold(body: Text('Sign Up Page')),
          '/dashboard': (context) => const Scaffold(body: Text('Dashboard Page')),
        },
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginPage(),
        ),
      );
    }

    testWidgets('should render login form with all required fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign up here'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
    });

    // testWidgets('should show loading indicator when login button is pressed', (WidgetTester tester) async {
    //   // Arrange
    //   when(mockAuthRepository.login(any, any)).thenAnswer((_) async {
    //     await Future.delayed(const Duration(milliseconds: 300));
    //     return const Left('Test error');
    //   });
    //   
    //   await tester.pumpWidget(createWidgetUnderTest());

    //   // Act
    //   await tester.enterText(find.byType(TextField).first, 'test@example.com');
    //   await tester.enterText(find.byType(TextField).last, 'password123');
    //   await tester.tap(find.text('Login'));
    //   await tester.pump();
    //   await tester.pump(const Duration(milliseconds: 100));

    //   // Assert - Look for CircularProgressIndicator inside the button
    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    testWidgets('should navigate to signup page when signup button is pressed', (WidgetTester tester) async {
      // Arrange
      when(mockAuthRepository.login(any, any))
          .thenAnswer((_) async => const Left('Test error'));
      
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.text('Sign up here'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sign Up Page'), findsOneWidget);
    });

    // testWidgets('should show error message when authentication fails', (WidgetTester tester) async {
    //   // Arrange
    //   when(mockAuthRepository.login('test@example.com', 'wrongpassword'))
    //       .thenAnswer((_) async => const Left('Invalid credentials'));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   // Act
    //   await tester.enterText(find.byType(TextField).first, 'test@example.com');
    //   await tester.enterText(find.byType(TextField).last, 'wrongpassword');
    //   await tester.tap(find.text('Login'));
    //   await tester.pumpAndSettle();

    //   // Assert - Look for error text
    //   expect(find.text('Invalid credentials'), findsOneWidget);
    // });

    testWidgets('should have proper text field decorations', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      // Check that password field has obscureText set to true
      final passwordTextField = tester.widget<TextField>(passwordField);
      expect(passwordTextField.obscureText, true);
    });

    testWidgets('should have proper button styling', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsOneWidget);

      final elevatedButton = tester.widget<ElevatedButton>(loginButton);
      expect(elevatedButton.style, isNotNull);
    });
  });
} 