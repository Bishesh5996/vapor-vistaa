import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:vaporvista/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vaporvista/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaporvista/features/auth/domain/entities/user_entity.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    const testUser = UserEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      phone: '+1234567890',
      role: 'customer',
    );

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when login is successful',
        build: () {
          when(mockAuthRepository.login('test@example.com', 'password'))
              .thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password')),
        expect: () => [
          isA<AuthLoading>(),
          isA<Authenticated>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.login('test@example.com', 'password')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(mockAuthRepository.login('test@example.com', 'wrongpassword'))
              .thenAnswer((_) async => const Left('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(LoginRequested('test@example.com', 'wrongpassword')),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.login('test@example.com', 'wrongpassword')).called(1);
        },
      );
    });

    group('RegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when registration is successful',
        build: () {
          when(mockAuthRepository.register(testUser, 'password'))
              .thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(RegisterRequested(testUser, 'password')),
        expect: () => [
          isA<AuthLoading>(),
          isA<Unauthenticated>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.register(testUser, 'password')).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails',
        build: () {
          when(mockAuthRepository.register(testUser, 'password'))
              .thenAnswer((_) async => const Left('Email already exists'));
          return authBloc;
        },
        act: (bloc) => bloc.add(RegisterRequested(testUser, 'password')),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.register(testUser, 'password')).called(1);
        },
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when logout is successful',
        build: () {
          when(mockAuthRepository.logout())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(LogoutRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<Unauthenticated>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.logout()).called(1);
        },
      );
    });

    group('CheckAuthStatus', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when user is logged in',
        build: () {
          when(mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => true);
          when(mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatus()),
        expect: () => [
          isA<Authenticated>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.isLoggedIn()).called(1);
          verify(mockAuthRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when user is not logged in',
        build: () {
          when(mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => false);
          return authBloc;
        },
        act: (bloc) => bloc.add(CheckAuthStatus()),
        expect: () => [
          isA<Unauthenticated>(),
        ],
        verify: (_) {
          verify(mockAuthRepository.isLoggedIn()).called(1);
          verifyNever(mockAuthRepository.getCurrentUser());
        },
      );
    });

    group('AuthResetRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when reset is requested',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthResetRequested()),
        expect: () => [
          isA<AuthInitial>(),
        ],
      );
    });
  });
} 