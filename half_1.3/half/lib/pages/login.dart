import 'package:flutter/material.dart';

import 'package:half/services/cloudFirestore.dart';
import 'package:half/services/themes.dart';
import 'package:half/widgets/interfaceStandards.dart';
import 'package:half/pages/forgotPassword.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.loginCallback});

  //Variable reference
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Variable initialization
  CloudFirestore cloudFirestore = new CloudFirestore();
  Themes themes = new Themes();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _errorMessage;
  bool _isLoading, _isSignIn, _isVisible;

  //Initial state
  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isSignIn = true;
    _isLoading = false;
    _isVisible = false;
  }

  //Mechanics: Validate and save user information
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}