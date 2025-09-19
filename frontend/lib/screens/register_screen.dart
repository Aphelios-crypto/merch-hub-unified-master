import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../styles/auth_styles.dart';
import 'login_screen.dart';
import '../config/app_config.dart';
import '../services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  final String? returnRoute;
  final Map<String, dynamic>? returnArguments;

  const RegisterScreen({
    super.key,
    this.returnRoute,
    this.returnArguments,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedDepartment;
  final String _selectedRole = 'student';

  final List<Map<String, dynamic>> _departments = [
    {
      'id': 1,
      'name': 'School of Information Technology Education',
      'logo': 'assets/logos/site.png',
    },
    {
      'id': 2,
      'name': 'School of Business and Accountancy',
      'logo': 'assets/logos/sba.png',
    },
    {
      'id': 3,
      'name': 'School of Criminology',
      'logo': 'assets/logos/soc.png',
    },
    {
      'id': 4,
      'name': 'School of Engineering',
      'logo': 'assets/logos/soe.png',
    },
    {
      'id': 5,
      'name': 'School of Teacher Education',
      'logo': 'assets/logos/ste.png',
    },
    {
      'id': 6,
      'name': 'School of Humanities',
      'logo': 'assets/logos/soh.png',
    },
    {
      'id': 7,
      'name': 'School of Health Sciences',
      'logo': 'assets/logos/sohs.png',
    },
    {
      'id': 8,
      'name': 'School of International Hospitality Management',
      'logo': 'assets/logos/sihm.png',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a department'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedDept = _departments.firstWhere(
        (dept) => dept['name'] == _selectedDepartment,
      );

      // First register using HTTP to include department_id and role
      // (These fields are not part of the AuthService.register method)
      final response = await http.post(
        AppConfig.api('register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
          'department_id': selectedDept['id'],
          'role': _selectedRole,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        
        // Show success message with verification instructions
        _showVerificationSuccessDialog(data['message'] ?? 'Registration successful! Please check your email for verification link.');
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Show success dialog with verification instructions
  void _showVerificationSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
                const SizedBox(height: 16),
                const Text('Please check your email for a verification link. You need to verify your email before you can log in.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Go to Login'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login screen with return route info
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      returnRoute: widget.returnRoute,
                      returnArguments: widget.returnArguments,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(height: 20),
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
                            'Create Account',
                            style: AuthStyles.headingStyle,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Join the UDD community',
                            style: AuthStyles.subheadingStyle,
                          ),
                          const SizedBox(height: 24),

                          // Registration Form
                          Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
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
                            // Name Field
                            TextFormField(
                              controller: _nameController,
                              style: AuthStyles.inputTextStyle,
                              decoration: AuthStyles.getInputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
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
                                // Comprehensive email validation using regex
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                // Additional validation for common domains
                                final domainPart = value.split('@').last.toLowerCase();
                                if (domainPart == 'example.com' || 
                                    domainPart == 'test.com' || 
                                    domainPart == 'domain.com') {
                                  return 'Please use a real email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AuthStyles.inputTextStyle,
                              decoration: AuthStyles.getInputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icons.lock_outlined,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: AuthStyles.inputTextStyle,
                              decoration: AuthStyles.getInputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icons.lock_outlined,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Department Dropdown
                            SizedBox(
                              width: double.infinity,
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedDepartment,
                                decoration: AuthStyles.getInputDecoration(
                                  labelText: 'Department',
                                  prefixIcon: Icons.school_outlined,
                                ),
                                isExpanded: true,
                                items: _departments.map((dept) {
                                  return DropdownMenuItem<String>(
                                    value: dept['name'],
                                    child: Text(
                                      dept['name'],
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDepartment = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a department';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Register Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: AuthStyles.primaryButtonStyle,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'REGISTER',
                                      style: AuthStyles.buttonTextStyle,
                                    ),
                            ),
                            const SizedBox(height: 24),

                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: AuthStyles.accountheadingStyle,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Login',
                                    style: AuthStyles.buttonTextStyle.copyWith(
                                      color: AuthStyles.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
            // Back Button
            Positioned(
              top: 50,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
