import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  bool _isLoading  = false;
  String _loginError = "";
  String _token = "";
  String _email = "";

  bool get isLoading => _isLoading;
  String get loginError => _loginError;
  String get email => _email;
  String get token => _token;


  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void setLoginError(String value){
    _loginError = value;
    notifyListeners();
  }


  void setToken(String value){
    _token = value;
    notifyListeners();
  }
  void setEmail(String value){
    _email = value;
    notifyListeners();
  }
}