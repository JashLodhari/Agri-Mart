import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> reauthenticateUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      AuthCredential credential;

      // Prompt the user to re-provide their sign-in credentials
      // This example assumes email/password login, adjust as needed for other providers
      credential = EmailAuthProvider.credential(
        email: user.email!,
        password: 'user_password', // You should prompt the user for their password
      );

      try {
        await user.reauthenticateWithCredential(credential);
        print("User reauthenticated successfully.");
      } catch (e) {
        print("Failed to reauthenticate user: $e");
        throw Exception("Failed to reauthenticate user: $e");
      }
    } else {
      throw Exception("No user is signed in.");
    }
  }

  Future<void> deleteUserDocumentAndAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Reauthenticate the user
        await reauthenticateUser();

        // Delete the user document from the 'users' collection
        print("Attempting to delete document for user ID: ${user.uid}");
        await _firestore.collection('users').doc(user.uid).delete();
        print("User document deleted successfully.");

        // Delete the user account from Firebase Authentication
        await user.delete();
        print("User account deleted successfully.");
      } else {
        print("No user is signed in.");
        throw Exception("No user is signed in.");
      }
    } catch (e) {
      print("Failed to delete user document or account: $e");
      throw Exception("Failed to delete user document or account: $e");
    }
  }

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

void main() async {
  AuthMethods authMethods = AuthMethods();

  // Attempt to delete user document and account
  try {
    await authMethods.deleteUserDocumentAndAccount();
  } catch (e) {
    print("Error deleting user document or account: $e");
  }

  // Sign out
  try {
    await authMethods.signOut();
  } catch (e) {
    print("Error signing out: $e");
  }
}
