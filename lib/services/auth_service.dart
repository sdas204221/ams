

import 'package:lms/data/models/user_model.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';

class AuthService {
  final AuthRepository authRepository;
  final Storage storage;

  AuthService(this.authRepository, this.storage);

  Future<bool> login(String username, String password) async {
    final loginResponse = await authRepository.login(username, password);
    try{
    await storage.saveJwt(loginResponse["jwt"]);
    await storage.saveUsername(username);
    await storage.saveRoles(loginResponse["roles"]);
    return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> register(Profile profile) async {
    try{
      Map<String,dynamic> body= await authRepository.register(profile.toJson());
      return body['success'];
    }
    catch(e){
      return false;
    }
  }

  Future<void> logout() async {
    await storage.clear();
  }

  String? getJwt() => storage.getJwt();

  String? getUsername() => storage.getUsername();

  List<String> getRoles() => storage.getRoles();

  bool isLoggedIn() => getJwt() != null;

  bool hasRole(String role) => getRoles().contains(role);
}
