import 'package:flutter/material.dart';

import 'package:half/services/themes.dart';

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
        color: Theme.of(context).colorScheme.backButtonColor,
        size: Theme.of(context).materialTapTargetSize.backButtonSize,
      ),
    );
  }

  //User interface: Text linear gradient
  Shader textLinearGradient(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).colorScheme.gradientTopLeftColor, Theme.of(context).colorScheme.gradientBottomRightColor],
    ).createShader(Rect.fromLTWH(110.0, 100.0, 200.0, 70.0));
    return linearGradient;
  }

  //Mechanics: Returns gradient colors
  List<Color> colorsBodyGradient(BuildContext context, bool isTitle) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.gradientTopLeftColor,
      isTitle ? Theme.of(context).colorScheme.gradientBottomRightColor : Theme.of(context).colorScheme.gradientBottomRightColor,
    ];
    return gradientColors;
  }

  //User interface: Body linear gradient
  LinearGradient bodyLinearGradient(BuildContext context, bool isSmall, bool isTitle) {
    final LinearGradient linearGradient = LinearGradient(
      begin: isSmall ? Alignment.centerLeft : Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: colorsBodyGradient(context, isTitle),
    );
    return linearGradient;
  }

  //User interface: Parent center
  Widget parentCenter(BuildContext context, Widget child) {
    return Container(
      width: themes.getDimension(context, false, "parentCenterContainerDimension"),
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
          color: Theme.of(context).colorScheme.headerTextColor,
          fontSize: 45.0,
        ),),
    );
  }
}