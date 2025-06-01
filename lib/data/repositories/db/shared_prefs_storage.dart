import 'package:shared_preferences/shared_preferences.dart';
import 'storage.dart';

class SharedPrefsStorage implements Storage {
  final SharedPreferences prefs;

  SharedPrefsStorage(this.prefs);

  static const _jwtKey = 'jwt';
  static const _usernameKey = 'username';
  static const _rolesKey = 'roles';

  @override
  Future<void> saveJwt(String jwt) async {
    await prefs.setString(_jwtKey, jwt);
  }

  @override
  Future<void> saveUsername(String username) async {
    await prefs.setString(_usernameKey, username);
  }

  @override
  Future<void> saveRoles(List<String> roles) async {
    await prefs.setStringList(_rolesKey, roles);
  }

  @override
  String? getJwt() => prefs.getString(_jwtKey);

  @override
  String? getUsername() => prefs.getString(_usernameKey);

  @override
  List<String> getRoles() => prefs.getStringList(_rolesKey) ?? [];

  @override
  Future<void> clear() async {
    await prefs.remove(_jwtKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_rolesKey);
  }
}
