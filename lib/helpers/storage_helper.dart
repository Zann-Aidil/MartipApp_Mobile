import 'package:shared_preferences/shared_preferences.dart';
import 'package:MartipApp/constants/app_constants.dart';

class StorageHelper {
  static late SharedPreferences _prefs;
  static bool _initialized = false;

  // Initialize SharedPreferences
  static Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // User Session
  static Future<bool> setUserId(String userId) async {
    return await _prefs.setString(AppConstants.keyUserId, userId);
  }

  static String? getUserId() {
    return _prefs.getString(AppConstants.keyUserId);
  }

  static Future<bool> setUserName(String name) async {
    return await _prefs.setString(AppConstants.keyUserName, name);
  }

  static String? getUserName() {
    return _prefs.getString(AppConstants.keyUserName);
  }

  static Future<bool> setUserEmail(String email) async {
    return await _prefs.setString(AppConstants.keyUserEmail, email);
  }

  static String? getUserEmail() {
    return _prefs.getString(AppConstants.keyUserEmail);
  }

  static Future<bool> setUserPhone(String phone) async {
    return await _prefs.setString(AppConstants.keyUserPhone, phone);
  }

  static String? getUserPhone() {
    return _prefs.getString(AppConstants.keyUserPhone);
  }

  static Future<bool> setAuthToken(String token) async {
    return await _prefs.setString(AppConstants.keyAuthToken, token);
  }

  static String? getAuthToken() {
    return _prefs.getString(AppConstants.keyAuthToken);
  }

  static Future<bool> setIsLoggedIn(bool value) async {
    return await _prefs.setBool(AppConstants.keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  static Future<bool> setOnboardingShown(bool value) async {
    return await _prefs.setBool(AppConstants.keyOnboardingShown, value);
  }

  static bool isOnboardingShown() {
    return _prefs.getBool(AppConstants.keyOnboardingShown) ?? false;
  }

  // Clear all user data
  static Future<bool> clearUserData() async {
    await _prefs.remove(AppConstants.keyUserId);
    await _prefs.remove(AppConstants.keyUserName);
    await _prefs.remove(AppConstants.keyUserEmail);
    await _prefs.remove(AppConstants.keyUserPhone);
    await _prefs.remove(AppConstants.keyAuthToken);
    await _prefs.remove(AppConstants.keyIsLoggedIn);
    return true;
  }

  // Clear all data
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  // Generic methods
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key, {String? defaultValue}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
