import "package:http/http.dart" as http;

const baseUrl = "https://citysewa2.onrender.com/api/v1";

class AuthService {
  final modUrl = "accounts/provider";
  Future login(String email, String password) async {
    final body = {"email": email, "password": password};
    final url = Uri.parse("$baseUrl/$modUrl/login");
    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("catch: $e");
    }
  }

  Future register(
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
        return response.body;
      } else {
        print("${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("catch: $e");
    }
  }

  Future resetPassword(String otp, String newPassword) async {}
}
