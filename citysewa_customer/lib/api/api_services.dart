import "package:http/http.dart" as http;

import "package:citysewa/services/pref_service.dart" show PrefService;
import "dart:convert";

import "models.dart";

const baseUrl = "https://citysewa.onrender.com/api/v1";

const auth = "$baseUrl/user-mod/auth/customer";
const services = "$baseUrl/service-mod";

// Auth endpoint
const loginEndpoint = "$auth/login";
const registerEndpoint = "$auth/register";
const updateProfileEndpoint = "$auth/update";

// Service endpoint
const serviceEndpoint = "$services/services";

class AuthAPI {
  Future<UserModel> login(String phoneNumber, String password) async {
    final url = Uri.parse(loginEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone_number": phoneNumber, "password": password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Login failed: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<bool> register(
    String fisrtName,
    String lastName,
    String phoneNumber,
    String password,
  ) async {
    var registerSuccess = false;
    final url = Uri.parse(registerEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "first_name": fisrtName,
          "last_name": lastName,
          "phone_number": phoneNumber,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        registerSuccess = true;
        return registerSuccess;
      } else {
        throw Exception("Register failed: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map> updateProfile(
    String firstName,
    String lastName,
    String gender,
    String? imagePath,
  ) async {
    var url = Uri.parse(updateProfileEndpoint);
    String token = PrefService.getValue('token')!;
    try {
      var request = http.MultipartRequest('PATCH', url);
      if (firstName.isNotEmpty) {
        request.fields['first_name'] = firstName;
      }
      if (lastName.isNotEmpty) {
        request.fields['last_name'] = lastName;
      }
      request.fields['gender'] = gender;
      if (imagePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', imagePath),
        );
      }
      request.headers.addAll({
        'Authorization': "Token $token",
        "Accept": "application/json",
      });
      final responseStream = await request.send();
      final response = await http.Response.fromStream(responseStream);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // print(response.body);
        throw Exception("Failed");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}

class ServiceAPI {
  Future<Map> listService(String serviceType) async {
    final url = Uri.parse("$serviceEndpoint?service_type=$serviceType");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print(response.statusCode);
        throw Exception("Bad response");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map> retrieveService(int serviceId) async {
    final url = Uri.parse("$serviceEndpoint/$serviceId");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print(response.statusCode);
        throw Exception("Bad response");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<dynamic, dynamic>> serviceCarousel() async {
    final url = Uri.parse("$serviceEndpoint/carousel");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print(response.statusCode);
        throw Exception("Bad response");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map> featuredService() async {
    final url = Uri.parse("$serviceEndpoint/featured");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print(response.statusCode);
        throw Exception("Bad response");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
