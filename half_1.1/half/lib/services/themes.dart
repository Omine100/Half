import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get 'name' => const Color(0x'hexValue');
  Color get title => const Color(0xFFdc3545);
  Color get backButton => const Color(0xFFFFFFFF);

  Color get loginGradientTopLeft => const Color(0xFFFF9359);
  Color get loginGradientBottomRight => const Color(0xFFed2b7a);
  Color get loginTitle => const Color(0xFFFFFFFF);
  Color get loginTextInput => const Color(0xFFEEEEEE);

  Color get forgotPasswordTextInput => const Color(0xFFEEEEEE);
  Color get forgotPasswordGradientTopLeft => const Color(0xFFFF9359);
  Color get forgotPasswordGradientBottomRight => const Color(0xFFed2b7a);
  Color get forgotPasswordTitle => const Color(0xFFFFFFFF);
  Color get forgotPasswordReset => const Color(0xFFFFFFFF);

  Color get connectorTextInput => const Color(0xFFEEEEEE);
  Color get connectorTitle => const Color(0xFFFFFFFF);
  Color get connectorConnect => const Color(0xFFFFFFFF);

  Color get homeTitleBackground => const Color(0x00FFFFFF);
  Color get homeTitle => const Color(0xFFFFFFFF);
}

extension CustomFontSizes on TextTheme {
  double get textInputFontSize => 22.0;
  double get titleFontSize => 48.0;

  double get forgotPasswordResetFontSize => 24.0;

  double get connectorConnectFontSize => 24.0;
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