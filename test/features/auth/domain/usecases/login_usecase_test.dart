import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:vaporvista/features/auth/domain/usecases/login_usecase.dart';
import 'package:vaporvista/features/auth/domain/repositories/auth_repository.dart';
import 'package:vaporvista/features/auth/domain/entities/user_entity.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = LoginUseCase(mockRepository);
    });

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testUser = UserEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      phone: '+1234567890',
      role: 'customer',
    );

    test('should return UserEntity when repository call is successful', () async {
      // Arrange
      when(mockRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => const Right(testUser));

      // Act
      final result = await useCase(testEmail, testPassword);

      // Assert
      expect(result, const Right(testUser));
      verify(mockRepository.login(testEmail, testPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return error message when repository call fails', () async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => const Left(errorMessage));

      // Act
      final result = await useCase(testEmail, testPassword);

      // Assert
      expect(result, const Left(errorMessage));
      verify(mockRepository.login(testEmail, testPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      when(mockRepository.login(testEmail, testPassword))
          .thenAnswer((_) async => const Right(testUser));

      // Act
      await useCase(testEmail, testPassword);

      // Assert
      verify(mockRepository.login(testEmail, testPassword)).called(1);
    });
  });
} 