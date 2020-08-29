import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:half/widgets/interfaceStandards.dart';

//Method declarations
abstract class BaseCloud {
  //Methods: Account management
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserId();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset(String email);
  Future<bool> isEmailVerified();

  //Methods: Data management
  Future<void> createImageData(String partnerId, File file);
  Future<void> createNameData(String name);
  Future<void> createPartnerData(String partnerId);
  Future<void> createMessageData(String partnerId, String meesage, bool isImage, String imageUrl);
  Future<Widget> getImageData(String imageUrl);
  Future<String> getNameData();
  Future<String> getPartnerNameData();
  Future<String> getPartnerData();
  Future<Stream<QuerySnapshot>> getMessageStreamData();
  Future<bool> checkCommittedData(String partnerId);
  Future<void> deletePartnerData(String partnerId);
  Future<void> deleteCurrentUser();
  Future<void> deleteCurrentUserAccountData();
  Future<void> deleteCurrentMessageData(DocumentSnapshot doc, String partnerId, bool isImage, String imageUrl);
}

class CloudFirestore implements BaseCloud {
  //Variable initialization
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = Firestore.instance;
  InterfaceStandards interfaceStandards = new InterfaceStandards();

  //Mechanics: Signs in user with given email and password
  Future<void> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }
  
  //Mechanics: Signs up user with given email and password
  Future<void> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //Mechanics: Signs out current user
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  //Mechanics: Returns current user
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  //Mechanics: Returns current user string id
  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    return uid;
  }

  //Mechanics: Sends user an email for verification
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  //Mechanics: Sends user an email for a password reset
  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //Mechanics: Returns bool for if email is verified
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  //Mechanics: Creates image data
  Future<void> createImageData(String partnerId, File _image) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child("/$_image(_image.path)");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((imageUrl) {
      createMessageData(partnerId, "null", true, imageUrl);
    });
  }

  //Mechanics: Creates name data
  Future<void> createNameData(String name) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document("Name").setData({"Name": name});
  }

  //Mechanics: Creates partner data
  Future<void> createPartnerData(String partnerId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document("Partner").setData({"PartnerId": partnerId});
  }

  //Mechanics: Creates message data
  Future<void> createMessageData(String partnerId, String message, bool isImage, String imageUrl) async {
    String date = interfaceStandards.getCurrentDate();
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document("Messages").collection("Complete").document(date).
      setData({
        "Message": isImage ? "null" : message,
        "User": true,
        "isImage": isImage,
        "imageUrl": isImage ? imageUrl : "null",
      }
    );
    await db.collection(partnerId).document("Messages").collection("Complete").document(date).
      setData({
        "Message": isImage ? "null" : message,
        "User": false,
        "isImage": isImage,
        "imageUrl": isImage ? imageUrl : "null",
      }
    );
  }

  //Mechanics: Gets image data
  Future<Widget> getImageData(String imageUrl) async {
    return Image.network(imageUrl);
  }

  //Mechanics: Gets name data
  Future<String> getNameData() async {
    var user = await _firebaseAuth.currentUser();
    DocumentSnapshot snapshot = await db.collection(user.uid).document("Name").snapshots().first;
    if (!snapshot.exists) {
      return null;
    } else {
      return snapshot.data["Name"].toString();
    }
  }

  //Mechanics: Gets partner name data
  Future<String> getPartnerNameData() async {
    var user = await _firebaseAuth.currentUser();
    String partnerId;
    DocumentSnapshot snapshot = await db.collection(user.uid).document("Partner").snapshots().first;
    if(!snapshot.exists) {
      partnerId = "null";
    } else {
      partnerId = snapshot.data["PartnerId"].toString();
    }
    DocumentSnapshot partnerSnapshot = await db.collection(partnerId).document("Name").snapshots().first;
    if(!snapshot.exists) {
      return "null";
    } else {
      return partnerSnapshot.data["Name"].toString();
    }
  }

  //Mechanics: Gets partner data
  Future<String> getPartnerData() async {
    var user = await _firebaseAuth.currentUser();
    DocumentSnapshot snapshot = await db.collection(user.uid).document("Partner").snapshots().first;
    if (!snapshot.exists) {
      return null;
    } else {
      return snapshot.data["PartnerId"].toString();
    }
  }

  //Mechanics: Gets message stream data
  Future<Stream<QuerySnapshot>> getMessageStreamData() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    Stream<QuerySnapshot> messagesStream = db.collection(user.uid).document("Messages").collection("Complete").snapshots();
    return messagesStream;
  }

  //Mechanics: Checks if committed
  Future<bool> checkCommittedData(String partnerId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentSnapshot snapshot = await db.collection(partnerId).document("Partner").snapshots().first;
    if (!snapshot.exists) {
      return false;
    } else if (snapshot.data["PartnerId"] == user.uid){
      return false;
    } else {
      return true;
    }
  }

  //Mechanics: Resets partner stuff
  Future<void> deletePartnerData(String partnerId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document("Partner").delete();
    await db.collection(partnerId).document("Partner").delete();
    db.collection(user.uid).document("Messages").collection("Complete").getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    db.collection(partnerId).document("Messages").collection("Complete").getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  //Mechanics: Deletes user account (authentication)
  Future<void> deleteCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }

  //Mechanics: Deletes user account data (cloudFirestore)
  Future<void> deleteCurrentUserAccountData() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }

  //Mechanics: Deletes current message data
  Future<void> deleteCurrentMessageData(DocumentSnapshot doc, String partnerId, bool isImage, String imageUrl) async {
    if (isImage) {
      idb.getReferenceFromUrl(imageUrl).then((imageReference) {
        imageReference.delete();
      });
    }
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document("Messages").collection("Complete").document(doc.documentID).delete();
    await db.collection(partnerId).document("Messages").collection("Complete").document(doc.documentID).delete();
  }
}

FirebaseStorage idb = FirebaseStorage();
CloudFirestore db = CloudFirestore();