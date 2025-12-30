import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _authentication = FirebaseAuth.instance;

  User? get currentUser => _authentication.currentUser;
  bool get isLoggedIn => currentUser != null;

  // Sign up (Register new user)
  Future<String?> signUp(String email, String password) async {
    try {
      await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email immediately after signup
      await sendEmailVerification();

      return null; // Success! No error
    } on FirebaseAuthException catch (e) {
      // Handle common Firebase errors with user-friendly messages
      switch (e.code) {
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        default:
          // For all other Firebase errors, return a clear message
          return 'Sign up failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      // Catch any other exceptions
      return 'Something went wrong. Please try again.';
    }
  }

  // Sign in (Log in)
  Future<String?> signIn(String email, String password) async {
    try {
      await _authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      final user = _authentication.currentUser;
      if (user != null && !user.emailVerified) {
        return 'Please verify your email before logging in.';
      }

      return null; // Success! No error
    } on FirebaseAuthException catch (e) {
      // Handle common Firebase errors with user-friendly messages
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        default:
          // For all other Firebase errors, return a clear message
          return 'Login failed: ${e.message ?? e.code}';
      }
    } catch (e) {
      // Catch any other exceptions
      return 'Something went wrong. Please try again.';
    }
  }

  // For Email-verification
  Future<void> sendEmailVerification() async {
    final user = _authentication.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  bool get isEmailVerified =>
      _authentication.currentUser?.emailVerified == true;

  // Signout (Logout)
  Future<void> signOut() async {
    await _authentication.signOut();
  }

  // Listen to authentication changes
  Stream<User?> get authenticationStateChanges =>
      _authentication.authStateChanges();
}

/**
 * 
 *  // Sign up (Register new user)
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
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "No user found with this email";
      } else if (e.code == "wrong-password") {
        return "wrong password";
      }
      return e.message;
    }
  }
 * 
 */
