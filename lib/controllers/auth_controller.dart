import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../helpers/storage_helper.dart';

class AuthController extends GetxController {
  final userRepository = UserRepository();
  final authService = AuthService();

  var currentUser = Rx<UserModel?>(null);
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _checkIfUserLoggedIn();
  }

  // Check if user already logged in
  Future<void> _checkIfUserLoggedIn() async {
    isLoading.value = true;
    try {
      final user = await authService.getStoredUser();
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // REGISTER
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // Validate
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        throw Exception('Semua field harus diisi');
      }

      // Check if email/phone already exists
      bool emailExists = await userRepository.emailExists(email);
      if (emailExists) throw Exception('Email sudah terdaftar');

      bool phoneExists = await userRepository.phoneExists(phone);
      if (phoneExists) throw Exception('Nomor telepon sudah terdaftar');

      // Create user
      final newUser = UserModel(
        name: name,
        email: email,
        phone: phone,
        password: authService.hashPassword(password),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final userId = await userRepository.createUser(newUser);
      final user = await userRepository.getUserById(userId);
      
      if (user != null) {
        currentUser.value = user;
        await authService.saveUserLocally(user);
        await StorageHelper.setIsLoggedIn(true);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // LOGIN
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (phone.isEmpty || password.isEmpty) {
        throw Exception('Nomor telepon dan password harus diisi');
      }

      final user = await userRepository.getUserByPhone(phone);
      if (user == null) {
        throw Exception('User tidak ditemukan');
      }

      // Verify password
      bool passwordCorrect = authService.verifyPassword(
        password,
        user.password,
      );

      if (!passwordCorrect) {
        throw Exception('Password salah');
      }

      currentUser.value = user;
      await authService.saveUserLocally(user);
      await StorageHelper.setIsLoggedIn(true);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    currentUser.value = null;
    await authService.clearUserLocally();
    await StorageHelper.setIsLoggedIn(false);
  }

  // UPDATE PROFILE
  Future<bool> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? address,
    String? city,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (currentUser.value == null) {
        throw Exception('User not logged in');
      }

      final updatedUser = UserModel(
        id: currentUser.value!.id,
        name: name,
        email: email ?? currentUser.value!.email,
        phone: phone ?? currentUser.value!.phone,
        password: currentUser.value!.password,
        address: address ?? currentUser.value!.address,
        city: city ?? currentUser.value!.city,
        onopayPhone: currentUser.value!.onopayPhone,
        createdAt: currentUser.value!.createdAt,
        updatedAt: DateTime.now(),
      );

      await userRepository.updateUser(updatedUser);
      currentUser.value = updatedUser;
      await authService.saveUserLocally(updatedUser);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  // Get current user
  UserModel? get user => currentUser.value;
}
