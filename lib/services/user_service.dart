import 'package:flutter/foundation.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/data/repositories/api/user_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';

class UserService {
  final UserRepository userRepo;
  final Storage storage;

  UserService({required this.userRepo, required this.storage});

Future<List<String>?> getAllUsernames() async {
    final token = storage.getJwt();
    if (token == null) {
      print('[UserService] Token is null');
      return null;
    }

    final profile = await userRepo.getAllUsernames(token);
    if (profile != null) {
      print('[UserService] getAllUsernames invoked');
    } else {
      print('[UserService] Failed to fetch profile');
    }
    return profile;
  }


  Future<Profile?> updateMyProfile(Profile profile)async{
    final token = storage.getJwt();
    if (token == null) {
      if (kDebugMode) {
        print('[UserService] Token is null');
      }
      return null;
    }
    Profile? updatedProfile=await userRepo.updateProfile(profile, token);
    return updatedProfile;
  }
Future<Profile?> getMyProfile() async {
    final token = storage.getJwt();
    if (token == null) {
      print('[UserService] Token is null');
      return null;
    }

    final profile = await userRepo.getMyProfile(token);
    if (profile != null) {
      print('[UserService] Profile fetched for ${profile.user.username}');
    } else {
      print('[UserService] Failed to fetch profile');
    }
    return profile;
  }

  Future<Profile?> getProfile(String? username) async {
    final token = storage.getJwt();
    if (token == null || username == null) {
      print('[UserService] Token or username is null');
      return null;
    }

    final profile = await userRepo.getUserProfile(username, token);
    if (profile != null) {
      print('[UserService] Profile fetched for $username');
    } else {
      print('[UserService] Failed to fetch profile for $username');
    }
    return profile;
  }

  Future<bool> approveUser(String username) async {
    final token = storage.getJwt();
    if (token == null) {
      print('[UserService] Token is null');
      return false;
    }

    final result = await userRepo.approveUser(username, token);
    print('[UserService] Approve user result: $result');
    return result;
  }

  Future<bool> assignRoles(String username, List<String> roles) async {
    final token = storage.getJwt();
    if (token == null) {
      print('[UserService] Token is null');
      return false;
    }

    final result = await userRepo.assignRoles(username, roles, token);
    print('[UserService] Assign roles result: $result');
    return result;
  }

  Future<List<Profile>> getPendingUsers() async {
    final token = storage.getJwt();
    if (token == null) {
      print('[UserService] Token is null');
      return [];
    }
    List<Profile>? profiles=await userRepo.getPendingUsers(token);
    print('[UserService] getPendingUsers result: $profiles');
    return profiles ?? [];
  }
}
