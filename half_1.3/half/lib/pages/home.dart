import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.signOutCallback, this.userId, this.partnerId, this.partnerName});

  //Variable reference
  final VoidCallback signOutCallback;
  final String userId;
  final String partnerId;
  final String partnerName;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: () {
            widget.signOutCallback;
            cloudFirestore.signOut();
            Navigator.of(context)
              .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
          },
          child: Text(
            widget.partnerName,
            style: TextStyle(
              fontSize: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}