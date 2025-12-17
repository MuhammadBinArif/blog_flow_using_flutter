import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  // Creating Firebase authentication instance
  final FirebaseAuth _authentication = FirebaseAuth.instance;

  // Getting the current user
  User? get currentUser => _authentication.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Sign up (Register new user)
  Future<String?> signUp(String email, String password) async {
    try {
      await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success! No error
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return "password is too weak";
      } else if (e.code == "email-already-in-use") {
        return "Email already registered";
      }
      return e.message;
    }
  }

  // Sign in (Log in)
  Future<String?> signIn(String email, String password) async {
    try {
      await _authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success! No error
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        return "No user found with this email";
      } else if (e.code == "wrong-password") {
        return "wrong password";
      }
      return null;
    }
  }

  // Signout (Logout)
  Future<void> signOut() async {
    await _authentication.signOut();
  }

  // Listen to authentication changes
  Stream<User?> get authenticationStateChanges =>
      _authentication.authStateChanges();
}
