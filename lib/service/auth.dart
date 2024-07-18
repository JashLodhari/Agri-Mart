import 'package:app/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Delete user document and account method
  Future<void> deleteUserDocumentAndAccount(String Id) async {
    await _firestore.collection("users").doc(Id).delete();
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

// Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Failed to sign out: $e");
      throw Exception("Failed to sign out: $e");
    }
  }
}
