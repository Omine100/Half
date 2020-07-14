import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get 'name' => const Color(0x'hexValue');
  Color get title => const Color(0xFFdc3545);
}

class Themes {
  //Theme: Light theme
  ThemeData lightTheme() {
    return ThemeData();
  }

  //Theme: Dark theme
  ThemeData darkTheme() {
    return ThemeData();
  }

  //Mechanics: Check dark theme
  bool checkDarkTheme(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if(brightness == Brightness.dark) {
      return true;
    }
    return false;
  }
}