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
  Themes themes = new Themes();
  InterfaceStandards interfaceStandards = new InterfaceStandards();

  //User interface: Show title
  Container showTitle() {
    return new Container(
      height: themes.getDimension(context, true, "homeTitleContainerDimension"),
      color: Theme.of(context).colorScheme.homeTitleContainerColor,
      child: interfaceStandards.parentCenter(context, Text(
          widget.partnerName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.homeTitleColor,
            fontSize: Theme.of(context).textTheme.homeTitleFontSize,
          ),
        ),
      ),
    );
  }

  //User interface: Show division bar
  Widget showDivisionBar() {
    return new Divider(
      thickness: 2.5,
      color: Theme.of(context).colorScheme.homeDivisionBarColor,
    );
  }

  //User interface: Show message container
  Container showMessageContainer() {
    return new Container(
      height: themes.getDimension(context, true, "homeMessageContainerDimension"),
      width: themes.getDimension(context, false, "homeMessageContainerDimension"),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.homeMessageContainerColor,
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
        height: themes.getDimension(context, true, "homeMessageBarContainerDimension"),
        width: themes.getDimension(context, false, "homeMessageBarContainerDimension"),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.homeMessageBarContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(35.0),),
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
        color: Theme.of(context).colorScheme.homeMessageBarSendIconButtonColor,
        size: Theme.of(context).materialTapTargetSize.homeMessageBarSendIconButtonSize,
      ),
    );
  }

  //User interface: Show message input field
  Widget showMessageInput(BuildContext context) {
    return new TextFormField();
  }

  //User interface: Show sign out
  Widget showSignOut() {
    return GestureDetector(
      onTap: () {
        widget.signOutCallback;
        cloudFirestore.signOut();
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
      },
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.homeSignOutIconButtonColor,
        size: Theme.of(context).materialTapTargetSize.homeSignOutIconButtonSize,
      ),
    );
  }

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: themes.getDimension(context, true, "homeContainerDimension"),
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, true, true),
        ),
        child: Stack(
          children: <Widget>[
            showMessageContainer(),
            showTitle(),
            Positioned(
              top: themes.getPosition(context, true, "homeDivisionBarPosition"),
              left: themes.getPosition(context, false, "homeDivisionBarPosition"),
              right: themes.getPosition(context, false, "homeDivisionBarPosition"),
              child: showDivisionBar(),
            ),
            Positioned(
              top: themes.getPosition(context, true, "homeMessageBarContainerPosition"),
              child: showMessageBar(),
            ),
            Positioned(
              top: themes.getPosition(context, true, "homeMessageBarSendIconButtonPosition"),
              left: themes.getPosition(context, false, "homeMessageBarSendIconButtonPosition"),
              child: showMessageBarSend(),
            ),
            Positioned(
              top: themes.getPosition(context, true, "homeSignOutIconButtonPosition"),
              left: themes.getPosition(context, false, "homeSignOutIconButtonPosition"),
              child: showSignOut(),
            ),
          ],
        ),
      ),
    );
  }
}