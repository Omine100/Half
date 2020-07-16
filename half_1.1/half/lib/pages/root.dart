import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/pages/login.dart';
import 'package:half/pages/connector.dart';
import 'package:half/pages/home.dart';

//Status declaration
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
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
  String _userId = "";

  //Initial state
  @override
  void initState() {
    super.initState();
    cloudFirestore.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        _authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  //Mechanics: Sets status to logged in with current user
  void loginCallback() {
    cloudFirestore.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
  }

  //Mechanics: Sets status to logged out
  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
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
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginScreen(
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          if (cloudFirestore.readPartnerData(_userId) != null) {
            return new HomeScreen(
              logoutCallback: logoutCallback,
              userId: _userId,
            );
          } else {
            return new ConnectorScreen(
              logoutCallback: logoutCallback,
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