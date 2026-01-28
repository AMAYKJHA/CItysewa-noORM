import "dart:convert";

import "package:http/http.dart" as http;

import "package:citysewa_provider/api/models.dart";

const baseUrl = "https://citysewa2.onrender.com/api/v1";

class AuthService {
  final modUrl = "accounts/provider";

  // login
  Future<LoginResponse> login(String email, String password) async {
    final body = jsonEncode({"email": email, "password": password});
    final url = Uri.parse("$baseUrl/$modUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse(
          success: true,
          message: "Login Successful",
          user: User(
            id: data["id"],
            firstName: data["first_name"],
            lastName: data["last_name"],
            gender: data["gender"],
            verified: data["verified"],
            token: data["token"],
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: data["message"] ?? "Invalid credentials.",
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  Future<RegisterResponse> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "gender": "Male",
    };
    final url = Uri.parse("$baseUrl/$modUrl/register");
    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RegisterResponse(
          success: true,
          message: "Registration successful",
        );
      } else {
        final data = jsonDecode(response.body);
        return RegisterResponse(
          success: false,
          message: data["message"] ?? "Invalid credentials.",
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: "Something went wrong. Please try again.",
      );
    }
  }

  Future verifyProvider(
    String phoneNumber,
    String docNumber,
    String docType,
    String photoPath,
    String docPath,
  ) async {}
  Future resetPassword(String otp, String newPassword) async {}
}
