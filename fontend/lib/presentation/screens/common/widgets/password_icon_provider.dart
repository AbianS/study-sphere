import 'package:flutter/material.dart';

class PasswordIconProvider extends ChangeNotifier {
  bool _showPassword = false;

  bool get showPassword => _showPassword;

  void toggleVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }
}
