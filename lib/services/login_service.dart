import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:machine_test/controller/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<bool> login(
      {required String email,
      required String password,
      required AuthProvider provider}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      print(email);
      print(password);
      final url = Uri.parse("https://reqres.in/api/login");
      final response =
          await http.post(url, body: {"email": email, "password": password});
      print("Response of login ${response.statusCode}, ${response.body}");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData.containsKey("token")) {
          prefs.setString("token", responseData["token"]);
          prefs.setString("email", email);
          
          print(prefs.getString("token"));
          provider.setLoginError("Successfully loggedin");
          return true;
        } else {
          return false;
        }
      } else if (responseData.containsKey("error")) {
        provider.setLoginError(
            "User does not exists. Enter a valid email or password");
        return false;
      }
      return false;
    } catch (e) {
      print("Unexpected error $e");
      return false;
    }
  }
}
