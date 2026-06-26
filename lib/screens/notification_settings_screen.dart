import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _promoNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Pengaturan Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kelola notifikasi apa saja yang ingin Anda terima dari Martip.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('Notifikasi Push'),
            subtitle: const Text('Pemberitahuan langsung di perangkat Anda'),
            activeColor: AppColors.primary,
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notifikasi Email'),
            subtitle: const Text('Pemberitahuan status pesanan via email'),
            activeColor: AppColors.primary,
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Promo & Penawaran'),
            subtitle: const Text('Informasi diskon dan promosi terbaru'),
            activeColor: AppColors.primary,
            value: _promoNotifications,
            onChanged: (val) => setState(() => _promoNotifications = val),
          ),
        ],
      ),
    );
  }
}
