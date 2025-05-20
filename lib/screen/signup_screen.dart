import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:parking_app/auth/auth_service.dart';
import 'package:parking_app/screen/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _name.dispose();
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
            30,
            25,
            MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 20),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),

              // -------- name ----------
              TextField(
                controller: _name,
                decoration: _inputDecoration('Name', 'Enter Name'),
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

              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text('Signup'),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  InkWell(
                    onTap: () => goToLogin(context),
                    child: const Text(
                      'Login',
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

  // -------- helpers --------
  InputDecoration _inputDecoration(String label, String hint) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  void goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );

  Future<void> _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(
      _email.text.trim(),
      _password.text.trim(),
    );
    if (user != null && mounted) {
      log('User Created Successfully');
      goToLogin(context);
    }
  }
}
