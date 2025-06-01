import 'storage.dart';

class MockStorage implements Storage {
  String? _jwt;
  String? _username;
  List<String> _roles = [];

  @override
  Future<void> saveJwt(String jwt) async {
    _jwt = jwt;
  }

  @override
  Future<void> saveUsername(String username) async {
    _username = username;
  }

  @override
  Future<void> saveRoles(List<String> roles) async {
    _roles = List.from(roles);
  }

  @override
  String? getJwt() => _jwt;

  @override
  String? getUsername() => _username;

  @override
  List<String> getRoles() => List.unmodifiable(_roles);

  @override
  Future<void> clear() async {
    _jwt = null;
    _username = null;
    _roles = [];
  }
}
