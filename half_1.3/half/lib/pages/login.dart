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

  //Mechanics: Reset the form
  void resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _errorMessage = "";
    });
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

  //Mechanics: Validate and submit user information
  void validateAndSubmit(bool isSignIn) async {}

  //User interface: Show sign in or sign up input fields
  Widget showInput(BuildContext context, String text) {
    return new TextFormField(
      keyboardType: text == "Email" ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.loginTextInputColor,
        fontSize: Theme.of(context).textTheme.loginTextInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          text != "Email" ? text == "Password" ?
            Icons.lock :
            Icons.person :
            Icons.email,
          color: Theme.of(context).colorScheme.loginTextInputColor,
        ),
        hintText: text,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.loginTextInputColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.loginTextInputColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.loginTextInputColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.loginTextInputColor,
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
        setState(() {
          _isVisible = !_isVisible;
        });
      },
      child: Icon(
        _isVisible ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).colorScheme.loginTitleColor,
      ),
    );
  }

  //User interface: Show progress
  Widget showProgress(bool isLoading) {
    if (isLoading) {
      return new CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.loginTitleColor,
      );
    }
    return Container(
      height: themes.getDimension(context, true, "loginProgressContainerDimension"),
      width: themes.getDimension(context, false, "loginProgressContainerDimension"),
    );
  }

  //Start here with the new themes

  //User interface: Show sign in or sign up button
  Widget showSignInSignUpButton(bool isSignIn, Shader linearGradient) {
    return new Container(
      height: Theme.of(context).materialTapTargetSize.loginSignInSignUpButtonHeight,
      width: themes.getDimension(context, false, "loginSignInSignUpButtonDimension"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30.0
        ),
        color: Theme.of(context).colorScheme.loginSignInSignUpButtonColor,
      ),
      child: Center(
        child: Text(
          isSignIn ? "LOGIN" : "SIGN UP",
          style: TextStyle(
            foreground: Paint()
              ..shader = linearGradient,
            fontSize: Theme.of(context).textTheme.loginSignInSignUpButtonText,
            fontWeight: Theme.of(context).typography.loginSignInSignUpButtonFontWeight,
          ),
        ),
      ),
    );
  }

  //User interface: Show sign in or sign up alternate text
  Widget showSignInSignUpAlternateText(bool isSignIn) {
    return RichText(
      text: TextSpan(
        text: !isSignIn ? "Already have an account? " : "Don't have an account? ",
        style: TextStyle(
          color: Theme.of(context).colorScheme.loginSignInSignUpAlternateTextColor,
          fontSize: Theme.of(context).textTheme.loginSignInSignUpAlternateTextFontSize,
        ),
        children: <TextSpan>[
          TextSpan(
            text: !isSignIn ? "Sign In" : "Sign Up",
            style: TextStyle(
              color: Theme.of(context).colorScheme.loginSignInSignUpAlternateTextColor,
              fontSize: Theme.of(context).textTheme.loginSignInSignUpAlternateTextFontSize,
              fontWeight: Theme.of(context).typography.loginSignInSignUpAlternateTextFontWeight,
            ),
          ),
        ],
      ),
    );
  }

  //User interface: Show forgot password button
  Widget showForgotPasswordButton() {
    return new Text(
      "Forgot Password?",
      style: TextStyle(
        color: Theme.of(context).colorScheme.loginForgotPasswordButtonColor,
        fontSize: Theme.of(context).textTheme.loginForgotPasswordButtonFontSize,
        fontWeight: Theme.of(context).typography.loginForgotPasswordButtonFontWeight,
      ),
    );
  }

  //User interface: Show error message
  Widget showErrorMessage(String errorMessage) {
    if (errorMessage.length > 0 && errorMessage != null) {
      return new Text(
        errorMessage,
        style: TextStyle(
          color: Theme.of(context).colorScheme.loginErrorMessageColor,
          fontSize: Theme.of(context).textTheme.loginErrorMessageFontSize,
          fontWeight: Theme.of(context).typography.loginErrorMessageFontWeight,
          height: Theme.of(context).materialTapTargetSize.loginErrorMessageHeight,
        ),
      );
    } else {
      return new Container();
    }
  }

  //User interface: Login screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        height: themes.getDimension(context, true, "loginContainerDimension"),
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, false, false),
        ),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding (
                      padding: EdgeInsets.only(
                        top: _isSignIn ? MediaQuery.of(context).size.height * 0.2875 : MediaQuery.of(context).size.height * 0.2725,
                      ),
                      child: interfaceStandards.parentCenter(context,
                        Text(
                          _isSignIn ? "Ha / lf" : "Create Account",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.loginTitleColor,
                            fontSize: _isSignIn ? Theme.of(context).textTheme.loginTitleIsSignInFontSize : Theme.of(context).textTheme.loginTitleIsSignInFalseFontSize,
                            fontWeight: Theme.of(context).typography.loginTitleFontWeight,
                          ),
                        ),)
                    ),
                    _isSignIn ?
                      Container(
                        height: 0.0,
                        child: null,
                      )
                        :
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 34.0),
                        child: showInput(context, "Name"),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: _isSignIn ? 33.0 : 20.0),
                      child: showInput(context, "Email"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                      child: showInput(context, "Password"),
                    ),
                    _isSignIn ?
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.48, top: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                            );
                          },
                          child: showForgotPasswordButton()
                        ),
                      )
                        :
                      Container(
                        height: 0.0,
                        child: null,
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: _isSignIn ? 30.0 : 48.0),
                      child: interfaceStandards.parentCenter(context,
                        GestureDetector(
                          onTap: () {
                            validateAndSubmit(_isSignIn);
                          },
                          child: showSignInSignUpButton(_isSignIn, interfaceStandards.textLinearGradient(context)),
                        ),)
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.91,
              child: interfaceStandards.parentCenter(context,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _errorMessage = "";
                      _isLoading = false;
                      _isSignIn = !_isSignIn;
                    });
                  },
                  child: showSignInSignUpAlternateText(_isSignIn),
                ),)
            ),
            Positioned(
              top: _isSignIn ? 
                themes.getPosition(context, true, "loginSignInSignUpAlternateTextIsSignInPosition")
                  :
                themes.getPosition(context, true, "loginSignInSignUpAlternateTextIsSignInFalsePosition"),
              left: themes.getPosition(context, false, "loginSignInSignUpAlternateTextIsSignInPosition"),
              child: showVisibleButton(),
            ),
            Positioned(
              top: themes.getPosition(context, true, "loginProgressPosition"),
              child: interfaceStandards.parentCenter(context,
                showProgress(_isLoading)),
            ),
          ],
        ),
      ),
    );
  }
}