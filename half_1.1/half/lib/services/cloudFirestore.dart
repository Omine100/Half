import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Method declarations
abstract class BaseCloud {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name);
  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserId();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
  Future<void> sendPasswordReset(String email);
  Future<void> deleteAccount();
  
  Future<String> createNameData(String name);
  Future<String> createData(String data);
  Future<String> readNameData(String userId);
  String readData(String userId);
  void deleteData(DocumentSnapshot doc);
  void deleteAccountData(String userId);
}

class CloudFirestore implements BaseCloud {
  //Variable initialization
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = Firestore.instance;
  
  //Mechanics: Signs in user with given email and password
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  //Mechanics: Signs up user with given email, password and name
  Future<String> signUp(String email, String password, String name) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;

    //Need to add a section for adding name
  }

  //Mechanics: Returns current user
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  //Mechanics: Returns current user id
  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    return uid;
  }

  //Mechanics: Sends email to verify user
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  //Mechanics: Signs out user
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  //Mechanics: Returns true if email is verified
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  //Mechanics: Sends email to reset password
  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
    print("Password reset email sent to: " + email);
  }

  //Mechanics: Deletes account
  Future<void> deleteAccount() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }

  //Mechanics: Creates name data
  Future<String> createNameData(String name) async {}

  //Mechanics: Creates data
  Future<String> createData(String data) async {}

  //Mechanics: Returns name data
  Future<String> readNameData(String userId) async {}

  //Mechanics: Returns data
  String readData(String userId) {}

  //Mechanics: Deletes data
  void deleteData(DocumentSnapshot doc) {}

  //Mechanics: Deletes account data
  void deleteAccountData(String userId) {}
}

CloudFirestore db = CloudFirestore();