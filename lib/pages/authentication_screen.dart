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
      backgroundColor: const Color(0xFFffffff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Blog App",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 32, 73, 70),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  fillColor: Color(0xFFd9d9d9),
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 32, 73, 70)),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 32, 73, 70),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  fillColor: Color(0xFFd9d9d9),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 32, 73, 70)),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color.fromARGB(255, 32, 73, 70),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color.fromARGB(255, 32, 73, 70),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 32, 73, 70),
                    // const Color.fromARGB(255, 32, 73, 70),
                  ),
                  onPressed: authProvider.isLoading ? null : _handleAuth,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Color.fromARGB(255, 32, 73, 70),
                        )
                      : Text(
                          _isLogin ? "Login" : "Sign Up",
                          style: TextStyle(
                            color: const Color(0xFFd9d9d9),

                            // const Color(0xFFffffff),
                          ),
                        ),
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
                  style: TextStyle(
                    color: const Color.fromARGB(255, 32, 73, 70),
                  ),
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
