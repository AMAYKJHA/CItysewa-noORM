class LoginResponse {
  bool success = false;
  String message;
  User? user;

  LoginResponse({required this.success, required this.message, this.user});
}

class RegisterResponse {
  bool success = false;
  String message;

  RegisterResponse({required this.success, required this.message});
}

class VerificationResponse {
  bool success = false;
  String message;

  VerificationResponse({required this.success, required this.message});
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  bool verified;
  String token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.verified,
    required this.token,
  });
}
