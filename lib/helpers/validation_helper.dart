import 'package:flutter/material.dart';
import 'package:martip_mobile/constants/app_strings.dart';

class ValidationHelper {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }

    // Check if it's a valid email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Check if it's a valid phone number format (Indonesian)
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');

    if (!emailRegex.hasMatch(value) &&
        !phoneRegex.hasMatch(value.replaceAll('-', ''))) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameRequired;
    }

    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    if (value.length > 50) {
      return 'Nama maksimal 50 karakter';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.phoneRequired;
    }

    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    if (!phoneRegex.hasMatch(value.replaceAll('-', ''))) {
      return 'Nomor telepon tidak valid';
    }

    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL tidak valid';
    }

    return null;
  }
}

// Form Key Manager
class FormKeyManager {
  static final Map<String, GlobalKey<FormState>> _formKeys = {};

  static GlobalKey<FormState> getFormKey(String key) {
    if (!_formKeys.containsKey(key)) {
      _formKeys[key] = GlobalKey<FormState>();
    }
    return _formKeys[key]!;
  }

  static bool validateForm(String key) {
    return _formKeys[key]?.currentState?.validate() ?? false;
  }

  static void saveForm(String key) {
    _formKeys[key]?.currentState?.save();
  }

  static void resetForm(String key) {
    _formKeys[key]?.currentState?.reset();
  }

  static void clearForm(String key) {
    _formKeys.remove(key);
  }

  static void clearAllForms() {
    _formKeys.clear();
  }
}
