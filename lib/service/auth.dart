import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUserDocument() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print("Attempting to delete document for user ID: ${user.uid}");
        await _firestore.collection('users').doc(user.uid).delete();
        print("User document deleted successfully.");
      } else {
        print("No user is signed in.");
        throw Exception("No user is signed in.");
      }
    } catch (e) {
      print("Failed to delete user document: $e");
      throw Exception("Failed to delete user document: $e");
    }
  }

  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User deleted successfully.");
      } else {
        print("No user is signed in.");
        throw Exception("No user is signed in.");
      }
    } catch (e) {
      print("Failed to delete user: $e");
      throw Exception("Failed to delete user: $e");
    }
  }

  Future<void> SignOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Failed to sign out: $e");
      throw Exception("Failed to sign out: $e");
    }
  }
}
