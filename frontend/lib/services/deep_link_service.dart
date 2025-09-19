import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../utils/url_strategy.dart' as url_strategy;

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  GlobalKey<NavigatorState>? _navigatorKey;
  
  factory DeepLinkService() {
    return _instance;
  }
  
  static void init(GlobalKey<NavigatorState> key) {
    _instance._navigatorKey = key;
    _instance._initDeepLinkHandling();
  }

  DeepLinkService._internal();

  // Initialize deep link handling
  void _initDeepLinkHandling() {
    debugPrint('Initializing deep link handling');
    
    // Handle deep links for email verification
    const MethodChannel('app.channel.shared.data')
        .setMethodCallHandler((MethodCall call) async {
      debugPrint('Received method call: ${call.method}');
      if (call.method == 'handleDeepLink') {
        final String url = call.arguments as String;
        debugPrint('Received deep link from platform channel: $url');
        handleDeepLink(url);
      }
    });
    
    // Check for any launch arguments (for testing)
    const String launchUrl = String.fromEnvironment('LAUNCH_URL', defaultValue: '');
    if (launchUrl.isNotEmpty) {
      debugPrint('Found launch URL from environment: $launchUrl');
      handleDeepLink(launchUrl);
    }
  }

  // Handle deep link URL
  void handleDeepLink(String url) {
    if (_navigatorKey != null) {
      // Use the common handleDeepLink function from url_strategy.dart
      // Use fully qualified name to avoid naming conflict
      url_strategy.handleDeepLink(url, _navigatorKey!);
    }
  }

  // Method to handle URL from browser or email app
  void handleInitialDeepLink(String? url) {
    if (url != null && url.isNotEmpty) {
      handleDeepLink(url);
    }
  }
}