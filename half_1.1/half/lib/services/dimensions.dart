import 'package:flutter/material.dart';

class Dimensions {
  double getDimensions(String interfaceName, bool isHeight, BuildContext context) {
    switch (interfaceName) {
      case "backButtonSize": {
        return MediaQuery.of(context).size.height * 0.01;
        break;
      }
    }
  }
}