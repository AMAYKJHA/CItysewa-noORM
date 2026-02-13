import "package:shared_preferences/shared_preferences.dart";

import "package:citysewa_customer/api/models.dart" show User;

class SessionManager {
  static Future saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("firstName", user.firstName);
    prefs.setString("lastName", user.lastName);
    prefs.setString("gender", user.gender);
    prefs.setBool("verified", user.verified);
    if (user.token != null) {
      prefs.setString("token", user.token!);
    }
    if (user.photo != null) {
      prefs.setString("photo", user.photo!);
    }
    if (user.description != null) {
      prefs.setString("description", user.description!);
    }
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt("id");
    if (id == null) return null;
    final firstName = prefs.getString("firstName");
    final lastName = prefs.getString("lastName");
    final gender = prefs.getString("gender");
    final verified = prefs.getBool("verified");
    final token = prefs.getString("token");
    final photo = prefs.getString("photo");
    final description = prefs.getString("description");

    return User(
      id: id,
      firstName: firstName!,
      lastName: lastName!,
      gender: gender!,
      verified: verified!,
      token: token,
      photo: photo,
      description: description,
    );
  }

  static Future saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("loggedIn", true);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loggedIn") ?? false;
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
