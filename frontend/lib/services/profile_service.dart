import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../models/user_profile.dart';

class ProfileService {
  Future<UserProfile> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/profile'),
        headers: await AppConfig.getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Ensure id and userId are integers, default to 0 if null
        jsonData['id'] = jsonData['id'] ?? 0;
        jsonData['user_id'] = jsonData['user_id'] ?? 0;
        return UserProfile.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed - please login again');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to load profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else if (e is SocketException) {
        throw Exception('Network connection error - please check your internet connection');
      } else if (e is http.ClientException) {
        throw Exception('Network request failed - please try again later');
      } else {
        throw Exception('Error loading profile: ${e.toString()}');
      }
    }
  }

  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? bio,
    String? phoneNumber,
    String? address,
    String? birthDate,
    String? gender,
    String? occupation,

    List<String>? interests,
    Map<String, String>? socialLinks,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/profile'),
        headers: await AppConfig.getHeaders(),
        body: json.encode({
          'full_name': fullName,
          'email': email,
          'bio': bio,
          'phone_number': phoneNumber,
          'address': address,
          'birth_date': birthDate,
          'gender': gender,
          'occupation': occupation,

          'interests': interests,
          'social_links': socialLinks,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        jsonData['id'] = jsonData['id'] ?? 0;
        jsonData['user_id'] = jsonData['user_id'] ?? 0;
        return UserProfile.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed - please login again');
      } else if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Validation failed';
        throw Exception(errorMessage);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to update profile';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format from server');
      } else if (e is SocketException) {
        throw Exception('Network connection error - please check your internet connection');
      } else {
        throw Exception('Error updating profile: ${e.toString()}');
      }
    }
  }

  Future<String> uploadAvatar(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConfig.baseUrl}/api/profile/avatar'),
    );

    final headers = await AppConfig.getHeaders();
    request.headers.addAll(headers);

    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['avatar_url'];
    } else {
      throw Exception('Failed to upload avatar');
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/api/profile/preferences'),
      headers: await AppConfig.getHeaders(),
      body: json.encode({
        'preferences': preferences,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update preferences');
    }
  }
}