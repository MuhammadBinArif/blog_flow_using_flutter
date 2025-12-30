// import 'package:blog_app_flutter/pages/main_page.dart';
// import 'package:blog_app_flutter/services/firebase_authentication_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // 1. AUTHENTICATION PROVIDER - Manages authentication state
// class AuthProvider extends ChangeNotifier {
//   bool isLoading = false;
//   String? errorMessage;
//   bool isEmailVerified = false;

//   final FirebaseAuthenticationService _authService =
//       FirebaseAuthenticationService();

//   Future<bool> login(String email, String password) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       String? error = await _authService.signIn(email, password);
//       if (error != null) {
//         errorMessage = error;
//         isLoading = false;
//         notifyListeners();
//         return false;
//       }

//       final user = _authService.currentUser;
//       if (user != null && !user.emailVerified) {
//         errorMessage = "Please verify your email before logging in.";
//         isLoading = false;
//         notifyListeners();
//         return false;
//       }

//       isEmailVerified = user?.emailVerified ?? false;
//       isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       errorMessage = "Login failed: $e";
//       isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> signup(String email, String password) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       String? error = await _authService.signUp(email, password);
//       if (error != null) {
//         errorMessage = error;
//         isLoading = false;
//         notifyListeners();
//         return false;
//       }

//       final user = _authService.currentUser;
//       isEmailVerified = user?.emailVerified ?? false;
//       isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       errorMessage = "Sign up failed: $e";
//       isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<void> sendVerificationEmail() async {
//     try {
//       await _authService.sendEmailVerification();
//     } catch (e) {
//       errorMessage = "Failed to send verification email: $e";
//       notifyListeners();
//       rethrow;
//     }
//   }

//   void clearError() {
//     errorMessage = null;
//     notifyListeners();
//   }
// }

import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    context.read<AuthProvider>().clearError();
    setState(() {
      _isLogin = !_isLogin;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleAuth() async {
    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please enter both email and password");
      return;
    }

    bool success;
    if (_isLogin) {
      success = await authProvider.login(email, password);
      if (success) {
        if (!authProvider.isEmailVerified) {
          _showSnackBar("Please verify your email first.");
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } else {
      success = await authProvider.signup(email, password);
      if (success) {
        // Don't auto-switch to login mode - let user verify first
        _showSnackBar(
          "Account created! Please check your email to verify your account.",
        );
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Blog App",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error Message
              if (authProvider.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          authProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Main Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleAuth,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(_isLogin ? "Login" : "Sign Up"),
                ),
              ),

              const SizedBox(height: 16),

              // Toggle Mode Button
              TextButton(
                onPressed: authProvider.isLoading ? null : _toggleMode,
                child: Text(
                  _isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login",
                ),
              ),

              // Resend Verification Button (only shown when needed)
              if (!_isLogin &&
                  authProvider.errorMessage?.contains("verify") == true)
                TextButton(
                  onPressed: () async {
                    if (authProvider.isLoading) return;
                    await authProvider.sendVerificationEmail();
                  },
                  child: const Text("Resend Verification Email"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

  // import 'package:blog_app_flutter/pages/main_page.dart';
  // import 'package:blog_app_flutter/services/firebase_authentication_service.dart';
  // import 'package:flutter/material.dart';

  // class AuthenticationScreen extends StatefulWidget {
  //   const AuthenticationScreen({super.key});

  //   @override
  //   State<AuthenticationScreen> createState() => _AuthenticationScreenState();
  // }

  // class _AuthenticationScreenState extends State<AuthenticationScreen> {
  //   @override
  //   Widget build(BuildContext context) {
  //     var size = MediaQuery.of(context).size;
  //     var height = size.height;

  //     final FirebaseAuthenticationService _authenticationService =
  //         FirebaseAuthenticationService();
  //     final TextEditingController _emailController = TextEditingController();
  //     final TextEditingController _passwordController = TextEditingController();

  //     String? error;
  //     bool _isLogin = false; // Toggle between login and signup

  //     // Error handling
  //     void _showError(String message) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text(message)));
  //     }

  //     // Handle Login or Signup
  //     void _submit() async {
  //       String email = _emailController.text.trim();
  //       String password = _passwordController.text.trim();

  //       if (email.isEmpty || password.isEmpty) {
  //         _showError("Please fill all the fields");
  //         return;
  //       }

  //       if (_isLogin) {
  //         // Login
  //         error = await _authenticationService.signIn(email, password);
  //       } else {
  //         // Signup
  //         error = await _authenticationService.signUp(email, password);
  //       }

  //       if (error != null) {
  //         _showError(error!);
  //       } else {
  //         // Success go to Home Screen
  //         Navigator.of(
  //           context,
  //         ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
  //       }
  //     }

  //     return Scaffold(
  //       backgroundColor: Color(0xFF90a955),
  //       appBar: AppBar(
  //         title: Text(_isLogin ? "Login" : "Sign up"),
  //         actions: [
  //           IconButton(
  //             icon: Icon(_isLogin ? Icons.person_add : Icons.login),
  //             onPressed: () {
  //               setState(() {
  //                 _isLogin = !_isLogin;
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //       body: Padding(
  //         padding: EdgeInsets.all(10),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Email field
  //             TextField(
  //               controller: _emailController,
  //               keyboardType: TextInputType.emailAddress,
  //               decoration: InputDecoration(
  //                 label: const Text("Email"),
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.email),
  //               ),
  //             ),

  //             SizedBox(height: height * 0.1),
  //             // Password field
  //             TextField(
  //               controller: _passwordController,
  //               obscureText: true,
  //               decoration: InputDecoration(
  //                 label: const Text("Password"),
  //                 border: OutlineInputBorder(),
  //                 prefixIcon: Icon(Icons.password),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: _submit,
  //               child: Text(_isLogin ? "Login" : "Sign Up"),
  //             ),
  //             TextButton(
  //               onPressed: () {},
  //               child: Text(
  //                 _isLogin ? "Already have an account?" : "Register an account",
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

