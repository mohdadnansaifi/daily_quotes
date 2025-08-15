import 'package:flutter/material.dart';

class darkThemeProvider with ChangeNotifier{
  bool _isDark = false;
  bool  get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;


  void setTheme(){
    _isDark =!_isDark;
    notifyListeners();
  }
}