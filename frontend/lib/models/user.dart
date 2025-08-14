class User {
  final String email;
  final String role;
  final String token;
  final String? username;
  final String? birthday;
  final String? phone;
  final String? theme;

  User({
    required this.email, 
    required this.role, 
    required this.token,
    this.username,
    this.birthday,
    this.phone,
    this.theme,
  });

  User copyWith({
    String? username,
    String? birthday,
    String? phone,
    String? theme,
  }) {
    return User(
      email: email,
      role: role,
      token: token,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      theme: theme ?? this.theme,
    );
  }
}