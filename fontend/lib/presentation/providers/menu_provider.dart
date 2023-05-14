import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  bool _isOpen = false;
  double _menuSize = 50;
  int _currentIndex = 0;
  double _maxValue = 300;

  double get menuSize => _menuSize;
  int get currentIndex => _currentIndex;

  void openMenu() {
    _menuSize = _maxValue;
    _isOpen = true;
    notifyListeners();
  }

  void closeMenu() {
    _menuSize = 50;
    _isOpen = false;
    notifyListeners();
  }

  void toggleMenu() {
    if (_menuSize == 50) {
      _menuSize = _maxValue;
      _isOpen = true;
      notifyListeners();
    } else {
      _menuSize = 50;
      _isOpen = false;
      notifyListeners();
    }
  }

  void changeCurrentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
