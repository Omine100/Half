import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  Themes themes = new Themes();
  Dimensions dimensions = new Dimensions();
  Positions positions = new Positions();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  final _formKey = GlobalKey<FormState>();
  String _email;

  //User interface: Show email input
  Widget showEmailInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
        fontSize: Theme.of(context).textTheme.textInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.forgotPasswordTextInputColor,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ?"Email can\'t be empty" : null,
      onSaved: (value) => _email = value.trim(),
      obscureText: false,
      maxLines: 1,
    );
  }
  
  //User interface: Forgot password screen
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
              top: positions.forgotPasswordBackButtonPosition(context, true),
              left: positions.forgotPasswordBackButtonPosition(context, false),
              child: interfaceStandards.backButton(context),
            ),
            Positioned(
              top: positions.forgotPasswordTitlePosition(context, true),
              left: positions.forgotPasswordTitlePosition(context, false),
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.forgotPasswordTitleColor,
                  fontSize: Theme.of(context).textTheme.forgotPaswordTitleFontSize,
                  fontWeight: Theme.of(context).typography.forgotPasswordTitleFontWeight,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 400.0),
                child: showEmailInput(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.675,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      cloudFirestore.sendPasswordReset(_email);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.forgotPasswordResetColor,
                        fontSize: Theme.of(context).textTheme.forgotPasswordResetFontSize,
                      ),
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