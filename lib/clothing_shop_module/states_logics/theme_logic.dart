import 'package:flutter/material.dart';

class ThemeLogic  extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void changeTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}