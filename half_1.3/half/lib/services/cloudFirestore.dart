import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> createNameData(String name);
  Future<void> createPartnerData(String partnerId);
  Future<void> createMessageData(String meesage, bool isPartner);
  Future<String> getNameData();
  Future<String> getPartnerNameData();
  Future<String> getPartnerData();
  Future<Stream> getMessageStreamData();
  Future<bool> checkCommittedData(String partnerId);
  Future<void> deleteCurrentUser();
  Future<void> deleteCurrentUserAccountData();
  Future<void> deleteCurrentUserDocumentData(DocumentSnapshot doc);
}

class CloudFirestore implements BaseCloud {
  //Variable initialization
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = Firestore.instance;

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
  Future<void> createMessageData(String message, bool isPartner) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentReference ref = await db.collection(user.uid).document("Messages").collection("Complete").
      add({
        "Message": message,
        "User": false,
      }
    );
    DocumentReference refPartner = await db.collection(user.uid).document("Partner");
    await ref.get().then<dynamic>((DocumentSnapshot snapshot) async {
      String partnerId = snapshot.data["PartnerId"];
      DocumentReference refPartnerMessage = await db.collection(partnerId).document("Messages").collection("Complete").
        add({
          "Message": message,
          "User": true,
        });
    });
  } //Maybe put it in a document of timestamp name?

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
  Future<Stream> getMessageStreamData() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    Stream messagesStream = db.collection(user.uid).document("Messages").collection("Final").snapshots();
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
  //I think we need signInCallback on homescreen so we can remove it and then
  //send the user to the connector screen again. We also will need to delete
  //all of the messages and information from BOTH accounts

  //Mechanics: Deletes user account
  Future<void> deleteCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }

  //Mechanics: Deletes account data
  Future<void> deleteCurrentUserAccountData() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }

  //Mechanics: Deletes document data
  Future<void> deleteCurrentUserDocumentData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await db.collection(user.uid).document(doc.documentID).delete();
  }
}

CloudFirestore db = CloudFirestore();