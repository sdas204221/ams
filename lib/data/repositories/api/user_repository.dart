import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/user_model.dart';
// bool kDebugMode=true;
class UserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  Future<Profile?> getUserProfile(String username, String token) async {
    final path = '/api/user/$username';
    try {
      if (kDebugMode) {
        print('Fetching profile for user: $username');
      }
      final response = await apiClient.get(path, token: token);
      if (kDebugMode) {
        print('Profile fetch response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Profile fetch response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Profile.fromJson(data);
      } else {
        if (kDebugMode) {
          print('Failed to fetch profile. Status: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during profile fetch: $e');
      }
      return null;
    }
  }
Future<List<Profile>?> getPendingUsers(String token) async {
    final path = '/api/user/pending';
    try {
      if (kDebugMode) {
        print('Fetching pending users');
      }
      final response = await apiClient.get(path, token: token);
      if (kDebugMode) {
        print('Profile fetch response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Profile fetch response body: ${response.body}');
      }

      if (response.statusCode == 200) {
         final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Profile.fromJson(e)).toList();
      } else {
        if (kDebugMode) {
          print('Failed to fetch profile. Status: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during profile fetch: $e');
      }
      return null;
    }
  }
  Future<bool> approveUser(String username, String token) async {
    final path = '/api/user/approve/$username';
    try {
      if (kDebugMode) {
        print('Approving user: $username');
      }
      final response = await apiClient.patch(path, token: token);
      if (kDebugMode) {
        print('Approve response status: ${response.statusCode}');
      }
      if (response.statusCode == 204) {
        if (kDebugMode) {
          print('User approved successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to approve user. Status: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during user approval: $e');
      }
      return false;
    }
  }

  Future<bool> assignRoles(String username, List<String> roles, String token) async {
    final path = '/api/user/role/$username';
    try {
      if (kDebugMode) {
        print('Assigning roles to user: $username');
      }
      if (kDebugMode) {
        print('Roles: $roles');
      }
      final response = await apiClient.patch(path, body: roles, token: token);
      if (kDebugMode) {
        print('Assign roles response status: ${response.statusCode}');
      }
      if (response.statusCode == 204) {
        if (kDebugMode) {
          print('Roles assigned successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Failed to assign roles. Status: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during role assignment: $e');
      }
      return false;
    }
  }
}
