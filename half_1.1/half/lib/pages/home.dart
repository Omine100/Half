import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';
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
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();

  //Initial state
  @override
  void initState() {
    super.initState();
    cloudFirestore.readPartnerData("b9wW0V4Rq2Wq8L3676v9Pky0i2D2").then((value) {
      print("PartnerId: " + widget.partnerId);
    });
    print("UserId: " + widget.userId);
    print("PartnerId: " + widget.partnerId);
    print("Partner name: " + widget.partnerName);
  }

  //User interface: Show title
  Container showTitle() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.175,
      color: Theme.of(context).colorScheme.homeTitleBackground,
      child: interfaceStandards.parentCenter(context, Text(
          "Test",
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

  //User interface: Show message bar send button
  GestureDetector showMessageBarSend() {
    return new GestureDetector(
      onTap: () {
        print("Message sent");
      },
      child: Icon(
        Icons.send,
        color: Theme.of(context).colorScheme.homeMessageBarSendIcon,
        size: Theme.of(context).materialTapTargetSize.homeMessageBarSendButtonSize,
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

  //User interface: Show sign out
  Widget showSignOut() {
    return GestureDetector(
      onTap: () {
        widget.logoutCallback;
        cloudFirestore.signOut();
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
      },
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.homeSignOutIcon,
        size: Theme.of(context).materialTapTargetSize.homeSignOutButtonSize,
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.94,
              left: MediaQuery.of(context).size.width - 70.0,
              child: showMessageBarSend(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07,
              left: MediaQuery.of(context).size.width * 0.875,
              child: showSignOut(),
            ),
          ],
        ),
      ),
    );
  }
}