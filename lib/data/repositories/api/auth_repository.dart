import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/user_model.dart';
//bool kDebugMode=true;
class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final path = '/api/user/login';
    final body = {'username': username, 'password': password};

    try {
      if (kDebugMode) {
        print('Sending login request...');
      }
      final response = await apiClient.post(path, body: body);
      if (kDebugMode) {
        print('Login response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Login response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'jwt': data['jwt'],
          'roles': (data['roles'] as List)
              .map((r) => Role.fromJson(r).name)
              .toList(),
        };
      } else {
        return {'error': jsonDecode(response.body)['error'] ?? 'Login failed'};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login exception: $e');
      }
      return {'error': 'Exception occurred during login'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> profile) async {
    final path = '/api/user/register';

    try {
      if (kDebugMode) {
        print('Sending registration request...');
      }
      final response = await apiClient.post(path, body: profile);
      if (kDebugMode) {
        print('Register response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Register response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        return {'error': 'Registration failed. Status: ${response.statusCode}'};
      }
    } catch (e) {
      if (kDebugMode) {
        print('Registration exception: $e');
      }
      return {'error': 'Exception occurred during registration'};
    }
  }
}
