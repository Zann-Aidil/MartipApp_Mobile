import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/controllers/auth_controller.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Premium Header
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 35,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() {
                      final user = Get.find<AuthController>().currentUser.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Halo, Pengguna',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user?.email ?? 'user@martip.id',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                children: [

                  _buildDrawerItem(
                    icon: Icons.my_location_rounded,
                    label: 'Lokasi Saya',
                    onTap: () => _showComingSoon('Lokasi Saya'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.history_rounded,
                    label: 'Riwayat Transaksi',
                    onTap: () => _showComingSoon('Riwayat Transaksi'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite_rounded,
                    label: 'Lokasi Favorit',
                    onTap: () => _showComingSoon('Lokasi Favorit'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications_rounded,
                    label: 'Notifikasi',
                    onTap: () => _showComingSoon('Notifikasi'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_rounded,
                    label: 'Pengaturan',
                    onTap: () => _showComingSoon('Pengaturan'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Bantuan & Support',
                    onTap: () => _showComingSoon('Bantuan'),
                  ),
                ],
              ),
            ),

            // Footer - Logout
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _buildDrawerItem(
                icon: Icons.logout_rounded,
                label: 'Keluar',
                onTap: () {
                  Get.back();
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'Konfirmasi Keluar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Apakah kamu yakin ingin keluar dari aplikasi?',
                        style: TextStyle(fontSize: 15),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade500,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.find<AuthController>().logout();
                          },
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );
                },
                isDanger: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.back();
    Get.snackbar(
      'Informasi',
      'Fitur $feature akan segera hadir',
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.blue.shade900,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
      icon: Icon(Icons.info_outline_rounded, color: Colors.blue.shade700),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
    bool isPrimary = false,
  }) {
    Color iconColor = isDanger 
        ? Colors.red.shade400 
        : isPrimary 
            ? Colors.blue.shade700 
            : Colors.grey.shade700;
    
    Color textColor = isDanger 
        ? Colors.red.shade600 
        : isPrimary 
            ? Colors.blue.shade800 
            : Colors.grey.shade800;

    Color bgColor = isDanger 
        ? Colors.red.shade50 
        : isPrimary 
            ? Colors.blue.shade50 
            : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: (isPrimary ? Colors.blue : (isDanger ? Colors.red : Colors.grey)).withOpacity(0.1),
          highlightColor: (isPrimary ? Colors.blue : (isDanger ? Colors.red : Colors.grey)).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                if (isPrimary) ...[
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue.shade400,
                    size: 20,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Divider(color: Colors.grey.shade200, thickness: 1.5),
    );
  }
}
