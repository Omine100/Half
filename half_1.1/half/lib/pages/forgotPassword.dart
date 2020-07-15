import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';
import 'package:half/widgets/interfaceStandards.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  final _formKey = GlobalKey<FormState>();
  String _email;

  //User interface: Show email input
  Widget showEmailInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).colorScheme.forgotPasswordTextInput,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.forgotPasswordTextInput,
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.forgotPasswordTextInput,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.forgotPasswordTextInput,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.forgotPasswordTextInput,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.forgotPasswordTextInput,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ?"Email can\'t be empty" : null,
      onSaved: (value) => _email = value.trim(),
      obscureText: false,
      maxLines: 1,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, false, false),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              left: MediaQuery.of(context).size.width * 0.06,
              child: interfaceStandards.backButton(context),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: MediaQuery.of(context).size.width * 0.15,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.forgotPasswordTitle,
                  fontSize: 37.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), //Forgot Password text
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 400.0),
                child: showEmailInput(),
              ),
            ), //showEmailInput()
            Positioned(
                top: MediaQuery.of(context).size.height * 0.675,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // widget.auth.sendPasswordReset(_email);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.forgotPasswordReset,
                          fontSize: Theme.of(context).textTheme.forgotPasswordResetFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
            ), //Reset Password button
          ],
        ),
      ),
    );
  }
}