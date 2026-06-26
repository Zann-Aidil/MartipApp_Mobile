import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:MartipApp/constants/app_colors.dart';
import 'package:MartipApp/controllers/auth_controller.dart';
import 'package:MartipApp/services/onopay_service.dart';

class OnoPayPaymentScreen extends StatefulWidget {
  const OnoPayPaymentScreen({Key? key}) : super(key: key);

  @override
  State<OnoPayPaymentScreen> createState() => _OnoPayPaymentScreenState();
}

class _OnoPayPaymentScreenState extends State<OnoPayPaymentScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _trackingCodeController = TextEditingController();

  late String _qrCode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _qrCode = Get.arguments as String? ?? 'UNKNOWN_QR';
    // Ambil no hp dari user yang sedang login jika ada
    _phoneController.text = _authController.user?.phone ?? '';

    // Coba parsing JSON dari QR Code (karena backend sudah diupdate ke format JSON)
    try {
      final qrDataJson = jsonDecode(_qrCode);
      if (qrDataJson is Map<String, dynamic> && qrDataJson.containsKey('tracking_code')) {
        _trackingCodeController.text = qrDataJson['tracking_code'].toString();
      }
    } catch (e) {
      // Fallback jika format lama
      if (_qrCode.contains('MARTIP-PAY-')) {
        try {
          final startIndex = _qrCode.indexOf('MARTIP-PAY-') + 11;
          final endIndex = _qrCode.indexOf('-AMT-');
          if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
            _trackingCodeController.text = _qrCode.substring(startIndex, endIndex);
          }
        } catch (_) {}
      }
    }

    // Auto process jika tracking code dan phone number sudah terisi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_phoneController.text.isNotEmpty && _trackingCodeController.text.isNotEmpty) {
        _processPayment();
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _trackingCodeController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    final phone = _phoneController.text.trim();
    final trackingCode = _trackingCodeController.text.trim();

    if (phone.isEmpty || trackingCode.isEmpty) {
      // Diam saja, tidak menampilkan error
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Endpoint API Martip Backend (Sesuaikan dengan domain website Anda)
      final url = Uri.parse('http://10.0.2.2:8000/api/mobile/pay');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tracking_code': trackingCode,
          'qr_code': _qrCode,
          'payer_phone': phone,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          final receiptData = result['data'] ?? {};
          Get.offAllNamed('/invoice', arguments: {
            'transaction_id': receiptData['receipt_no'] ?? trackingCode,
            'amount': receiptData['amount'] ?? 0,
            'date': receiptData['date'] ?? DateTime.now().toIso8601String(),
            'item_name': receiptData['item_name'] ?? 'Titipan Barang',
            'merchant': receiptData['merchant'] ?? 'MARTIP',
            'payment_method': 'OnoPay QR',
            'status': receiptData['status'] ?? 'Berhasil'
          });
        }
        // Jika gagal, diam saja — tidak menampilkan error
      }
      // Jika status code bukan 200, diam saja
    } catch (e) {
      setState(() => _isLoading = false);
      // Diam saja — tidak menampilkan error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pembayaran OnoPay', style: TextStyle(fontSize: 16)),
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text('Data QR Code:', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      _qrCode,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Konfirmasi Pembayaran',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan nomor HP Anda yang terdaftar di OnoPay untuk melanjutkan pembayaran.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _trackingCodeController,
                decoration: const InputDecoration(
                  labelText: 'Tracking Code / Invoice ID',
                  prefixIcon: Icon(Icons.receipt_long),
                  border: OutlineInputBorder(),
                  hintText: 'Misal: INV-123456789',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP Pembayar',
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('PROSES PEMBAYARAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
