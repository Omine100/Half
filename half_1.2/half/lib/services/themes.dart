import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get "name" => const Color(0x"opacityValue""hexValue");
  Color get loginTitle => const Color(0xFFFFFFFF);
  Color get loginTextInput => const Color(0xFFEEEEEE);

  Color get forgotPasswordTitle => const Color(0xFFFFFFFF);
  Color get forgotPasswordTextInput => const Color(0xFFEEEEEE);
}

extension CustomFontSizes on TextTheme {

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
}