import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/api/user_repository.dart';
import 'package:lms/data/repositories/db/mock_storage.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:lms/services/auth_service.dart';
import 'package:lms/services/user_service.dart';

void main() async {
  // Initialize dependencies
  final userRepo = UserRepository(apiClient: ApiClient()); // Use a mock if needed
  final storage = MockStorage();         // Make sure this has a valid JWT stored
  final userService = UserService(userRepo: userRepo, storage: storage);
  final userProvider = UserProvider(userService: userService);

  final authRepo = AuthRepository(apiClient: ApiClient()); 
  final authService = AuthService(authRepo, storage);
  final authProvider = AuthProvider(authService: authService);
  await authProvider.login('ss', 'password123');

  final profile1 = Profile.fromJson({
    "education": "B.Tech in CS",
    "jobDetails": "Software Engineer",
    "skills": "Flutter, Java, Spring Boot",
    "achievements": "Open Source Contributor",
    "profilePicture": null, // or provide a valid structure
    "user": {
      "username": "test_user_${DateTime.now().millisecondsSinceEpoch}",
      "password": "securepass",
      "email": "newuser@example.com",
      "roles": []
    }
  });

  await authProvider.register(profile1);

  // Testing getProfile
  print('Fetching profile for ${profile1.user.username}...');
  final profile = await userProvider.getProfile(profile1.user.username);
  //final profile = await userProvider.getProfile("test_user_1748621557707");
  if (profile != null) {
    print("Profile fetched: ${profile.toJson()}");
  } else {
    print("Failed to fetch profile.");
  }

  print('Approving user ${profile!.user.username}...');
  final approved = await userProvider.approveUser(profile.user.username);
  print("User approved: $approved");

  print('Assigning roles to ${profile.user.username}...');
  final rolesAssigned = await userProvider.assignRoles(profile.user.username, ["admin", "moderator"]);
  print("Roles assigned: $rolesAssigned");
}
