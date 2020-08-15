import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';
import 'package:half/pages/home.dart';

class ConnectorScreen extends StatefulWidget {
  ConnectorScreen({Key key, this.loginCallback, this.userId});

  //Variable reference
  final VoidCallback loginCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => _ConnectorScreenState();
}

class _ConnectorScreenState extends State<ConnectorScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  Themes themes = new Themes();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  final _formKey = GlobalKey<FormState>();
  String _partnerId;

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
      cloudFirestore.createPartnerData(_partnerId);
      widget.loginCallback();
    } else {
      print("Error: Could not validate and save");
    }
  }

  //User interface: Show partner user id input
  Widget showParterUserIdInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).colorScheme.connectorTextInputColor,
        fontSize: Theme.of(context).textTheme.connectorTextInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.connectorTextInputColor,
        ),
        hintText: "Parter Id",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.connectorTextInputColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.connectorTextInputColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.connectorTextInputColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.connectorTextInputColor,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ?"Partner Id can\'t be empty" : null,
      onSaved: (value) => _partnerId = value.trim(),
      obscureText: false,
      maxLines: 1,
    );
  }

  //User interface: Connector screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: themes.getDimension(context, true, "connectorContainerDimension"),
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, false, false),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: themes.getPosition(context, true, "connectorContainerPosition"),
              child: interfaceStandards.parentCenter(context, 
                Text(
                  "Your Id",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorUserIdTextColor,
                    fontSize: Theme.of(context).textTheme.connectorUserIdTextFontSize,
                    fontWeight: Theme.of(context).typography.connectorUserIdTextFontWeight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: themes.getPosition(context, true, "connectorIdFirstHalfPosition"),
              child: interfaceStandards.parentCenter(context, 
                Text(
                  widget.userId.substring(0, (widget.userId.length / 1.75).toInt()),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorIdFirstHalfColor,
                    fontSize: Theme.of(context).textTheme.connectorIdFirstHalfFontSize,
                  ),
                ),
              ),
            ),
            Positioned(
              top: themes.getPosition(context, true, "connectorIdSecondHalfPosition"),
              child: interfaceStandards.parentCenter(context, 
                Text(
                  widget.userId.substring((widget.userId.length / 1.75).toInt()),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorIdSecondHalfColor,
                    fontSize: Theme.of(context).textTheme.connectorIdSecondHalfFontSize,
                  ),
                ),
              ),
            ),
            Positioned(
              top: themes.getPosition(context, true, "connectorPartnerIdTextPosition"),
              child: interfaceStandards.parentCenter(context, 
                Text(
                  "Partner Id",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.connectorPartnerIdTextColor,
                    fontSize: Theme.of(context).textTheme.connectorPartnerIdTextFontSize,
                    fontWeight: Theme.of(context).typography.connectorPartnerIdTextFontWeight,
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
              top: themes.getPosition(context, true, "connectorConnectButtonPosition"),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      validateAndSubmit();
                    },
                    child: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).colorScheme.connectorConnectButtonColor,
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