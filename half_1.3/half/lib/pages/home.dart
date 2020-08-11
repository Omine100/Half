import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.logoutCallback, this.userId, this.partnerId, this.partnerName});

  //Variable reference
  final VoidCallback logoutCallback;
  final String userId;
  final String partnerId;
  final String partnerName;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Text(
          "Testing",
        ),
      ),
    );
  }
}