import 'package:blog_app_flutter/pages/main_page.dart';
import 'package:blog_app_flutter/services/firebase_authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. AUTHENTICATION PROVIDER - Manages authentication state
class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final FirebaseAuthenticationService _authService =
      FirebaseAuthenticationService();

  // Method for user login
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Notify after changing state

    try {
      String? error = await _authService.signIn(email, password);
      if (error != null) {
        errorMessage = error;
        isLoading = false;
        notifyListeners(); // Notify after changing state
        return false;
      }
      isLoading = false;
      notifyListeners(); // Notify after changing state
      return true;
    } catch (e) {
      errorMessage = "Login failed: $e";
      isLoading = false;
      notifyListeners(); // Notify after changing state
      return false;
    }
  }

  // Method for user signup
  Future<bool> signup(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Notify after changing state

    try {
      String? error = await _authService.signUp(email, password);
      if (error != null) {
        errorMessage = error;
        isLoading = false;
        notifyListeners(); // Notify after changing state
        return false;
      }
      isLoading = false;
      notifyListeners(); // Notify after changing state
      return true;
    } catch (e) {
      errorMessage = "Sign up failed: $e";
      isLoading = false;
      notifyListeners(); // Notify after changing state
      return false;
    }
  }

  // Clear error messages
  void clearError() {
    errorMessage = null;
    notifyListeners(); // Notify after changing state
  }
}

// 2. AUTHENTICATION SCREEN - The UI for login/signup
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Toggle between login and signup
  void _toggleMode() {
    // Use context.read to get the provider without listening for changes
    final authProvider = context.read<AuthProvider>();
    authProvider.clearError(); // Clear errors before toggling

    setState(() {
      _isLogin = !_isLogin;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to listen for changes in AuthProvider
    // This will rebuild the *entire* build method when AuthProvider.notifyListeners() is called
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF90a955),
      appBar: AppBar(
        title: Text(_isLogin ? "Login" : "Sign Up"),
        actions: [
          // Use context.read to get the provider without listening for changes
          // Only rebuilds this specific widget when needed (e.g., using authProvider.clearError())
          IconButton(
            icon: Icon(_isLogin ? Icons.person_add : Icons.login),
            onPressed: () {
              context.read<AuthProvider>().clearError(); // Use context.read
              _toggleMode(); // Call the method that handles state changes
            },
            tooltip: _isLogin ? "Switch to Sign Up" : "Switch to Login",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // EMAIL FIELD
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 16),

            // PASSWORD FIELD
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 24),

            // ERROR MESSAGE DISPLAY
            // This will rebuild only when authProvider.errorMessage changes
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

            // LOGIN/SIGNUP BUTTON
            // This will rebuild when authProvider.isLoading changes
            ElevatedButton(
              onPressed:
                  authProvider
                      .isLoading // Use the watched provider
                  ? null
                  : () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please enter both email and password",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      bool success;
                      if (_isLogin) {
                        success = await authProvider.login(
                          // Use the watched provider
                          email,
                          password,
                        );
                      } else {
                        success = await authProvider.signup(
                          // Use the watched provider
                          email,
                          password,
                        );
                      }

                      if (success) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainPage(),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  authProvider
                      .isLoading // Use the watched provider
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(_isLogin ? "Login" : "Sign Up"),
            ),

            const SizedBox(height: 16),

            // TOGGLE BUTTON
            // This will rebuild only when authProvider.isLoading changes (because of the onPressed check)
            TextButton(
              onPressed:
                  authProvider
                      .isLoading // Use the watched provider
                  ? null
                  : () {
                      context
                          .read<AuthProvider>()
                          .clearError(); // Use context.read
                      _toggleMode(); // Call the method that handles state changes
                    },
              child: Text(
                _isLogin
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Login",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
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
