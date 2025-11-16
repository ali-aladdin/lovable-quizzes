class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  final String id;
  final String username;
  final String email;
  final String password;

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
