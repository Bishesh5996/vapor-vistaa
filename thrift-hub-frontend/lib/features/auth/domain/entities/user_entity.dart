import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? role;
  final String? avatar;

  const UserEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.role,
    this.avatar,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, role, avatar];
}
