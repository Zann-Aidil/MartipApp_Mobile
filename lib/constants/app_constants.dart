class AppConstants {
  // App Info
  static const String appName = 'MARTIP';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Titip Aman, Praktis, Cepat';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);

  // Pagination
  static const int pageSize = 10;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;

  // Storage Keys
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPhone = 'user_phone';
  static const String keyAuthToken = 'auth_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyOnboardingShown = 'onboarding_shown';
}

class ApiEndpoints {
  static const String baseUrl =
      'http://10.0.2.2:3000/api'; // Change to your API

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String getUserProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String getLocations = '/locations';
  static const String getLocationDetail = '/locations/:id';
  static const String submitDeposit = '/deposits';
  static const String getDepositHistory = '/deposits/history';
  static const String trackDeposit = '/deposits/:id/track';
}
