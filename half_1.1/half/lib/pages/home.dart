import 'package:flutter/material.dart';

import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.logoutCallback, this.userId});

  //Variable reference
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Variable initialization
  Themes themes = new Themes();

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Text(
          "Testing",
          style: TextStyle(
            color: Theme.of(context).colorScheme.title,
            fontSize: Theme.of(context).textTheme.titleFontSize,
          ),
        ),
      ),
    );
  }
}