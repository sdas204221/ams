import 'package:flutter/foundation.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;

  bool _isLoggedIn = false;
  String? _jwt;
  List<String> _roles = [];

  bool get isLoggedIn => _isLoggedIn;
  String? get jwt => _jwt;
  List<String> get roles => _roles;

  AuthProvider({required this.authService}) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    _jwt = authService.getJwt();
    _roles = authService.getRoles();
    _isLoggedIn = _jwt != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final success = await authService.login(username, password);
    if (success) {
      _jwt = authService.getJwt();
      _roles = authService.getRoles();
      _isLoggedIn = true;
      notifyListeners();
    } else {
      _isLoggedIn = false;
    }
    return success;
  }

  Future<void> logout() async {
    await authService.logout();
    _jwt = null;
    _roles = [];
    _isLoggedIn = false;
    notifyListeners();
  }
  Future<bool> register(Profile profile) async {
  return await authService.register(profile);
}

}
