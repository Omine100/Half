import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get 'name' => const Color(0x'hexValue');
  Color get interfaceStandardsBackButtonColor => const Color(0xFFFFFFFF);
  Color get interfaceStandardsGradientTopLeftColor => const Color(0xFFFF9359);
  Color get interfaceStandardsGradientBottomRightColor => const Color(0xFFed2b7a);
  Color get interfaceStandardsHeaderTextColor => const Color(0xFFFFFFFF);

  Color get loginTitleColor => const Color(0xFFFFFFFF);
  Color get loginTextInputColor => const Color(0xFFEEEEEE);
  Color get loginSignInSignUpButtonColor => const Color(0xFFFFFFFF);
  Color get loginSignInSignUpAlternateTextColor => const Color(0xFFFFFFFF);
  Color get loginForgotPasswordButtonColor => const Color(0xFFFFFFFF);
  Color get loginErrorMessageColor => const Color(0xFFF44336);

  Color get forgotPasswordTitleColor => const Color(0xFFFFFFFF);
  Color get forgotPasswordTextInputColor => const Color(0xFFEEEEEE);
  Color get forgotPasswordGradientTopLeftColor => const Color(0xFFFF9359);
  Color get forgotPasswordGradientBottomRightColor => const Color(0xFFed2b7a);
  Color get forgotPasswordResetColor => const Color(0xFFFFFFFF);

  Color get connectorTitleColor => const Color(0xFFFFFFFF);
  Color get connectorUserIdTextColor => const Color(0xFFFFFFFF);
  Color get connectorTextInputColor => const Color(0xFFEEEEEE);
  Color get connectorConnectColor => const Color(0xFFFFFFFF);
  Color get connectorUserIdBackgroundColor => const Color(0x00FFFFFF);
  Color get connectorIdFirstHalfColor => const Color(0xFFFFFFFF);
  Color get connectorIdSecondHalfColor => const Color(0xFFFFFFFF);
  Color get connectorPartnerIdTextColor => const Color(0xFFFFFFFF);
  Color get connectorConnectButtonColor => const Color(0xFFFFFFFF);

  Color get homeTitleColor => const Color(0xFF000000);
  Color get homeTitleBackgroundColor => const Color(0x00FFFFFF);
  Color get homeMessageContainerBackroundColor => const Color(0xFFFFFFFF);
  Color get homeMessageBarBackgroundColor => const Color(0x85d6296f);
  Color get homeMessageBarSendIconColor => const Color(0xFFFFFFFF);
  Color get homeSignOutIconColor => const Color(0xFF000000);
}

extension CustomFontSizes on TextTheme {
  //double get 'name' => 'fontSizeValue';
  double get loginTitleIsSignInFontSize => 65.0;
  double get loginTitleIsSignInFalseFontSize => 40.0;
  double get loginTextInputFontSize => 22.0;
  double get loginSignInSignUpButtonText => 22.5;
  double get loginSignInSignUpAlternateTextFontSize => 15.0;
  double get loginForgotPasswordButtonFontSize => 15.0;
  double get loginErrorMessageFontSize => 13.0;

  double get forgotPaswordTitleFontSize => 37.0;
  double get forgotPasswordTextInputFontSize => 22.0;
  double get forgotPasswordResetFontSize => 24.0;

  double get connectorUserIdTextFontSize => 37.0;
  double get connectorTextInputFontSize => 22.0;
  double get connectorIdFirstHalfFontSize => 24.0;
  double get connectorIdSecondHalfFontSize => 24.0;
  double get connectorPartnerIdTextFontSize => 37.0;

  double get homeTitleFontSize => 32.0;
}

extension CustomFontWeights on Typography {
  //Fontweight get 'name' => 'fontWeightValue'
  FontWeight get loginTitleFontWeight => FontWeight.w600;
  FontWeight get loginSignInSignUpButtonFontWeight => FontWeight.w600;
  FontWeight get loginSignInSignUpAlternateTextFontWeight => FontWeight.w600;
  FontWeight get loginForgotPasswordButtonFontWeight => FontWeight.w400;
  FontWeight get loginErrorMessageFontWeight => FontWeight.w300;

  FontWeight get forgotPasswordTitleFontWeight => FontWeight.w600;

  FontWeight get connectorUserIdTextFontWeight => FontWeight.w600;
  FontWeight get connectorPartnerIdTextFontWeight => FontWeight.w600;
}

extension CustomSizes on MaterialTapTargetSize {
  //double get 'name' => 'customDimensionValue';
  double get interfaceStandardsBackButtonSize => 35.0;

  double get loginSignInSignUpButtonHeight => 50.0;
  double get loginErrorMessageHeight => 1.0;

  double get connectorConnectButtonSize => 65.0;

  double get homeMessageBarSendButtonSize => 35.0;
  double get homeSignOutButtonSize => 35.0;
}

extension CustomDimensions on MaterialTapTargetSize {
  double dimension({String selection, bool isHeight}) {
    switch (selection) {
      //case 'name': return isHeight ? 'height' : 'width'; break;
      case "interfaceStandardsParentCenterContainerDimension": return isHeight ? null : 1.0; break;

      case "loginContainerDimension": return isHeight ? 1.0 : null; break;
      case "loginProgressContainerDimension": return isHeight? 0.0 : 0.0; break;
      case "loginSignInSignUpButtonDimension": return isHeight ? null : 0.375; break;

      case "forgotPasswordContainerDimension": return isHeight ? 1.0 : null; break;
      case "forgotPasswordSendButtonDimension": return isHeight ? null: 1.0; break;

      case "connectorContainerDimension": return isHeight ? 1.0 : null; break;

      case "homeContainerDimension": return isHeight ?  1.0 : 1.0; break;
    }
  }
}

extension CustomPositions on MaterialTapTargetSize {
  double position({String selection, bool isTop}) {
    switch (selection) {
      //case 'name': return isTop ? 'top' : 'left'; break;
      case "loginSignInSignUpAlternateTextIsSignInPosition": return isTop ? 0.525 : 0.8; break;
      case "loginSignInSignUpAlternateTextIsSignInFalsePosition": return isTop ? 0.56 : 0.8; break;
      case "loginProgressPosition": return isTop ? 0.8 : null; break;

      case "forgotPasswordTitlePosition": return isTop ?  0.35 : 0.15; break;
      case "forgotPasswordBackButtonPosition": return isTop ? 0.06 : 0.06; break;
      case "forgotPasswordSendButtonPosition": return isTop ? 0.675 : null; break;

      case "connectorContainerPosition": return isTop ? 0.23 : null; break;
      case "connectorIdFirstHalfPosition": return isTop ? 0.315 : null; break;
      case "connectorIdSecondHalfPosition": return isTop ? 0.365 : null; break;
      case "connectorPartnerIdTextPosition": return isTop ? 0.475 : null; break;
      case "connectorConnectButtonPosition": return isTop? 0.72 : null; break;
    }
  }
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

  //Mechanics: Get dimension value
  double getDimension(BuildContext context, bool _isHeight, String _selection) {
    double value = _isHeight ? 
      MediaQuery.of(context).size.height * Theme.of(context).materialTapTargetSize.dimension(selection: _selection, isHeight: _isHeight) :
      MediaQuery.of(context).size.width * Theme.of(context).materialTapTargetSize.dimension(selection: _selection, isHeight: _isHeight);
    return value;
  }

  //Mechanics: Get position value
  double getPosition(BuildContext context, bool _isTop, String _selection) {
    double value = _isTop ? 
      MediaQuery.of(context).size.height * Theme.of(context).materialTapTargetSize.position(selection: _selection, isTop: _isTop) :
      MediaQuery.of(context).size.width * Theme.of(context).materialTapTargetSize.position(selection: _selection, isTop: _isTop);
    return value;
  }
}