import 'package:flutter/material.dart';
import 'package:the_book_nook/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser({
    required String email, 
    required String role, 
    required String token,
    String? username,
    String? birthday,
    String? phone,
    String? theme,
  }) {
    _user = User(
      email: email, 
      role: role, 
      token: token,
      username: username,
      birthday: birthday,
      phone: phone,
      theme: theme,
    );
    notifyListeners();
  }

  void updateProfile({
    String? username,
    String? birthday,
    String? phone,
    String? theme,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        username: username,
        birthday: birthday,
        phone: phone,
        theme: theme,
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
  
  bool isAdmin() {
    return _user?.role == 'admin';
  }
}