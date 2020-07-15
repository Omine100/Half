import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/services/dimensions.dart';
import 'package:half/widgets/interfaceStandards.dart';
import 'package:half/pages/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _errorMessage;
  bool _isLoading, _isSignIn, _isVisible;

  //Initial state
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isSignIn = true;
    super.initState();
  }

  //Mechanics: Validate and save user information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //Mechanics: Validate and submit user information
  //Need to get the name thing set up now
  //Most of this should be done in the cloudFirestore.dart file
  //Calls should mainly be the thing here
  void validateAndSubmit(bool isSignIn) async {}

  //Mechanics: Reset the form
  void resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _errorMessage = "";
    });
  }

  //User interface: Show sign in or sign up input fields
  Widget showInput(BuildContext context, String text) {
    return new TextFormField(
      keyboardType: text == "Email" ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.textInput,
        fontSize: Theme.of(context).textTheme.textInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          text != "Email" ? text == "Password" ?
            Icons.lock :
            Icons.person :
            Icons.email,
          color: Theme.of(context).colorScheme.textInput,
        ),
        hintText: text,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.textInput,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.textInput,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textInput,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.textInput,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ? "$text can\'t be empty" : null,
      onSaved: (value) => text != "Email" ? text == "Password" ?
        _password = value.trim() :
        _name = value.trim() :
        _email = value.trim(),
      obscureText: text == "Password" ? (_isVisible ? false : true) : false,
      maxLines: 1,
    );
  }

  //User interface: Show visible button
  Widget showVisibleButton() {
    return GestureDetector(
      onTap: () {
        _isVisible = !_isVisible;
      },
      child: Icon(
        _isVisible ? Icons.visibility : Icons.visibility_off,
      ),
    );
  }

  //User interface: Login screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Text(
          "Testing",
        ),
      ),
    );
  }
}