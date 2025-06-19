import 'package:flutter/foundation.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService userService;

  Profile? _currentProfile;
  List<Profile>? _profiles;
  List<String>? _usernames;

  Profile? get currentProfile => _currentProfile;
  List<String>? get usernames => _usernames;
  UserProvider({required this.userService});
  Future<List<String>?> getAllUsernames() async{
    _usernames ??= await userService.getAllUsernames();
    return usernames;
  }
Future<Profile?> getMyProfile() async {
    _currentProfile = await userService.getMyProfile();
    notifyListeners();
    return _currentProfile;
  }
  Future<Profile?> getProfile(String username) async {
    _currentProfile = await userService.getProfile(username);
    notifyListeners();
    return _currentProfile;
  }

  Future<List<Profile>?> getPendingUsers() async {
    _profiles=await userService.getPendingUsers();
    notifyListeners();
    return _profiles;
  }

  Future<bool> approveUser(String username) async {
    final result = await userService.approveUser(username);
    return result;
  }

  Future<bool> assignRoles(String username, List<String> roles) async {
    final result = await userService.assignRoles(username, roles);
    return result;
  }
  Future<Profile?> updateProfile(Profile profile) async{
  return userService.updateMyProfile(profile);
  }
  
}
