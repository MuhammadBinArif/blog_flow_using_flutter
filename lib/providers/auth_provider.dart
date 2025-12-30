import 'package:blog_app_flutter/services/firebase_authentication_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailVerified = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmailVerified => _isEmailVerified;

  final FirebaseAuthenticationService _authService =
      FirebaseAuthenticationService();

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      String? error = await _authService.signIn(email, password);
      if (error != null) {
        _setError(error);
        return false;
      }

      final user = _authService.currentUser;
      if (user != null && !user.emailVerified) {
        _setError("Please verify your email before logging in.");
        return false;
      }

      _isEmailVerified = user?.emailVerified ?? false;
      return true;
    } catch (e) {
      _setError("Login failed: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      String? error = await _authService.signUp(email, password);
      if (error != null) {
        _setError(error);
        return false;
      }

      final user = _authService.currentUser;
      _isEmailVerified = user?.emailVerified ?? false;

      // Show success message and prompt user to check email
      _setError(
        "Account created! Please check your email to verify your account.",
      );
      return true;
    } catch (e) {
      _setError("Sign up failed: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
      _setError(
        "Verification email sent! Please check your inbox (and spam folder).",
      );
    } catch (e) {
      _setError("Failed to send verification email: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      _setError("Sign out failed: $e");
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
