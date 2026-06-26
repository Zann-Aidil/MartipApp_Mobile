import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MartipApp/constants/app_colors.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'id';

  void _changeLanguage(String code) {
    setState(() => _selectedLanguage = code);
    Get.snackbar(
      'Sukses', 
      'Bahasa berhasil diubah (Simulasi)',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bahasa', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Pilih Bahasa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih bahasa yang ingin Anda gunakan di dalam aplikasi.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildLangItem('Bahasa Indonesia', 'id'),
          const Divider(),
          _buildLangItem('English', 'en'),
        ],
      ),
    );
  }

  Widget _buildLangItem(String title, String code) {
    return ListTile(
      title: Text(title),
      trailing: _selectedLanguage == code 
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () => _changeLanguage(code),
    );
  }
}
