import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MartipApp/constants/app_colors.dart';
import 'package:MartipApp/constants/app_strings.dart';
import 'package:MartipApp/controllers/auth_controller.dart';
import 'package:MartipApp/helpers/validation_helper.dart';
import 'package:MartipApp/widgets/custom_text_field.dart';
import 'package:MartipApp/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    // Hapus pesan error sebelumnya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.errorMessage.value = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final success = await _authController.login(
        phone: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          AppStrings.error,
          _authController.errorMessage.value ?? 'Terjadi kesalahan',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          borderRadius: 12,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(Icons.location_on, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'MARTIP',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Titip Aman, Praktis, Cepat',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email/Phone Field
                    CustomTextField(
                      label: 'Email / No. HP',
                      hint: 'contoh@email.com atau 08123456789',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.person),
                      validator: ValidationHelper.validateEmail,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    CustomTextField(
                      label: 'Password',
                      hint: 'Masukkan password',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock),
                      validator: ValidationHelper.validatePassword,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 8),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.snackbar(
                            'Info',
                            'Fitur lupa password segera hadir',
                            backgroundColor: AppColors.info,
                          );
                        },
                        child: Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Error Message
                    Obx(() {
                      if (_authController.errorMessage.value != null && _authController.errorMessage.value!.isNotEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorOverlay,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: Text(
                            _authController.errorMessage.value!,
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 16),

                    // Login Button
                    Obx(
                      () => CustomButton(
                        label: AppStrings.loginButton,
                        onPressed: _handleLogin,
                        isLoading: _authController.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.noAccount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/register');
                    },
                    child: Text(
                      AppStrings.registerLink,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
