import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../styles/auth_styles.dart';
import '../models/user_role.dart';
import '../services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  final String? returnRoute;
  final Map<String, dynamic>? returnArguments;

  const LoginScreen({
    super.key,
    this.returnRoute,
    this.returnArguments,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        // Get user data from shared preferences
        final userData = await AuthService.getCurrentUser();
        if (userData == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get user data')),
          );
          return;
        }

        // Create UserSession object using fromJson for consistency
        final userSession = UserSession.fromJson(userData);

        // If there's a return route, navigate directly to it
        if (widget.returnRoute != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful! Returning to your selected product...'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Navigate directly to the return route without going to home first
          Navigator.pushReplacementNamed(
            context,
            widget.returnRoute!,
            arguments: widget.returnArguments,
          );
          return;
        }
        
        // Otherwise, go to home screen
        Navigator.pushReplacementNamed(context, '/home');

        // For admin/superadmin roles, navigate to their respective dashboards after delay
        if (userSession.isSuperAdmin) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                '/superadmin',
                arguments: {
                  'userId': userSession.userId,
                  'name': userSession.name,
                  'email': userSession.email,
                  'role': userSession.role == UserRole.superAdmin
                      ? 'superadmin'
                      : 'admin',
                  'departmentId': userSession.departmentId,
                  'departmentName': userSession.departmentName,
                },
              );
            }
          });
        } else if (userSession.isAdmin) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                '/admin',
                arguments: {
                  'userId': userSession.userId,
                  'name': userSession.name,
                  'email': userSession.email,
                  'role': userSession.role == UserRole.admin ? 'admin' : 'student',
                  'departmentId': userSession.departmentId,
                  'departmentName': userSession.departmentName,
                },
              );
            }
          });
        }
      } else if (result.containsKey('email_verified') && result['email_verified'] == false) {
        // Email not verified case
        _showVerificationDialog(result['message']);
      } else {
        // General error case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }
  
  // Show dialog for email verification
  void _showVerificationDialog(String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification Required'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message ?? 'Please verify your email before logging in.'),
                const SizedBox(height: 16),
                const Text('Would you like us to send a new verification email?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Resend Email'),
              onPressed: () async {
                Navigator.of(context).pop();
                _resendVerificationEmail();
              },
            ),
          ],
        );
      },
    );
  }
  
  // Resend verification email
  Future<void> _resendVerificationEmail() async {
    setState(() => isLoading = true);
    
    try {
      // First login to get token
      final loginResult = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      
      if (!loginResult['success']) {
        // Login failed, but we still want to try resending
        // This is a special case where we want to resend even if login fails due to verification
      }
      
      // Now try to resend verification email
      final result = await AuthService.resendVerificationEmail();
      
      setState(() => isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Verification email sent'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend: ${e.toString()}')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E3A8A),
              const Color(0xFF1E3A8A).withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    const SizedBox(height: 60),
                    // Header
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 220,
                            width: 450,
                            child: Image.asset(
                              'assets/logos/uddess_black.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  'UDD ESSENTIALS',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Wrapped text and form with Transform.translate
                    Transform.translate(
                       offset: const Offset(0, -45),
                      child: Column(
                        children: [
                          const Text(
                            'Welcome Back!',
                            style: AuthStyles.headingStyle,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to continue to your account',
                            style: AuthStyles.subheadingStyle,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    // Login Form Section
                    Transform.translate(
                      offset: const Offset(0, 0),
                      child: Column(
                        children: [

                          // Login Form
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          // Email Field
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: AuthStyles.inputTextStyle,
                            decoration: AuthStyles.getInputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: AuthStyles.inputTextStyle,
                            decoration: AuthStyles.getInputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // Login Button
                          ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: AuthStyles.primaryButtonStyle,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('LOGIN'),
                          ),
                            const SizedBox(height: 32),

                            // Register Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/register',
                                    );
                                  },
                                  child: const Text(
                                    'Register Here',
                                    style: TextStyle(
                                      color: Color(0xFF1E3A8A),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Back Button (placed last so it stays on top of the stack)
            Positioned(
              top: 50,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
