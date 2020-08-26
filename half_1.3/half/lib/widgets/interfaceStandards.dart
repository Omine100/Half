import 'package:flutter/material.dart';

import 'package:half/services/themes.dart';

class InterfaceStandards {
  //Variable initialization
  Themes themes = new Themes();

  //Mechanics: Returns current time
  String getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}-${dateParse.hour}-${dateParse.minute}-${dateParse.second}".toString();
    return formattedDate;
  }

  //User interface: Back button
  Widget backButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.keyboard_backspace,
        color: Theme.of(context).colorScheme.interfaceStandardsBackButtonColor,
        size: Theme.of(context).materialTapTargetSize.interfaceStandardsBackButtonSize,
      ),
    );
  }

  //User interface: Text linear gradient
  Shader textLinearGradient(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).colorScheme.interfaceStandardsGradientTopLeftColor, Theme.of(context).colorScheme.interfaceStandardsGradientBottomRightColor],
    ).createShader(Rect.fromLTWH(110.0, 100.0, 200.0, 70.0));
    return linearGradient;
  }

  //Mechanics: Returns gradient colors body
  List<Color> colorsBodyGradient(BuildContext context, bool isTitle) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.interfaceStandardsGradientTopLeftColor,
      isTitle ? Theme.of(context).colorScheme.interfaceStandardsGradientBottomRightColor : Theme.of(context).colorScheme.interfaceStandardsGradientBottomRightColor,
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

  //Mechanics: Returns gradient colors card
  List<Color> colorsCardGradient(BuildContext context, bool isUser) {
    List<Color> gradientColors = [
      isUser ? Theme.of(context).colorScheme.interfaceStandardsUserCardGradientTopLeftColor : Theme.of(context).colorScheme.interfaceStandardsNotUserCardGradientTopLeftColor,
      isUser ? Theme.of(context).colorScheme.interfaceStandardsUserCardGradientBottomRightColor : Theme.of(context).colorScheme.interfaceStandardsNotUserCardGradientBottomRightColor,
    ];
    return gradientColors;
  }

  //User interface: Card linear gradient 
  LinearGradient cardLinearGradient(BuildContext context, bool isUser) {
    final LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: colorsCardGradient(context, isUser),
    );
    return linearGradient;
  }

  //User interface: Parent center
  Widget parentCenter(BuildContext context, Widget child) {
    return Container(
      width: themes.getDimension(context, false, "interfaceStandardsParentCenterContainerDimension"),
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
          color: Theme.of(context).colorScheme.interfaceStandardsHeaderTextColor,
          fontSize: 45.0,
        ),
      ),
    );
  }
}