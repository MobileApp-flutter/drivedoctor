import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = '';
  String _userEmail = '';

  String get userId => _userId;
  String get userEmail => _userEmail;

  void setUserId(String id) {
    if (_userId != id) {
      _userId = id;
      _notifyListeners();
    }
  }

  void setUserEmail(String email) {
    if (_userEmail != email) {
      _userEmail = email;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
