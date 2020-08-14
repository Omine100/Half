import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/pages/login.dart';
import 'package:half/pages/connector.dart';
import 'package:half/pages/home.dart';

//Status declaration
enum AuthStatus {
  NOT_DETERMINED,
  NOT_SIGNED_IN,
  SIGNED_IN,
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
    super.initState();
    cloudFirestore.getCurrentUser().then((userId) {
      setState(() {
        if (userId != null) {
          _userId = userId?.uid;
        }
        _authStatus = userId?.uid == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  //Mechanics: Sets status to logged in with current user
  void loginCallback() {
    cloudFirestore.getCurrentUserId().then((userId) {
      cloudFirestore.getPartnerData().then((partnerId) {
        cloudFirestore.getPartnerNameData().then((partnerName) {
          setState(() {
            _userId = userId.toString();
            _partnerId = partnerId.toString();
            _partnerName = partnerName.toString();
            print("Root page userId: " + _userId);
            print("Root page partnerId: " + _partnerId);
            print("Root page partnerName: " + _partnerName);
          });
        });
      });
    });
    setState(() {
      _authStatus = AuthStatus.SIGNED_IN;
    });
  }

  //Mechanics: Sets status to logged out
  void logoutCallback() {
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
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.SIGNED_IN:
        if (_userId.length > 0 && _userId != null) {
          if (_partnerId.length > 0 && _partnerId != null && _partnerId != "null") {
            return new HomeScreen(
              logoutCallback: logoutCallback,
              userId: _userId,
              partnerId: _partnerId,
              partnerName: _partnerName,
            );
          } else {
            return new ConnectorScreen(
              logoutCallback: logoutCallback,
              userId: _userId,
              partnerId: _partnerId,
              partnerName: _partnerName,
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