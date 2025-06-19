class Role {
  final int? id;
  final String name;

  Role({this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}


class User {
  final int? id;
  final String username;
  final String email;
  final List<Role> roles;
  final bool? isAccountLocked;
  final bool? isEnabled;
  final String? password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.roles,
    this.isAccountLocked,
    this.isEnabled,
    this.password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      roles: (json['roles'] as List<dynamic>)
          .map((role) => Role.fromJson(role))
          .toList(),
      isAccountLocked: json['isAccountLocked'],
      isEnabled: json['isEnabled'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles.map((role) => role.toJson()).toList(),
      'isAccountLocked': isAccountLocked,
      'isEnabled': isEnabled,
      'password': password,
    };
  }

  User copyWith({
  int? id,
  String? username,
  String? email,
  List<Role>? roles,
  bool? isAccountLocked,
  bool? isEnabled,
  String? password,
}) {
  return User(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    roles: roles ?? this.roles,
    isAccountLocked: isAccountLocked ?? this.isAccountLocked,
    isEnabled: isEnabled ?? this.isEnabled,
    password: password ?? this.password,
  );
}

}

class Profile {
  final int? id;
  final String? education;
  final String? jobDetails;
  final String? skills;
  final String? achievements;
  final String? name;
  final dynamic profilePicture; // Consider replacing with a proper model if needed
  final User user;

  Profile({
    this.name,
    this.id,
    this.education,
    this.jobDetails,
    this.skills,
    this.achievements,
    this.profilePicture,
    required this.user,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      education: json['education'],
      jobDetails: json['jobDetails'],
      skills: json['skills'],
      achievements: json['achievements'],
      profilePicture: json['profilePicture'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'education': education,
      'jobDetails': jobDetails,
      'skills': skills,
      'achievements': achievements,
      'profilePicture': profilePicture,
      'user': user.toJson(),
    };
  }
}
