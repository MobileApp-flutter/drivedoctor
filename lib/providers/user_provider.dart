import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userId = '';
  String userEmail = '';

  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }
  void setUserEmail(String email) {
    userEmail = email;
    notifyListeners();
  }
}
