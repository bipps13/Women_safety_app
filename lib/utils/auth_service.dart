import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 🔐 Fixed credentials
  static const String _fixedEmail = "bipashamondal8788@gmail.com";
  static const String _fixedPassword = "Bipasha@13";

  // ✅ Dummy register method (to avoid errors)
  static Future<void> registerUser(
      String name, String email, String password) async {
    // Intentionally left blank
    // (Using fixed credentials for demo)
  }

  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    email = email.trim();
    password = password.trim();

    if (email == _fixedEmail && password == _fixedPassword) {
      await prefs.setBool('loggedIn', true);
      return true;
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
  }
}
