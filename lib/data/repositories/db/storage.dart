abstract class Storage {
  Future<void> saveJwt(String jwt);
  Future<void> saveUsername(String username);
  Future<void> saveRoles(List<String> roles);

  String? getJwt();
  String? getUsername();
  List<String> getRoles();

  Future<void> clear();
}
