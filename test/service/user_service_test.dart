import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/data/repositories/api/user_repository.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';
import 'package:lms/services/auth_service.dart';
import 'package:lms/services/user_service.dart';

Future<void> runUserServiceTests(Storage storage) async {
  print('\n=== Running UserService Tests with Real Repository ===');

  final apiClient = ApiClient();
  final userRepo = UserRepository(apiClient: apiClient);
  final authRepo = AuthRepository(apiClient: apiClient);

  final userService = UserService(userRepo: userRepo, storage: storage);
  final authService = AuthService(authRepo, storage);

  /// Step 1: Register a test user
  final testUser = Profile(
    user: User(
    username: 'test_user_${DateTime.now().millisecondsSinceEpoch}',
    email: 'testuse9r@example.com',
    roles: [Role(name: 'user')],
    password: 'password123'
    ) 
  );

  bool registered = await authService.register(testUser);
  if (!registered) {
    print('❌ Failed to register test user');
    return;
  }
  print('✅ Registered test user: ${testUser.user.username}');

  await authService.login('ss', 'password123');
  await userService.approveUser(testUser.user.username);
  await authService.logout();
  /// Step 2: Login the user (to populate JWT and roles)
  await authService.login(testUser.user.username, testUser.user.password!);
  print('✅ Logged in as ${authService.getUsername()}');

  /// Step 3: Fetch user ID using profile (assume server uses username lookup)
  Profile? profile;
  try {
    profile = await userService.getProfile(testUser.user.username);
    print('\n✅ getProfile: ${profile?.toJson()}');
  } catch (e) {
    print('❌ Error in getProfile: $e');
  }

  if (profile == null) {
    print('❌ Cannot proceed without user ID');
    return;
  }

  final userId = profile.user.username;

  /// Step 4: Approve the user
  try {
    await userService.approveUser(userId);
    print('\n✅ approveUser: Approved user $userId');
  } catch (e) {
    print('❌ Error in approveUser: $e');
  }

  /// Step 5: Assign roles
  try {
    await userService.assignRoles(userId, ['user', 'moderator']);
    print('\n✅ assignRoles: Assigned roles to user $userId');
  } catch (e) {
    print('❌ Error in assignRoles: $e');
  }

  try {
    await userService.getPendingUsers();
    print('\n✅ getPendingUsers');
  } catch (e) {
    print('❌ Error in assignRoles: $e');
  }

  print('\n=== Finished UserService Tests ===');
}
