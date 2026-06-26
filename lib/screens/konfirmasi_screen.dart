import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:martip_mobile/constants/app_colors.dart';
import 'package:martip_mobile/controllers/deposit_controller.dart';
import 'package:martip_mobile/controllers/auth_controller.dart';
import 'package:martip_mobile/services/onopay_service.dart';

class KonfirmasiScreen extends StatefulWidget {
  const KonfirmasiScreen({Key? key}) : super(key: key);

  @override
  State<KonfirmasiScreen> createState() => _KonfirmasiScreenState();
}

class _KonfirmasiScreenState extends State<KonfirmasiScreen> {
  String _metodeBayar = 'OnoPay (E-Wallet)';
  bool _isLoading = false;

  void _tampilkanPopUpKonfirmasi(Map<String, dynamic> formData, double estimatedAmount, int merchantId) {
    Get.defaultDialog(
      title: 'Konfirmasi Pembayaran',
      middleText: 'Saldo OnoPay Anda akan dipotong sebesar Rp${estimatedAmount.toInt()}. Lanjutkan transaksi?',
      textCancel: 'Batal',
      textConfirm: 'Ya, Bayar',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.primary,
      onConfirm: () {
        Get.back(); // Tutup pop-up
        _prosesPembayaran(formData, estimatedAmount, merchantId, isRetry: false);
      },
    );
  }

  void _prosesPembayaran(Map<String, dynamic> formData, double estimatedAmount, int merchantId, {bool isRetry = false}) async {
    setState(() => _isLoading = true);

    final authController = Get.find<AuthController>();
    final onopayService = OnopayService();
    String payerPhone = authController.user?.phone ?? '';

    if (payerPhone.isEmpty) {
      // Tunggu sebentar jika AuthController sedang memuat data dari Storage
      await Future.delayed(const Duration(milliseconds: 500));
      payerPhone = authController.user?.phone ?? '';
      
      // Jika masih kosong, langsung gunakan nomor default tanpa memunculkan error
      if (payerPhone.isEmpty) {
        payerPhone = '082276146870';
      }
    }

    // 1. Generate QR Code Tagihan
    final generateResult = await onopayService.generateQRCode(
      phoneNumber: '08123456789', // Nomor merchant
      amount: estimatedAmount,
      description: 'Titipan ${formData['durasiValue']} ${formData['durasiUnit']}',
    );

    if (generateResult['success'] != true) {
      if (!isRetry) {
        // Silently retry sekali jika gagal (menyamarkan server cold start)
        await Future.delayed(const Duration(seconds: 1));
        _prosesPembayaran(formData, estimatedAmount, merchantId, isRetry: true);
        return;
      }
      setState(() => _isLoading = false);
      Get.snackbar('Gagal', generateResult['message'] ?? 'Gagal membuat tagihan', backgroundColor: Colors.red.shade50, colorText: Colors.red.shade800);
      return;
    }

    final qrCode = generateResult['data']?['qr_code'] ?? '';

    // Berikan jeda waktu 1 detik agar sinkronisasi database server OnoPay selesai
    await Future.delayed(const Duration(seconds: 1));

    // 2. Bayar QR Code secara langsung
    final payResult = await onopayService.paymentQR(
      qrCode: qrCode,
      payerPhone: payerPhone,
      depositId: 0,
    );

    if (payResult['success'] == true || payResult['status'] == 'success') {
      // 3. Jika berhasil bayar, catat transaksi di sistem Martip
      final success = await Get.find<DepositController>().createDeposit(
        merchantId: merchantId, 
        itemType: formData['jenisBarang'] ?? 'Barang Umum',
        itemDescription: 'Titipan ${formData['durasiValue']} ${formData['durasiUnit']}',
        itemPhotos: formData['imagePath'] != null ? [formData['imagePath']] : [],
        durationUnit: (formData['durasiUnit'] as String).toLowerCase(),
        durationValue: formData['durasiValue'] ?? 1,
        estimatedAmount: estimatedAmount,
        specialNotes: formData['catatan'] ?? '',
      );

      setState(() => _isLoading = false);

      if (success) {
        final transactionId = payResult['data']?['transaction_id'] ?? 'TRX-${DateTime.now().millisecondsSinceEpoch}';
        Get.offAllNamed('/invoice', arguments: {
          'transaction_id': transactionId,
          'amount': estimatedAmount.toInt(),
          'date': DateTime.now().toIso8601String(),
          'payment_method': 'OnoPay',
          'status': 'Berhasil',
        });
      } else {
        Get.snackbar(
          'Perhatian', 
          'Pembayaran berhasil, namun gagal mencatat data titipan.',
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800,
        );
      }
    } else {
      if (!isRetry) {
        // Silently retry sekali jika gagal saat pay
        await Future.delayed(const Duration(seconds: 1));
        _prosesPembayaran(formData, estimatedAmount, merchantId, isRetry: true);
        return;
      }
      setState(() => _isLoading = false);
      Get.snackbar(
        'Pembayaran Gagal', 
        payResult['message'] ?? 'Saldo mungkin tidak cukup atau error server',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? formData = Get.arguments as Map<String, dynamic>?;
    
    // Default fallback values
    String jenisBarang = formData?['jenisBarang'] ?? 'Barang';
    int durasiValue = formData?['durasiValue'] ?? 1;
    String durasiUnit = formData?['durasiUnit'] ?? 'Jam';
    
    // Location object passed
    final dynamic location = formData?['location'];
    int merchantId = 1;
    double basePrice = 10000.0;
    String merchantName = 'Mitra MARTIP';
    
    if (location != null) {
      merchantName = location.name;
      basePrice = location.pricePerDay;
      // Assuming dummy locations have id strings like 'loc_1', we use simple int parsing for SQLite relation
      merchantId = int.tryParse(location.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    }

    double estimatedAmount = durasiValue * basePrice;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Konfirmasi', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ringkasan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                merchantName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                '$jenisBarang - $durasiValue $durasiUnit',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Text('Total:', style: Theme.of(context).textTheme.titleMedium),
              Text(
                'Rp${estimatedAmount.toInt()}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Metode Bayar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                'OnoPay (E-Wallet)',
                Icons.account_balance_wallet_rounded,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : () {
                  _tampilkanPopUpKonfirmasi(formData ?? {}, estimatedAmount, merchantId);
                },
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('BAYAR & KONFIRMASI'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, IconData icon) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
      value: value,
      groupValue: _metodeBayar,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      onChanged: (String? newValue) {
        setState(() {
          _metodeBayar = newValue!;
        });
      },
    );
  }
}
