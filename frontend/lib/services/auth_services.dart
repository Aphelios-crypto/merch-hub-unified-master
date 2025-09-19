import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        AppConfig.api('login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        if (data['token'] != null && data['user'] != null) {
          final token = data['token'];
          final userData = data['user'];

          // Save both token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_data', jsonEncode(userData));
          
          // Clear guest mode after successful login
          await prefs.remove('is_guest_mode');

          return {'success': true};
        } else {
          return {'success': false, 'message': 'Invalid response from server'};
        }
      } else if (response.statusCode == 403 && data['email_verified'] == false) {
        // Email not verified case
        return {
          'success': false, 
          'email_verified': false,
          'message': data['message'] ?? 'Email not verified. Please check your email for verification link.'
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }
  
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        AppConfig.api('register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['token'] != null && data['user'] != null) {
          final token = data['token'];
          final userData = data['user'];

          // Save both token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_data', jsonEncode(userData));

          return {
            'success': true,
            'message': data['message'] ?? 'Registration successful. Please check your email for verification link.'
          };
        } else {
          return {'success': false, 'message': 'Invalid response from server'};
        }
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataStr = prefs.getString('user_data');
      if (userDataStr != null) {
        final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
        return userData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<Map<String, dynamic>> verifyEmail(String id, String hash) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/email/verify/$id/$hash'),
        headers: await getAuthToken(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email verified successfully'};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Verification failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }
  
  // Method to resend verification email
  static Future<Map<String, dynamic>> resendVerificationEmail() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/email/verification-notification'),
        headers: await getAuthToken(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Verification email sent successfully'};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Failed to send verification email'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }

  static Future<String?> getCurrentUserRole() async {
    try {
      final userData = await getCurrentUser();
      return userData?['role'];
    } catch (e) {
      return null;
    }
  }

  static Future<int?> getCurrentUserDepartment() async {
    try {
      final userData = await getCurrentUser();
      return userData?['departmentId'];
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }
  
  static Future<Map<String, String>> getAuthToken() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } catch (e) {
      // Handle error silently
    }
  }
}
