import 'package:flutter/material.dart';

import 'package:half/services/themes.dart';
import 'package:half/pages/login.dart';

//Mechanics: Run Half
void main() {
  runApp(new Half());
}

class Half extends StatelessWidget {
  //Variable initiailization
  Themes themes = new Themes();

  //User interface: Half app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Half",
      debugShowCheckedModeBanner: false,
      routes: {
        '/LoginScreen': (context) => LoginScreen(),
      },
      initialRoute: '/LoginScreen',
      theme: themes.lightTheme(),
      darkTheme: themes.darkTheme(),
    );
  }
}