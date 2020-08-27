import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/pages/signIn.dart';
import 'package:half/pages/connector.dart';
import 'package:half/pages/home.dart';

//Status declaration
enum AuthStatus {
  NOT_DETERMINED,
  NOT_SIGNED_IN,
  SIGNED_IN,
  REMOVED,
}

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  final db = Firestore.instance;
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "", _partnerId = "", _partnerName = "";

  //Initial state
  @override
  void initState() {
    _userId = ""; //Maybe don't need this
    _partnerId = ""; //^
    _partnerName = ""; //^
    super.initState();
    cloudFirestore.getCurrentUser().then((userId) {
      setState(() {
        signInCallback();
        _authStatus = userId?.uid == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  //Mechanics: Sets status to logged in with current user
  void signInCallback() {
    cloudFirestore.getCurrentUserId().then((userId) {
      cloudFirestore.getPartnerData().then((partnerId) {
        cloudFirestore.getPartnerNameData().then((partnerName) {
          setState(() {
            _userId = userId;
            _partnerId = partnerId;
            _partnerName = partnerName;
            print("UserId: " + userId.toString());
            print("PartnerId: " + partnerId.toString());
            print("PartnerName: " + partnerName.toString());
            _authStatus = AuthStatus.SIGNED_IN;
          });
        });
      });
    });
  }

  //Mechanics: Sets status to logged out
  void signOutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_SIGNED_IN;
      _userId = "";
    });
  }

  //User interface: Builds circular progress indicator with animation
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  //User interface: Root screen
  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_SIGNED_IN:
        return new LoginScreen(
          signInCallback: signInCallback,
        );
        break;
      case AuthStatus.SIGNED_IN:
        if (_userId != null) {
          if (_partnerId != null && _partnerId != "null") {
            return new HomeScreen(
              signInCallback: signInCallback,
              signOutCallback: signOutCallback,
              userId: _userId,
              partnerId: _partnerId,
              partnerName: _partnerName,
            );
          } else {
            return new ConnectorScreen(
              signInCallback: signInCallback,
              userId: _userId,
            );
          }
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}