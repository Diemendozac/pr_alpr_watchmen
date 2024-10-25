

import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void logOutUser() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
