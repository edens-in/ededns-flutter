import 'package:flutter/foundation.dart';

enum Environment {
  dev,
  staging,
  prod,
}

class AppConfig {
  static late final Environment environment;
  static late final String baseUrl;
  
  static void initialize({Environment env = Environment.dev}) {
    environment = env;
    
    switch (environment) {
      case Environment.dev:
        baseUrl = 'http://localhost:3000/api';  // Development server
        break;
      case Environment.staging:
        baseUrl = 'https://staging-api.edens.com/api';  // Staging server
        break;
      case Environment.prod:
        baseUrl = 'https://api.edens.com/api';  // Production server
        break;
    }

    // Log the configuration in debug mode
    if (kDebugMode) {
      print('🚀 App Configuration:');
      print('Environment: $environment');
      print('Base URL: $baseUrl');
    }
  }

  // Getters for common configurations
  static bool get isDevelopment => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProduction => environment == Environment.prod;
} 