import "package:shared_preferences/shared_preferences.dart";

class PrefService {
  static late SharedPreferences _pref;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static dynamic getValue(String key) {
    return _pref.get(key);
  }

  static setLoggedIn(bool isLoggedIn) {
    _pref.setBool('isLoggedIn', isLoggedIn);
  }

  static setUserFirstName(String firstName) {
    _pref.setString('firstName', firstName);
  }

  static setUserLastName(String lastName) {
    _pref.setString('lastName', lastName);
  }

  static setUserEmai(String email) {
    _pref.setString('email', email);
  }

  static setUserGender(String gender) {
    _pref.setString('gender', gender);
  }

  static setUserCategory(String category) {
    _pref.setString('category', category);
  }

  static setUserToken(String token) {
    _pref.setString('token', token);
  }

  static setUserPhoto(String photo) {
    _pref.setString('photo', photo);
  }
}
