import 'package:flutter/foundation.dart';
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
    _errorMessage = "";
    _isLoading = false;
    _isSignIn = true;
    _isVisible = false;
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
  void validateAndSubmit(bool isSignIn) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (isSignIn) {
          await cloudFirestore.signIn(_email, _password);
          userId = await cloudFirestore.getCurrentUserId();
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null && isSignIn) {
            widget.loginCallback();
          }
        } else {
          await cloudFirestore.signUp(_email, _password);
          await cloudFirestore.createNameData(_name);
          userId = await cloudFirestore.getCurrentUserId();
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null && !isSignIn) {
            await cloudFirestore.signIn(_email, _password);
            widget.loginCallback();
          }
          cloudFirestore.sendEmailVerification();
        }
      } catch (e) {
        print("Error: $e");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      } 
    } else {
      setState(() {
        _errorMessage = "";
        _isLoading = false;
      });
    }
  }

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
        color: Theme.of(context).colorScheme.loginTextInput,
        fontSize: Theme.of(context).textTheme.textInputFontSize,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          text != "Email" ? text == "Password" ?
            Icons.lock :
            Icons.person :
            Icons.email,
          color: Theme.of(context).colorScheme.loginTextInput,
        ),
        hintText: text,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.loginTextInput,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.loginTextInput,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.loginTextInput,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.loginTextInput,
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
        color: Theme.of(context).colorScheme.loginTitle,
      ),
    );
  }

  //User interface: Show progress
  Widget showProgress(bool isLoading) {
    if (isLoading) {
      return new CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.loginTitle,
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  //User interface: Show sign in or sign up button
  Widget showSignInSignUpButton(bool isSignIn, Shader linearGradient) {
    return new Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.375,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30.0
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          isSignIn ? "LOGIN" : "SIGN UP",
          style: TextStyle(
            foreground: Paint()
              ..shader = linearGradient,
            fontWeight: FontWeight.w600,
            fontSize: 22.5,
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
          color: Theme.of(context).colorScheme.loginTitle,
          fontSize: 15.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: !isSignIn ? "Sign In" : "Sign Up",
            style: TextStyle(
              color: Theme.of(context).colorScheme.loginTitle,
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
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
        color: Theme.of(context).colorScheme.loginTitle,
        fontWeight: FontWeight.w400,
        fontSize: 15.0
      ),
    );
  }

  //User interface: Show error message
  Widget showErrorMessage(String errorMessage) {
    if (errorMessage.length > 0 && errorMessage != null) {
      return new Text(
        errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  //User interface: Login screen
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
                            color: Theme.of(context).colorScheme.loginTitle,
                            fontSize: _isSignIn ? 65.0 : 40.0,
                            fontWeight: FontWeight.w600,
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
                MediaQuery.of(context).size.height * 0.525
                  :
                MediaQuery.of(context).size.height * 0.56,
              left: MediaQuery.of(context).size.width * 0.8,
              child: showVisibleButton(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              child: interfaceStandards.parentCenter(context,
                  showProgress(_isLoading)),
            ),
          ],
        ),
      ),
    );
  }
}