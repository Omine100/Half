import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get 'name' => const Color(0x'hexValue');
  Color get titleColor => const Color(0xFFdc3545);
  Color get backButtonColor => const Color(0xFFFFFFFF);
  Color get gradientTopLeftColor => const Color(0xFFFF9359);
  Color get gradientBottomRightColor => const Color(0xFFed2b7a);

  Color get loginTitleColor => const Color(0xFFFFFFFF);
  Color get loginTextInputColor => const Color(0xFFEEEEEE);

  Color get forgotPasswordTextInputColor => const Color(0xFFEEEEEE);
  Color get forgotPasswordGradientTopLeftColor => const Color(0xFFFF9359);
  Color get forgotPasswordGradientBottomRightColor => const Color(0xFFed2b7a);
  Color get forgotPasswordTitleColor => const Color(0xFFFFFFFF);
  Color get forgotPasswordResetColor => const Color(0xFFFFFFFF);

  Color get connectorTextInputColor => const Color(0xFFEEEEEE);
  Color get connectorTitleColor => const Color(0xFFFFFFFF);
  Color get connectorConnectColor => const Color(0xFFFFFFFF);
  Color get connectorUserIdBackgroundColor => const Color(0x00FFFFFF);

  Color get homeTitleBackgroundColor => const Color(0x00FFFFFF);
  Color get homeTitleColor => const Color(0xFF000000);
  Color get homeMessageContainerBackroundColor => const Color(0xFFFFFFFF);
  Color get homeMessageBarBackgroundColor => const Color(0x85d6296f);
  Color get homeMessageBarSendIconColor => const Color(0xFFFFFFFF);
  Color get homeSignOutIconColor => const Color(0xFF000000);
}

extension CustomFontSizes on TextTheme {
  //double get 'name' => 'fontSizeValue';
  double get textInputFontSize => 22.0;
  double get titleFontSize => 48.0;

  double get forgotPaswordTitleFontSize => 37.0;
  double get forgotPasswordResetFontSize => 24.0;

  double get connectorUserIdFontSize => 24.0;

  double get homeTitleFontSize => 32.0;
}

extension CustomFontWeights on Typography {
  //Fontweight get 'name' => 'fontWeightValue'
  FontWeight get forgotPasswordTitleFontWeight => FontWeight.w600;
}

extension CustomSizes on MaterialTapTargetSize {
  //double get 'name' => 'customDimensionValue';
  double get backButtonSize => 35.0;

  double get connectorConnectButtonSize => 65.0;

  double get homeMessageBarSendButtonSize => 35.0;
  double get homeSignOutButtonSize => 35.0;
}

class Positions {
  double value;

  double forgotPasswordBackButtonPosition(BuildContext context, bool isTop) {
    return value = isTop ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.width * 0.06;
  }
  double forgotPasswordTitlePosition(BuildContext context, bool isTop) {
    return value = isTop ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.width * 0.15;
  }
}

class Dimensions {
  double value;

  double homeContainerDimension(BuildContext context, bool isHeight) {
    return value = isHeight ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.width;
  }
}

class Themes {
  double value;

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

  //Mechanics: Get dimension value
  double getDimension(BuildContext context, bool isHeight, String type) {
    MediaQuery.of(context).size.height * Theme.of(context).typography.$type;
  }

  //Mechanics: Get position value
  double getPosition(BuildContext context, bool isTop, String type) {

  }
}