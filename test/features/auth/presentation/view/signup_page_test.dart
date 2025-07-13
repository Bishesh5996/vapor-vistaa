import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:vaporvista/features/auth/domain/entities/user_entity.dart';
import 'package:vaporvista/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaporvista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vaporvista/features/auth/presentation/view/signup_page.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<String, UserEntity>> register(UserEntity user, String password) async {
    return Right(UserEntity(id: '1', email: user.email, firstName: user.firstName, lastName: user.lastName, phone: user.phone));
  }

  @override
  Future<Either<String, UserEntity>> login(String email, String password) async {
    return Right(UserEntity(id: '1', email: email, firstName: 'Test', lastName: 'User', phone: '1234567890'));
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    return Right(UserEntity(id: '1', email: 'test@example.com', firstName: 'Test', lastName: 'User', phone: '1234567890'));
  }

  @override
  Future<Either<String, UserEntity>> updateProfile(UserEntity user) async {
    return Right(user);
  }

  @override
  Future<Either<String, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<bool> isLoggedIn() async {
    return false;
  }
}

class FakeAuthBloc extends AuthBloc {
  FakeAuthBloc() : super(authRepository: FakeAuthRepository());
}

void main() {
  group('SignUpPage', () {
    late AuthBloc fakeAuthBloc;

    setUp(() {
      fakeAuthBloc = FakeAuthBloc();
    });

    tearDown(() {
      fakeAuthBloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: fakeAuthBloc,
          child: const SignUpPage(),
        ),
      );
    }

    testWidgets('should build without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(tester.takeException(), isNull);
    });

    testWidgets('should display Sign up text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Sign up'), findsOneWidget);
    });
  });
}
