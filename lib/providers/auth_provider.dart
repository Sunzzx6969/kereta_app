import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isAdmin = false;

  UserModel? get user => _user;
  bool get isAdmin => _isAdmin;

  void login(UserModel user, bool adminStatus) {
    _user = user;
    _isAdmin = adminStatus;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }
}