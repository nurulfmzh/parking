import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:parking_app/auth/auth_service.dart';
import 'package:parking_app/screen/forgot_pass.dart';
import 'package:parking_app/screen/nav_bar.dart';
import 'package:parking_app/screen/signup_screen.dart';
import 'package:parking_app/widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            25,
            20,
            25,
            MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 20),
              const Text(
                'Log In',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),

              // -------- email ----------
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email', 'Enter Email'),
              ),
              const SizedBox(height: 20),

              // -------- password ----------
              TextField(
                controller: _password,
                obscureText: _isPasswordHidden,
                decoration: _inputDecoration(
                  'Password',
                  'Enter Password',
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _isPasswordHidden = !_isPasswordHidden,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  InkWell(
                    onTap: () => goToSignup(context),
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- helpers ----------
  InputDecoration _inputDecoration(String label, String hint) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  void goToSignup(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SignupScreen()),
  );

  void goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NavBarCategorySelectionScreen()),
  );

  Future<void> _login() async {
    final user = await _auth.loginUserWithEmailAndPassword(
      _email.text.trim(),
      _password.text.trim(),
    );
    if (user != null && mounted) {
      log('User Logged In');
      showSnackBar(context, 'Login Success!');
      goToHome(context);
    } else {
      showSnackBar(context, 'Login Failed. Check your credentials');
    }
  }
}
