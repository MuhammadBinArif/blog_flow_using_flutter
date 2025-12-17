import 'package:blog_app_flutter/pages/home_page.dart';
import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/services/firebase_authentication_service.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    final FirebaseAuthenticationService _authenticationService =
        FirebaseAuthenticationService();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    String? error;
    bool _isLogin = true; // Toggle between login and signup
    bool _isLoading = false;

    // Error handling
    void _showError(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    // Handle Login or Signup
    void _submit() async {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showError("Please fill all the fields");
        return;
      }

      if (!_isLoading) {
        // Login
        error = await _authenticationService.signIn(email, password);
      } else {
        // Signup
        error = await _authenticationService.signUp(email, password);
      }
      setState(() {
        _isLoading = false;
      });

      if (error != null) {
        _showError(error!);
      } else {
        // Success go to Home Screen
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
      }
    }

    return Scaffold(
      // ignore: dead_code
      appBar: AppBar(title: Text(_isLogin ? "Login" : "Sign up")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: const Text("Email"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            SizedBox(height: height * 0.1),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                label: const Text("Password"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
