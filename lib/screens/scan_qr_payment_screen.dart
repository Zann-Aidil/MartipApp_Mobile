import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:MartipApp/constants/app_colors.dart';
import 'package:MartipApp/controllers/deposit_controller.dart';
import 'package:MartipApp/controllers/auth_controller.dart';
import 'package:MartipApp/services/onopay_service.dart';

class ScanQrPaymentScreen extends StatefulWidget {
  const ScanQrPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ScanQrPaymentScreen> createState() => _ScanQrPaymentScreenState();
}

class _ScanQrPaymentScreenState extends State<ScanQrPaymentScreen> {
  bool _isScanning = true;
  bool _isLoading = false;
  late Map<String, dynamic> _formData;
  late double _estimatedAmount;
  late int _merchantId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final Map<String, dynamic> safeArgs = (args is Map<String, dynamic>) ? args : {};
    _formData = (safeArgs['formData'] is Map<String, dynamic>) ? safeArgs['formData'] : {};
    _estimatedAmount = (safeArgs['estimatedAmount'] is num) ? (safeArgs['estimatedAmount'] as num).toDouble() : 0.0;
    _merchantId = (safeArgs['merchantId'] is int) ? safeArgs['merchantId'] : 1;
  }

  void _onDetect(String barcode) {
    if (!_isScanning) return;
    
    setState(() {
      _isScanning = false;
    });

    _tampilkanPopUpKonfirmasi(barcode);
  }

  void _tampilkanPopUpKonfirmasi(String barcode) {
    Get.defaultDialog(
      title: 'Konfirmasi Pembayaran QR',
      middleText: 'Anda akan membayar sebesar Rp${_estimatedAmount.toInt()} menggunakan OnoPay QR. Lanjutkan?',
      textCancel: 'Batal',
      textConfirm: 'Ya, Bayar',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.primary,
      onCancel: () {
        setState(() {
          _isScanning = true;
        });
      },
      onConfirm: () {
        Get.back(); // Tutup pop-up
        _prosesPembayaran(barcode, isRetry: false);
      },
    );
  }

  void _prosesPembayaran(String qrCode, {bool isRetry = false}) async {
    setState(() => _isLoading = true);

    final authController = Get.find<AuthController>();
    final onopayService = OnopayService();
    String payerPhone = authController.user?.phone ?? '';

    if (payerPhone.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      payerPhone = authController.user?.phone ?? '';
      if (payerPhone.isEmpty) {
        payerPhone = '082276146870';
      }
    }

    // Bayar QR Code secara langsung
    final payResult = await onopayService.paymentQR(
      qrCode: qrCode,
      payerPhone: payerPhone,
      depositId: 0,
    );

    if (payResult['success'] == true || payResult['status'] == 'success') {
      // Jika berhasil bayar, catat transaksi di sistem Martip
      final success = await Get.find<DepositController>().createDeposit(
        merchantId: _merchantId, 
        itemType: _formData['jenisBarang'] ?? 'Barang Umum',
        itemDescription: 'Titipan ${_formData['durasiValue']} ${_formData['durasiUnit']}',
        itemPhotos: _formData['imagePath'] != null ? [_formData['imagePath']] : [],
        durationUnit: (_formData['durasiUnit'] as String?)?.toLowerCase() ?? 'jam',
        durationValue: _formData['durasiValue'] ?? 1,
        estimatedAmount: _estimatedAmount,
        specialNotes: _formData['catatan'] ?? '',
      );

      setState(() => _isLoading = false);

      if (success) {
        final transactionId = payResult['data']?['transaction_id'] ?? 'TRX-${DateTime.now().millisecondsSinceEpoch}';
        Get.offAllNamed('/invoice', arguments: {
          'transaction_id': transactionId,
          'amount': _estimatedAmount.toInt(),
          'date': DateTime.now().toIso8601String(),
          'payment_method': 'OnoPay QR',
          'status': 'Berhasil',
        });
      } else {
        Get.snackbar(
          'Perhatian', 
          'Pembayaran berhasil, namun gagal mencatat data titipan.',
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800,
        );
        setState(() {
           _isScanning = true;
        });
      }
    } else {
      if (!isRetry) {
        await Future.delayed(const Duration(seconds: 1));
        _prosesPembayaran(qrCode, isRetry: true);
        return;
      }
      setState(() => _isLoading = false);
      Get.snackbar(
        'Pembayaran Gagal', 
        payResult['message'] ?? 'Saldo mungkin tidak cukup atau error server',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
      setState(() {
        _isScanning = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Pembayaran', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          if (_isScanning)
            MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && _isScanning) {
                  final barcode = barcodes.first.rawValue;
                  if (barcode != null) {
                    _onDetect(barcode);
                  }
                }
              },
            )
          else
            Container(color: Colors.black),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  child: const Text(
                    'Arahkan kamera ke QR Code OnoPay di Website',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                if (_isScanning)
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Simulasi untuk testing tanpa kamera yang benar-benar baca QR
                        _onDetect('MOCK-QR-WEB-${DateTime.now().millisecondsSinceEpoch}');
                      },
                      child: const Text('Simulasi Scan'),
                    ),
                  ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
