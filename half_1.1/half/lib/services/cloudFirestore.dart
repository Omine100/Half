import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Method declarations
abstract class BaseCloud {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserId();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
  Future<void> sendPasswordReset(String email);
  Future<void> deleteAccount();
  
  Future<void> createNameData(String name);
  Future<void> createPartnerData(String userId);
  Future<void> createRelationshipData(int relationship);
  Future<void> createMessageData(String message);
  Future<String> readNameData(String userId);
  Future<String> readPartnerData(String userId);
  Future<String> readRelationshipData(String userId);
  Future<Stream> readMessageDataStream(String userId);
  void deleteData(DocumentSnapshot doc);
  void deleteAccountData(String userId);
}

class CloudFirestore implements BaseCloud {
  //Variable initialization
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = Firestore.instance;
  
  //Mechanics: Signs in user with given email and password
  Future<void> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
  }

  //Mechanics: Signs up user with given email, password and name
  Future<void> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, password: password);
    FirebaseUser user = result.user;
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
  Future<void> createNameData(String name) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid.toString()).document("Name")
      .setData({'Name': name,});
  }

  //Mechanics: Creates partner data
  Future<void> createPartnerData(String userId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid.toString()).document("Partner")
      .setData({'Partner': userId,});
  }

  //Mechanics: Creates relationship data
  Future<void> createRelationshipData(int relationship) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid.toString()).document("Relationship")
      .setData({'Relationship': relationship,});
  }

  //Mechanics: Create message data
  Future<void> createMessageData(String message) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference ref = await db.collection(user.uid.toString()).
      document('Messages').collection("Final").add({"Message": message});
  }

  //Mechanics: Returns name data
  Future<String> readNameData(String userId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference ref = db.collection(user.uid.toString()).document("Name");
    await ref.get().then<dynamic>((DocumentSnapshot snapshot) async {
      return snapshot.data["Name"];
    });
  }

  //Mechanics: Returns partner data
  Future<String> readPartnerData(String userId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference ref = db.collection(user.uid.toString()).document("Partner");
    await ref.get().then<dynamic>((DocumentSnapshot snapshot) async {
      return snapshot.data["Partner"];
    });
  }

  //Mechanics: Returns relationship data
  Future<String> readRelationshipData(String userId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference ref = db.collection(user.uid.toString()).document("Relationship");
    await ref.get().then<dynamic>((DocumentSnapshot snapshot) async {
      return snapshot.data["Relationship"];
    });
  }

  //Mechanics: Returns message data stream
  Future<Stream> readMessageDataStream(String userId) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    Stream messagesStream = db.collection(user.uid.toString()).
      document("Messages").collection("Final").snapshots();
    return messagesStream;
  }

  //Mechanics: Deletes data
  void deleteData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid.toString()).document(doc.documentID).delete();
  }

  //Mechanics: Deletes account data
  void deleteAccountData(String userId) async {
    await db.collection(userId).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }
}

CloudFirestore db = CloudFirestore();