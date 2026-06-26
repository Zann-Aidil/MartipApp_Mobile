import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Expecting arguments to have transaction details
    final Map<String, dynamic> data = Get.arguments ?? {};
    
    final transactionId = data['transaction_id'] ?? 'TRX-${DateTime.now().millisecondsSinceEpoch}';
    final amount = data['amount'] ?? 0;
    final paymentMethod = data['payment_method'] ?? 'OnoPay';
    final status = data['status'] ?? 'Berhasil';
    
    // Format tanggal
    final dateStr = data['date'];
    DateTime date = DateTime.now();
    if (dateStr != null) {
      try {
        date = DateTime.parse(dateStr.toString());
      } catch (_) {}
    }
    final formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Invoice Pembayaran', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Kartu Invoice
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Ikon Sukses
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pembayaran Berhasil!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Divider(thickness: 1.5, color: AppColors.lightGrey),
                    const SizedBox(height: 24),

                    // Detail Harga
                    const Text('Total Pembayaran', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      'Rp${amount.toString()}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rincian
                    _buildRow('ID Transaksi', transactionId),
                    const SizedBox(height: 12),
                    _buildRow('Metode Pembayaran', paymentMethod),
                    const SizedBox(height: 12),
                    _buildRow('Status', status, color: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/home');
                  // Tambahkan sedikit delay jika ingin pindah tab (opsional)
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('SELESAI'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Get.snackbar('Info', 'Fitur unduh struk sedang dalam pengembangan');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('UNDUH STRUK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
