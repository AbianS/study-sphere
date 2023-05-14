class LoginModel {
  const LoginModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  String toString() => "$email, $password";
}
