import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:half/services/themes.dart';

class ImageViewScreen extends StatefulWidget {
  ImageViewScreen({Key key, this.signInCallback, this.signOutCallback, this.userId, this.partnerId, this.partnerName, this.imageUrl});

  //Variable reference
  final VoidCallback signInCallback;
  final VoidCallback signOutCallback;
  final String userId;
  final String partnerId;
  final String partnerName;
  final String imageUrl;

  @override
  State<StatefulWidget> createState() => new _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  //Variable initialization
  Themes themes = new Themes();

  //Initial state
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  //Dispose state
  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  //User interface: Image view screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.imageViewBackgroundColor,
      body: GestureDetector(
        child: Center(
          child: Image.network(widget.imageUrl)
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}