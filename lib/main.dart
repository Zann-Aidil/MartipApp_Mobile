import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/theme.dart';
import 'package:martip_mobile/constants/app_constants.dart';
import 'package:martip_mobile/helpers/storage_helper.dart';
import 'package:martip_mobile/helpers/logger_helper.dart';
import 'package:martip_mobile/controllers/auth_controller.dart';
import 'package:martip_mobile/controllers/deposit_controller.dart';
import 'package:martip_mobile/controllers/location_controller.dart';
import 'package:martip_mobile/screens/splash_screen.dart';
import 'package:martip_mobile/screens/onboarding_screen.dart';
import 'package:martip_mobile/screens/login_screen.dart';
import 'package:martip_mobile/screens/register_screen.dart';
import 'package:martip_mobile/screens/home_screen.dart';
import 'package:martip_mobile/screens/detail_lokasi_screen.dart';
import 'package:martip_mobile/screens/form_titipan_screen.dart';
import 'package:martip_mobile/screens/konfirmasi_screen.dart';
import 'package:martip_mobile/screens/tracking_screen.dart';
import 'package:martip_mobile/screens/onopay_payment_screen.dart';
import 'package:martip_mobile/screens/scan_qr_payment_screen.dart';
import 'package:martip_mobile/screens/invoice_screen.dart';
import 'package:martip_mobile/screens/edit_profile_screen.dart';
import 'package:martip_mobile/screens/notification_settings_screen.dart';
import 'package:martip_mobile/screens/security_settings_screen.dart';
import 'package:martip_mobile/screens/language_settings_screen.dart';
import 'package:martip_mobile/screens/help_screen.dart';
import 'package:martip_mobile/screens/qr_code_screen.dart';
import 'package:martip_mobile/screens/add_location_screen.dart';
import 'package:martip_mobile/screens/invoice_screen.dart';
import 'package:martip_mobile/screens/edit_profile_screen.dart';
import 'package:martip_mobile/screens/notification_settings_screen.dart';
import 'package:martip_mobile/screens/security_settings_screen.dart';
import 'package:martip_mobile/screens/language_settings_screen.dart';
import 'package:martip_mobile/screens/help_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Storage
  await StorageHelper.init();

  // Initialize GetX Dependencies
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => DepositController(), fenix: true);
  Get.lazyPut(() => LocationController(), fenix: true);

  LoggerHelper.info('App initialized successfully');

  runApp(const MartipApp());
}

class MartipApp extends StatelessWidget {
  const MartipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      defaultTransition: Transition.cupertino,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/detail', page: () => const DetailLokasiScreen()),
        GetPage(name: '/form', page: () => const FormTitipanScreen()),
        GetPage(name: '/konfirmasi', page: () => const KonfirmasiScreen()),
        GetPage(name: '/tracking', page: () => const TrackingScreen()),
        GetPage(name: '/qrcode', page: () => QrCodeScreen()),
        GetPage(name: '/add-location', page: () => AddLocationScreen()),
        GetPage(name: '/onopay_payment', page: () => const OnoPayPaymentScreen()),
        GetPage(name: '/scan_qr_payment', page: () => const ScanQrPaymentScreen()),
        GetPage(name: '/invoice', page: () => const InvoiceScreen()),
        GetPage(name: '/edit-profile', page: () => const EditProfileScreen()),
        GetPage(name: '/notifications', page: () => const NotificationSettingsScreen()),
        GetPage(name: '/security', page: () => const SecuritySettingsScreen()),
        GetPage(name: '/language', page: () => const LanguageSettingsScreen()),
        GetPage(name: '/help', page: () => const HelpScreen()),
      ],
      home: const SplashScreen(),
    );
  }
}
