

import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';
import 'package:lms/services/auth_service.dart';

Future<void> runAuthServiceTests(Storage storage) async {
  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient: apiClient);
  final authService = AuthService(authRepo, storage);

  print('--- AuthService Tests ---');

  print('1. Trying login...');
  bool success = await authService.login('ss', 'password123');
  print('Login success: $success');

  if (success) {
    print('JWT: ${authService.getJwt()}');
    print('Username: ${authService.getUsername()}');
    print('Roles: ${authService.getRoles()}');
    print('Is Logged In: ${authService.isLoggedIn()}');
    print('Has Role "admin": ${authService.hasRole("admin")}');
  }

  // print('2. Logging out...');
  // authService.logout();
  // print('Is Logged In After Logout: ${authService.isLoggedIn()}');
}
