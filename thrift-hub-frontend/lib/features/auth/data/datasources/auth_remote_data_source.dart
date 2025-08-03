import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_entity.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/storage_service.dart';

class AuthRemoteDataSource {
  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('�� Attempting login for: $email');
      
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
      final body = {
        'email': email.trim().toLowerCase(),
        'password': password,
      };

      print('🌐 Login URL: $url');
      print('📦 Login Body: $body');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      print('📤 Login Response Status: ${response.statusCode}');
      print('📤 Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Save login data
        if (data['token'] != null) {
          await _storageService.saveToken(data['token']);
        }
        if (data['userId'] != null) {
          await _storageService.saveUserId(data['userId'].toString());
        }
        if (data['role'] != null) {
          await _storageService.saveUserRole(data['role']);
        }
        
        print('✅ Login successful, data saved');
        return data;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register(UserEntity user, String password) async {
    try {
      print('📝 Attempting registration for: ${user.email}');
      
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}');
      final body = {
        'fname': user.firstName,
        'lname': user.lastName,
        'email': user.email.trim().toLowerCase(),
        'phone': user.phone ?? '',
        'password': password,
        'role': user.role ?? 'customer',
      };

      print('🌐 Register URL: $url');
      print('📦 Register Body: $body');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      print('📤 Register Response Status: ${response.statusCode}');
      print('📤 Register Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Save registration data
        if (data['token'] != null) {
          await _storageService.saveToken(data['token']);
        }
        if (data['data'] != null && data['data']['id'] != null) {
          await _storageService.saveUserId(data['data']['id'].toString());
        }
        if (data['data'] != null && data['data']['role'] != null) {
          await _storageService.saveUserRole(data['data']['role']);
        }
        
        print('✅ Registration successful, data saved');
        return data;
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _storageService.clearAll();
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
      throw Exception('Logout failed: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<String?> getCurrentUserId() async {
    return await _storageService.getUserId();
  }
}
