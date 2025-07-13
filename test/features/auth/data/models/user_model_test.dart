import 'package:flutter_test/flutter_test.dart';
import 'package:vaporvista/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON', () {
      // Arrange
      final json = {
        '_id': '123',
        'fname': 'John',
        'lname': 'Doe',
        'email': 'john.doe@example.com',
        'phone': '+1234567890',
        'password': 'password123',
        'image': 'profile.jpg',
        'role': 'customer',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.id, '123');
      expect(userModel.firstName, 'John');
      expect(userModel.lastName, 'Doe');
      expect(userModel.email, 'john.doe@example.com');
      expect(userModel.phone, '+1234567890');
      expect(userModel.password, 'password123');
      expect(userModel.image, 'profile.jpg');
      expect(userModel.role, 'customer');
      expect(userModel.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(userModel.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('should create UserModel with default role when role is not provided', () {
      // Arrange
      final json = {
        'fname': 'Jane',
        'lname': 'Smith',
        'email': 'jane.smith@example.com',
        'phone': '+0987654321',
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.role, 'customer');
      expect(userModel.firstName, 'Jane');
      expect(userModel.lastName, 'Smith');
    });

    test('should return full name correctly', () {
      // Arrange
      final userModel = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
      );

      // Act
      final fullName = userModel.fullName;

      // Assert
      expect(fullName, 'John Doe');
    });

    test('should create copy with updated values', () {
      // Arrange
      final originalUser = UserModel(
        id: '123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        role: 'customer',
      );

      // Act
      final updatedUser = originalUser.copyWith(
        firstName: 'Jane',
        email: 'jane.doe@example.com',
      );

      // Assert
      expect(updatedUser.id, '123');
      expect(updatedUser.firstName, 'Jane');
      expect(updatedUser.lastName, 'Doe');
      expect(updatedUser.email, 'jane.doe@example.com');
      expect(updatedUser.phone, '+1234567890');
      expect(updatedUser.role, 'customer');
    });

    test('should handle null values in JSON gracefully', () {
      // Arrange
      final json = {
        'fname': null,
        'lname': null,
        'email': null,
        'phone': null,
        'createdAt': null,
        'updatedAt': null,
      };

      // Act
      final userModel = UserModel.fromJson(json);

      // Assert
      expect(userModel.firstName, '');
      expect(userModel.lastName, '');
      expect(userModel.email, '');
      expect(userModel.phone, '');
      expect(userModel.createdAt, null);
      expect(userModel.updatedAt, null);
    });
  });
} 