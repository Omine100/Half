import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';
import 'package:half/widgets/interfaceStandards.dart';
import 'package:half/pages/home.dart';

class ConnectorScreen extends StatefulWidget {
  ConnectorScreen({Key key, this.logoutCallback, this.userId, this.partnerId, this.partnerName});

  //Variable reference
  final VoidCallback logoutCallback;
  final String userId;
  final String partnerId;
  final String partnerName;

  @override
  State<StatefulWidget> createState() => _ConnectorScreenState();
}

class _ConnectorScreenState extends State<ConnectorScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  Themes themes = new Themes();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  final _formKey = GlobalKey<FormState>();
  String _partnerUserId;

  //Mechanics: Validate and save user information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //Mechanics: Validate and submit partner user id information
  void validateAndSubmit() {
    if (validateAndSave()) {
      cloudFirestore.createPartnerData(_partnerUserId);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomeScreen(
          logoutCallback: widget.logoutCallback,
          userId: widget.userId,
          partnerId: widget.partnerId,
          partnerName: widget.partnerName,
        ))
      );
    } else {
      print("Error: Could not validate and save");
    }
  }

  //User interface: Show partner user id input
  Widget showParterUserIdInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).colorScheme.connectorTextInput,
        fontSize: Theme.of(context).textTheme.textInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.connectorTextInput,
        ),
        hintText: "Parter Id",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.connectorTextInput,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.connectorTextInput,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.connectorTextInput,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.connectorTextInput,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ?"Partner Id can\'t be empty" : null,
      onSaved: (value) => _partnerUserId = value.trim(),
      obscureText: false,
      maxLines: 1,
    );
  }

  //User interface: Connector screen
  @override
  Widget build(BuildContext context) {
      Future<String> _yourId = Future<String>.delayed(Duration(seconds: 2), () => "Test");

    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, false, false),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.23,
              child: interfaceStandards.parentCenter(context, 
                Text(
                  "Your Id",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorTitle,
                    fontSize: 37.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.315,
              child: interfaceStandards.parentCenter(context, 
                Text(
                  widget.userId.substring(0, (widget.userId.length / 1.75).toInt()),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorTitle,
                    fontSize: Theme.of(context).textTheme.connectorUserIdFontSize,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.365,
              child: interfaceStandards.parentCenter(context, 
                Text(
                  widget.userId.substring((widget.userId.length / 1.75).toInt()),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorTitle,
                    fontSize: Theme.of(context).textTheme.connectorUserIdFontSize,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.475,
              child: interfaceStandards.parentCenter(context, 
                Text(
                  "Partner Id",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorTitle,
                    fontSize: 37.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 450.0),
                child: showParterUserIdInput(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.72,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      validateAndSubmit();
                    },
                    child: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).colorScheme.connectorConnect,
                      size: Theme.of(context).materialTapTargetSize.connectorConnectButtonSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}