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
      height: MediaQuery.of(context).size.height * 0.175,
      color: Theme.of(context).colorScheme.homeTitleBackground,
      child: interfaceStandards.parentCenter(context, Text(
          "Haley Kirby",
          style: TextStyle(
            color: Theme.of(context).colorScheme.homeTitle,
            fontSize: Theme.of(context).textTheme.homeTitleFontSize,
          ),
        ),
      ),
    );
  }

  //User interface: Show message container
  Container showMessageContainer() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.915,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.homeMessageContainerBackround,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35.0),
          bottomRight: Radius.circular(35.0),
        ),
      ),
    );
  }

  //User interface: Show message bar
  Widget showMessageBar() {
    return interfaceStandards.parentCenter(context,
      new Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.homeMessageBarBackground,
          borderRadius: BorderRadius.all(Radius.circular(35.0),),
        ),
      ),
    );
  }

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, true, true),
        ),
        child: Stack(
          children: <Widget>[
            showMessageContainer(),
            showTitle(),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.93,
              child: showMessageBar(),
            ),
          ],
        ),
      ),
    );
  }
}