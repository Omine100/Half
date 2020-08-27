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
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _message, _timeStampOld, _timeStampNew, _timeStampCurrent, _selection;
  bool _isUser;

  //Mechanics: getTimeStamp
  String getTimeStamp() {
    int monthCurrent = int.parse(_timeStampCurrent.substring(5, 7));
    int dayCurrent = int.parse(_timeStampCurrent.substring(8, 10));
    int hourCurrent = int.parse(_timeStampCurrent.substring(11, 13));
    int minuteCurrent = int.parse(_timeStampCurrent.substring(14, 16));
    int monthNew = int.parse(_timeStampNew.substring(5, 7));
    int hourNew = int.parse(_timeStampNew.substring(11, 13));
    int dayNew = int.parse(_timeStampNew.substring(8, 10));
    int minuteNew = int.parse(_timeStampNew.substring(14, 16));
    int dayOld = int.parse(_timeStampOld.substring(8, 10));
    int hourOld = int.parse(_timeStampOld.substring(11, 13));
    int minuteOld = int.parse(_timeStampOld.substring(14, 16));

    if (dayCurrent - dayNew != 0) {
      if (dayNew - dayOld == 0) {
        return "";
      } else if ((hourNew - hourOld == 0 && minuteNew - minuteOld < 30) || (hourNew - hourOld == -1 && minuteNew - minuteOld > -30)) {
        return "";
      } else if (dayNew - dayOld != 0) {
        return getDay(monthNew, dayNew);
      }
    } else if (dayNew - dayOld != 0) {
      return getTime(hourNew, minuteNew);
    } else {
      if (hourNew - hourOld != 0) {
        return getTime(hourNew, minuteNew);
      } else if (minuteNew - minuteOld > 30){
        return getTime(hourNew, minuteNew);
      } else {
        return "";
      }
    }
  }

  //Mechanics: Get day
  String getDay(int monthNew, dayNew) {
    List months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    String month = months[monthNew - 1];
    return month + " " + dayNew.toString();
  }

  //Mechanics: Get time
  String getTime(int hourNew, int minuteNew) {
    String minute;
    if (minuteNew - 10 < 0) {
      minute = "0$minuteNew";
    } else {
      minute = minuteNew.toString();
    }

    if (hourNew == 00) {
      return 12.toString() + ":" + minute + " AM";
    } else if (hourNew > 12) {
      return (hourNew - 12).toString() + ":" + minute + " PM";
    }
    return "$hourNew:$minute AM";
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

  //User interface: Show title
  Widget showTitle() {
    return new Container(
      height: themes.getDimension(context, true, "homeTitleContainerDimension"),
      color: Theme.of(context).colorScheme.homeTitleContainerColor,
      child: interfaceStandards.parentCenter(context, 
        Column(
          children: <Widget> [
            SizedBox(
              height: themes.getDimension(context, true, "homeTitleContainerSizedBox1Dimension"),
            ),
            Text(
              widget.partnerName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.homeTitleColor,
                fontSize: Theme.of(context).textTheme.homeTitleFontSize,
              ),
            ),
            SizedBox(
              height: themes.getDimension(context, true, "homeTitleContainerSizedBox2Dimension"),
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

  //User interface: Show popup menu
  Widget showPopupMenu() {
    return PopupMenuButton<String>(
      child: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.homeSignOutIconButtonColor,
        size: Theme.of(context).materialTapTargetSize.homeSignOutIconButtonSize,
      ),
      onSelected: (String result) { 
        if (result == "Sign Out") {
          widget.signOutCallback;
          cloudFirestore.signOut();
          Navigator.of(context)
            .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
        } else if (result == "Remove Partner") {
          cloudFirestore.deletePartnerData(widget.partnerId);
          widget.signInCallback;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "Sign Out",
          child: Text('Sign Out'),
        ),
        const PopupMenuItem<String>(
          value: "Remove Partner",
          child: Text('Remove Partner'),
        ),
      ],
    );
  }

  //User interface: Show message container
  Widget showMessageContainer() {
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
    return new StreamBuilder(
      stream: db.collection(widget.userId).document("Messages").collection("Complete").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.data.documents.isEmpty) {
          return new Container();
        } else {
          return new ListView(
            padding: EdgeInsets.only(top: 135, bottom: 12.5),
            scrollDirection: Axis.vertical,
            reverse: false,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
            return showMessage(document, document.data["Message"], document.data["User"]);
            }).toList(),
          );
        }
      },
    );
  }

  //User interface: Show message
  Widget showMessage(DocumentSnapshot document, String _retrievedMessage, bool _retrievedIsUser) {
    _timeStampOld = _timeStampNew == null ? "0000-00-00-00:00:00" : _timeStampNew;
    _timeStampNew = document.documentID;
    _timeStampCurrent = interfaceStandards.getCurrentDate();

    return Column(
      children: <Widget>[
        interfaceStandards.parentCenter(context, Text(
          getTimeStamp(),
          style: TextStyle(
            fontSize: getTimeStamp() != "" ? Theme.of(context).textTheme.homeMessageTimeFontSize : 0.0,
          ),
        )),
        Container(
          width: themes.getDimension(context, false, "homeMessageColumnContainerDimension"),
          child: GestureDetector(
            onLongPress: () {
              cloudFirestore.deleteCurrentMessageData(document);
              setState(() {
                print("Deleted");
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: _retrievedIsUser ? 162.5 : 12.5, 
                right: _retrievedIsUser ? 12.5 : 162.5,
                top: 6.25,
                bottom: 6.25,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                ),
                height: themes.getDimension(context, true, "homeMessageDimension"),
                decoration: BoxDecoration(
                  gradient: _retrievedIsUser ? interfaceStandards.cardLinearGradient(context, true) : interfaceStandards.cardLinearGradient(context, false),
                  borderRadius: BorderRadius.only(
                    topLeft: _retrievedIsUser ? Radius.circular(30.0) : Radius.circular(1.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
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
              ),
            ),
          ),
        ),
      ],
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
                  Form(
                    key: _formKey,
                    child: showMessageBar(),
                  ),
                  SizedBox(
                    height: themes.getDimension(context, true, "homeMessageScrollViewSizedBoxDimension"),
                  ),
                ],
              ),
            ),
            showTitle(),
            Positioned(
              top: themes.getPosition(context, true, "homeSignOutIconButtonPosition"),
              left: themes.getPosition(context, false, "homeSignOutIconButtonPosition"),
              child: showPopupMenu(),
            ),
          ],
        ),
      ),
    );
  }
}