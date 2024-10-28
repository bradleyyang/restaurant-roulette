import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void login(User user) {
    _currentUser = user;
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  void logout() {
    _currentUser = null;
    notifyListeners(); // Notify listeners to rebuild widgets
  }
}