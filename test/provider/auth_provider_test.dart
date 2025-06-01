import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/db/mock_storage.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/services/auth_service.dart';

void main() async {
  // Mock implementations or real ones depending on your setup
  final authRepo = AuthRepository(apiClient: ApiClient()); // replace with mock if needed
  final storage = MockStorage();         // in-memory or file storage
  final authService = AuthService(authRepo, storage);
  final authProvider = AuthProvider(authService: authService);

  print('Initial isLoggedIn: ${authProvider.isLoggedIn}');
  print('Attempting login...');

  await authProvider.login('ss', 'password123');

  print('Login successful: ${authProvider.isLoggedIn}');
  print('JWT Token: ${authProvider.jwt}');
  print('Roles: ${authProvider.roles}');

  print('Logging out...');
  await authProvider.logout();

  print('After logout - isLoggedIn: ${authProvider.isLoggedIn}');
  print('JWT after logout: ${authProvider.jwt}');
  print('Roles after logout: ${authProvider.roles}');
}
