import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const bool isDevelopment = true;

  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  static String get baseUrl {
    final fromEnv = dotenv.env['API_BASE_URL']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    // Use 10.0.2.2 instead of localhost for Android emulator
    return 'http://10.0.2.2:8000';
  }

  static String get _apiBaseUrl => '$baseUrl/api';

  static Uri api(String endpoint) {
    return Uri.parse('$_apiBaseUrl/$endpoint');
  }

  static String fileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$_apiBaseUrl/files/$path';
  }
}
