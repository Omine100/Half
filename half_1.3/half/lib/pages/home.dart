import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.signInCallback, this.signOutCallback, this.userId, this.partnerId, this.partnerName});

  //Variable reference
  final VoidCallback signInCallback;
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
      body: Container(),
    );
  }
}