import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Simple URL strategy implementation that works on all platforms
RouterConfig<Uri>? configureApp(GlobalKey<NavigatorState> navigatorKey) {
  // Only needed for web platform, return null for mobile
  return null;
}

// Helper function to handle deep links on all platforms
void handleDeepLink(String? link, GlobalKey<NavigatorState> navigatorKey) {
  if (link == null) return;
  
  // Log the deep link for debugging
  debugPrint('Handling deep link: $link');
  
  try {
    final uri = Uri.parse(link);
    debugPrint('Parsed URI - scheme: ${uri.scheme}, host: ${uri.host}, path: ${uri.path}');
    
    // Handle HTTP/HTTPS links for email verification
    if (uri.path.contains('email/verify')) {
      debugPrint('Navigating to email verification success from HTTP link');
      navigatorKey.currentState?.pushNamed('/email-verification-success');
      return;
    }
    
    // Handle custom URL scheme for email verification success
    if (uri.scheme == 'merch-hub') {
      debugPrint('Detected merch-hub scheme');
      if (uri.host == 'email-verification-success') {
        debugPrint('Navigating to email verification success from custom scheme');
        navigatorKey.currentState?.pushNamed('/email-verification-success');
        return;
      }
    }
    
    debugPrint('No matching route found for URI: $uri');
  } catch (e) {
    debugPrint('Error parsing deep link: $e');
  }
}