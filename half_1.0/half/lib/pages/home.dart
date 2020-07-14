import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:half/services/themes.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key});

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Variable initialization
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  Themes themes = new Themes();

  //State initialization
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message){
        print('on Launch $message');
      },
      onMessage: (Map<String, dynamic> message){
        print('on Message: $message');
      },
      onResume: (Map<String, dynamic> message){
        print('on Resume: $message');
      }
    );
    _firebaseMessaging.getToken().then((token){
        print(token);
    });
  }

  //User interface: Home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Text(
          "Testing",
          style: TextStyle(
            fontSize: 48.0,
            color: Theme.of(context).colorScheme.title,
          ),
        ),
      ),
    );
  }
}