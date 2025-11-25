import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get token => _token;

  void login(String userId, String email, String token) {
    _isAuthenticated = true;
    _userId = userId;
    _userEmail = email;
    _token = token;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _token = null;
    notifyListeners();
  }
}
