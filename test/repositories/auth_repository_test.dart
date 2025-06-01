

import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';

void main() async {
  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient: apiClient);


  print('--- Starting login test ---');
  final loginResult = await authRepo.login('ss', 'password123');
  if (loginResult.containsKey('jwt')) {
    print('Login Test Passed: JWT = ${loginResult['jwt']}');
  } else {
    print('Login Test Failed: ${loginResult['error']}');
  }

  print('\n--- Starting registration test ---');
  final profile = {
    "education": "B.Tech in CS",
    "jobDetails": "Software Engineer",
    "skills": "Flutter, Java, Spring Boot",
    "achievements": "Open Source Contributor",
    "profilePicture": null, // or provide a valid structure
    "user": {
      "username": "newuser123",
      "password": "securepass",
      "email": "newuser@example.com"
    }
  };
  final registerResult = await authRepo.register(profile);
  if (registerResult.containsKey('success')) {
    print('Register Test Passed');
  } else {
    print('Register Test Failed: ${registerResult['error']}');
  }
}
