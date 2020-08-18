import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final _formKey = GlobalKey<FormState>();
  String _message;
  bool _isUser;

  //User interface: Show title
  Container showTitle() {
    return new Container(
      height: themes.getDimension(context, true, "homeTitleContainerDimension"),
      color: Theme.of(context).colorScheme.homeTitleContainerColor,
      child: interfaceStandards.parentCenter(context, 
        Column(
          children: <Widget> [
            Text(
              widget.partnerName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.homeTitleColor,
                fontSize: Theme.of(context).textTheme.homeTitleFontSize,
              ),
            ),
            SizedBox(
              height: themes.getDimension(context, true, "homeTitleContainerSizedBoxDimension"),
            ),
            Divider(
              thickness: 2.5,
              indent: themes.getPosition(context, false, "homeDivisionBarPosition"),
              endIndent: themes.getPosition(context, false, "homeDivisionBarPosition"),
              color: Theme.of(context).colorScheme.homeDivisionBarColor,
            ),
          ],
        ),
      ),
    );
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

  //Mechanics: Validate and submit message information
  void validateAndSubmit() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      cloudFirestore.createMessageData(widget.partnerId, _message);
      print("Message sent to " + widget.partnerId.toString());
      _formKey.currentState.reset();
    }
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
      child: showMessageList(),
    );
  }

  //User interface: Show message list
  Widget showMessageList() {
    cloudFirestore.getMessageStreamData().then((messageStream) {
      if (messageStream == null) {
        print("It is null");
        return new Container();
      } else {
        print("It is not null");
        return new StreamBuilder(
          stream: messageStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.data.documents.isEmpty) {
              return new Container();
            } else {
              return new ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                return showMessage(document.data["Message"], document.data["User"]);
                }).toList(),
              );
            }
          },
        );
      }
    });
  }

  //User interface: Show message
  Widget showMessage(String _retrievedMessage, bool _retrievedIsUser) {
    print("Message: " + _retrievedMessage);
    return new Container(
      height: 50.0,
      width: 75.0,
      decoration: BoxDecoration(
        gradient: _retrievedIsUser ? interfaceStandards.cardLinearGradient(context, true) : interfaceStandards.cardLinearGradient(context, false),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: _retrievedIsUser ? Radius.circular(30.0) : Radius.circular(1.0),
          bottomRight: _retrievedIsUser ? Radius.circular(1.0) : Radius.circular(30.0),
        ),
      ),
      child: Text(
        _retrievedMessage,
        style: TextStyle(
          color: _retrievedIsUser ? Theme.of(context).colorScheme.homeMessageUserTextColor : Theme.of(context).colorScheme.homeMessageNotUserTextColor,
          fontSize: Theme.of(context).textTheme.homeMessageTextFontSize,
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
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 22.5,
                left: 5.0
              ),
              child: showMessageBarInput(context),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 2.5,
                left: 0.0
              ),
              child: GestureDetector(
                onTap: () {
                  validateAndSubmit();
                },
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.homeMessageBarSendIconButtonColor,
                  size: Theme.of(context).materialTapTargetSize.homeMessageBarSendIconButtonSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //User interface: Show message input field
  Widget showMessageBarInput(BuildContext context) {
    return Container(
      width: themes.getDimension(context, true, "homeMessageBarInputContainerDimension"),
      child: new TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.homeTextInputColor,
          fontSize: Theme.of(context).textTheme.homeTextInputFontSize
        ),
        decoration: InputDecoration(
          hintText: "Message",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.homeTextInputColor,
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.homeTextInputColor,
          ),
          border: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
          disabledBorder: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
          errorBorder: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(
            width: themes.getDimension(context, false, "homeTextInputBorderDimension"), 
            color: Theme.of(context).colorScheme.homeTextInputBorderColor)),
        ),
        validator: (message) => message.isEmpty ? "Message can\'t be empty" : null,
        onSaved: (message) => _message = message.trim(),
        obscureText: false,
        maxLines: 1,
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
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  showMessageContainer(),
                  SizedBox(
                    height: themes.getDimension(context, true, "homeMessageScrollViewSizedBoxDimension"),
                  ),
                  showMessageBar(),
                  SizedBox(
                    height: themes.getDimension(context, true, "homeMessageScrollViewSizedBoxDimension"),
                  ),
                ],
              ),
            ),
            Positioned(
              top: themes.getPosition(context, true, "homeTitlePosition"),
              child: showTitle(),
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