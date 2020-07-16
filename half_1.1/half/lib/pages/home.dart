import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';
import 'package:half/widgets/interfaceStandards.dart';

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
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  String _partnerName = "";

  //Initial state
  @override
  void initState() {
    super.initState();
    String _partnerUserId;
    cloudFirestore.readPartnerData(widget.userId).then((partnerId) => 
      _partnerUserId = partnerId,
    );
    cloudFirestore.readNameData(_partnerUserId).then((name) {
      setState(() {
        _partnerName = name;
      });
    });
  }

  //User interface: Show title
  Container showTitle() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.2,
      color: Theme.of(context).colorScheme.homeTitleBackground,
      child: Text(
        _partnerName,
        style: TextStyle(
          color: Theme.of(context).colorScheme.homeTitle,
          fontSize: Theme.of(context).textTheme.homeTitleFontSize,
        ),
      ),
    );
  }

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Text("Testing"),
        ],
      ),
    );
  }
}