import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:martip_mobile/constants/app_strings.dart';
import 'package:martip_mobile/controllers/auth_controller.dart';
import 'package:martip_mobile/controllers/deposit_controller.dart';
import 'package:martip_mobile/services/onopay_service.dart';
import 'package:intl/intl.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightGrey,
                  child: Text(
                    _getInitials(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return Column(
                    children: [
                      Text(
                        authController.user?.name ?? 'Nama Pengguna',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authController.user?.email ?? 'email@example.com',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppStrings.phone}${authController.user?.phone ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed('/edit-profile');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(AppStrings.editProfile),
                ),
              ],
            ),
          ),
          
          // OnoPay Balance Section
          Obx(() {
            final phone = authController.user?.phone ?? '';
            if (phone.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: _OnoPayBalanceCard(phoneNumber: phone),
              );
            }
            return const SizedBox.shrink();
          }),
          
          const SizedBox(height: 16),

          // Deposit History Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppStrings.depositHistory,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.lightGrey,
                child: const Icon(Icons.inventory, color: Colors.grey),
              ),
              title: const Text('Total Titipan'),
              subtitle: Obx(
                () => Text(
                  '${_getDepositCount()} item',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.successOverlay,
                child: const Icon(Icons.check_circle, color: AppColors.success),
              ),
              title: const Text('Titipan Selesai'),
              subtitle: const Text(
                '0 item',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.warning.withOpacity(0.1),
                child: const Icon(Icons.access_time, color: AppColors.warning),
              ),
              title: const Text('Titipan Aktif'),
              subtitle: const Text(
                '0 item',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),

          // Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'PENGATURAN',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                  ),
                  title: const Text('Notifikasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/notifications');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security, color: AppColors.primary),
                  title: const Text('Keamanan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/security');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: const Text('Bahasa'),
                  subtitle: const Text('Bahasa Indonesia'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/language');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help, color: AppColors.primary),
                  title: const Text(AppStrings.help),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed('/help');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info, color: AppColors.primary),
                  title: const Text('Tentang'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() {
              return ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : () => _handleLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        AppStrings.logout,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
              );
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getInitials() {
    final authController = Get.find<AuthController>();
    final name = authController.user?.name ?? 'MU';
    final parts = name.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, 1).toUpperCase();
  }

  String _getDepositCount() {
    final depositController = Get.find<DepositController>();
    return depositController.deposits.length.toString();
  }

  void _handleLogout(BuildContext context) async {
    final authController = Get.find<AuthController>();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authController.logout();
      Get.offAllNamed('/login');
    }
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Tentang MARTIP'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MARTIP - Titip Aman, Praktis, Cepat',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Version: 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Aplikasi MARTIP memudahkan Anda menemukan lokasi penitipan barang yang aman dan terpercaya di sekitar Anda.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '© 2024 MARTIP. All rights reserved.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

class _OnoPayBalanceCard extends StatefulWidget {
  final String phoneNumber;
  const _OnoPayBalanceCard({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<_OnoPayBalanceCard> createState() => _OnoPayBalanceCardState();
}

class _OnoPayBalanceCardState extends State<_OnoPayBalanceCard> {
  bool _isLoading = true;
  double _balance = 0.0;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    try {
      final result = await OnopayService().checkBalance(widget.phoneNumber);
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success'] == true || result['status'] == 'success') {
            _balance = double.tryParse(result['data']?['balance']?.toString() ?? '0') ?? 0.0;
          } else {
            _error = result['message'] ?? 'User tidak ditemukan di OnoPay';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Gagal terhubung ke OnoPay';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0066CC), // OnoPay Blue
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Informasi Saldo OnoPay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() => _isLoading = true);
                  _fetchBalance();
                },
                child: const Icon(Icons.refresh, color: Colors.white, size: 20),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'SALDO SAAT INI',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          else if (_error.isNotEmpty)
            Text(
              _error,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Text(
              NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(_balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Catatan: Saldo dapat bertambah dari topup dan berkurang dari pembayaran',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
