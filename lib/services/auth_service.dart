import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle auth exceptions with user-friendly messages
  Exception _handleAuthException(FirebaseAuthException e) {
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email';
        break;
      case 'wrong-password':
        message = 'Wrong password';
        break;
      case 'email-already-in-use':
        message = 'Email is already in use';
        break;
      case 'invalid-email':
        message = 'Email address is invalid';
        break;
      case 'weak-password':
        message = 'Password is too weak';
        break;
      default:
        message = 'An error occurred: ${e.message}';
    }

    return Exception(message);
  }
}
