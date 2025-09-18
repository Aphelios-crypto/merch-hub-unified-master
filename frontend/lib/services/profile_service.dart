import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';
import '../models/user_profile.dart';

class ProfileService {
  Future<UserProfile> getProfile() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/profile'),
      headers: await AppConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
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
    String? website,
    List<String>? interests,
    Map<String, String>? socialLinks,
  }) async {
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
        'website': website,
        'interests': interests,
        'social_links': socialLinks,
      }),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile');
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