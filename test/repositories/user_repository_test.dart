

import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/api/user_repository.dart';

void main() async {
  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient: apiClient);
  final userRepo = UserRepository(apiClient: apiClient);

  const username = 'ss';
  const password = 'password123';

  print('--- Logging in to get JWT token ---');
  final loginResult = await authRepo.login(username, password);

  final token = loginResult['jwt'] ?? '';
  if (token.isEmpty) {
    print('JWT token not found. Cannot proceed.');
    return;
  }

  print('JWT token retrieved: $token');

  print('\n--- Starting getUserProfile test ---');
  final profile = await userRepo.getUserProfile(username, token);
  if (profile != null) {
    print('Profile fetch succeeded:');
    print('Username: ${profile.user.username}');
    print('Email: ${profile.user.email}');
    print('Skills: ${profile.skills}');
  } else {
    print('Profile fetch failed');
  }

  print('\n--- Starting approveUser test ---');
  final approveResult = await userRepo.approveUser(username, token);
  if (approveResult) {
    print('User approval succeeded');
  } else {
    print('User approval failed');
  }

  print('\n--- Starting assignRoles test ---');
  final roles = ['admin', 'moderator'];
  final roleAssignResult = await userRepo.assignRoles(username, roles, token);
  if (roleAssignResult) {
    print('Role assignment succeeded');
  } else {
    print('Role assignment failed');
  }
  final pendingUsers = await userRepo.getPendingUsers(token);
  if (pendingUsers!=null) {
    print('pendingUsers fetche succeeded');
  } else {
    print('pendingUsers fetche failed');
  }
}
