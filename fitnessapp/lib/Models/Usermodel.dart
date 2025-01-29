class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['username'],
      email: json['email'],
    );
  }
}
