import 'package:flutter/material.dart';

import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';

class InterfaceStandards {
  //Variable initialization
  Themes themes = new Themes();

  //User interface: Back button
  Widget backButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.keyboard_backspace,
        color: Theme.of(context).colorScheme.backButton,
        size: Theme.of(context).materialTapTargetSize.backButtonSize,
      ),
    );
  }

  //User interface: Text linear gradient
  Shader textLinearGradient(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).colorScheme.loginGradientTopLeft, Theme.of(context).colorScheme.loginGradientBottomRight],
    ).createShader(Rect.fromLTWH(110.0, 100.0, 200.0, 70.0));
    return linearGradient;
  }

  //Mechanics: Returns gradient colors
  List<Color> colorsBodyGradient(BuildContext context, bool isTitle) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.loginGradientTopLeft,
      isTitle ? Theme.of(context).colorScheme.loginGradientTopLeft : Theme.of(context).colorScheme.loginGradientBottomRight,
    ];
    return gradientColors;
  }

  //User interface: Body linear gradient
  LinearGradient bodyLinearGradient(BuildContext context, bool isSmall, bool isTitle) {
    final LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: isSmall ? Alignment.centerRight : Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: colorsBodyGradient(context, isTitle),
    );
    return linearGradient;
  }

  //User interface: Parent center
  Widget parentCenter(BuildContext context, Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: child,
      ),
    );
  }

  //User interface: Header text
  Widget headerText(BuildContext context, String header) {
    return parentCenter(context,
      Text(
        header,
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontSize: 45.0,
        ),),
    );
  }
}