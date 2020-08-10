import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get 'name' => const Color(0x'hexValue');
  Color get interfaceStandardsBackButtonColor => const Color(0xFFFFFFFF);
  Color get interfaceStandardsGradientTopLeftColor => const Color(0xFFFF9359);
  Color get interfaceStandardsGradientBottomRightColor => const Color(0xFFed2b7a);
  Color get interfaceStandardsHeaderTextColor => const Color(0xFFFFFFFF);

  Color get loginTitleColor => const Color(0xFFFFFFFF);
  Color get loginTextInputColor => const Color(0xFFEEEEEE);

  Color get forgotPasswordTitleColor => const Color(0xFFFFFFFF);
  Color get forgotPasswordTextInputColor => const Color(0xFFEEEEEE);
  Color get forgotPasswordGradientTopLeftColor => const Color(0xFFFF9359);
  Color get forgotPasswordGradientBottomRightColor => const Color(0xFFed2b7a);
  Color get forgotPasswordResetColor => const Color(0xFFFFFFFF);

  Color get connectorTitleColor => const Color(0xFFFFFFFF);
  Color get connectorTextInputColor => const Color(0xFFEEEEEE);
  Color get connectorConnectColor => const Color(0xFFFFFFFF);
  Color get connectorUserIdBackgroundColor => const Color(0x00FFFFFF);

  Color get homeTitleColor => const Color(0xFF000000);
  Color get homeTitleBackgroundColor => const Color(0x00FFFFFF);
  Color get homeMessageContainerBackroundColor => const Color(0xFFFFFFFF);
  Color get homeMessageBarBackgroundColor => const Color(0x85d6296f);
  Color get homeMessageBarSendIconColor => const Color(0xFFFFFFFF);
  Color get homeSignOutIconColor => const Color(0xFF000000);
}

extension CustomFontSizes on TextTheme {
  //double get 'name' => 'fontSizeValue';
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
  double get interfaceStandardsBackButtonSize => 35.0;

  double get connectorConnectButtonSize => 65.0;

  double get homeMessageBarSendButtonSize => 35.0;
  double get homeSignOutButtonSize => 35.0;
}

extension CustomDimensions on MaterialTapTargetSize {
  double dimension({String selection, bool isHeight}) {
    switch (selection) {
      //case 'name': return isHeight ? 'height' : 'width'; break;
      case "parentCenterContainerDimension": return isHeight ? null : 1.0; break;

      case "forgotPasswordContainerDimension": return isHeight ? 1.0 : null; break;
      case "forgotPasswordSendButtonDimension": return isHeight ? null: 1.0; break;

      case "homeContainerDimension": return isHeight ?  1.0 : 1.0; break;
    }
  }
}

extension CustomPositions on MaterialTapTargetSize {
  double position({String selection, bool isTop}) {
    switch (selection) {
      //case 'name': return isTop ? 'top' : 'left'; break;
      case "forgotPasswordTitlePosition": return isTop ?  0.35 : 0.15; break;
      case "forgotPasswordBackButtonPosition": return isTop ? 0.6 : 0.6; break;
      case "forgotPasswordSendButtonPosition": return isTop ? 0.675 : null; break;
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
    double value = MediaQuery.of(context).size.height * Theme.of(context).materialTapTargetSize.dimension(selection: _selection, isHeight: _isHeight);
    return value;
  }

  //Mechanics: Get position value
  double getPosition(BuildContext context, bool _isTop, String _selection) {
    double value = MediaQuery.of(context).size.height * Theme.of(context).materialTapTargetSize.position(selection: _selection, isTop: _isTop);
    return value;
  }
}