import 'package:dio/dio.dart';
import '../database/app_database.dart';
import '../config/api_endpoints.dart';

class OnopayService {
  final Dio _dio = Dio();
  final _db = AppDatabase.instance;

  OnopayService() {
    _dio.options.baseUrl = ApiEndpoints.onopayBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.validateStatus = (status) => status != null && status < 500;
  }

  // 1. Check User
  Future<Map<String, dynamic>> checkUser(String phoneNumber) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.checkUser,
        data: {'phone_number': phoneNumber},
      );
      return response.data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  // 2. Check Balance
  Future<Map<String, dynamic>> checkBalance(String phoneNumber) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.checkBalance,
        data: {'phone_number': phoneNumber},
      );
      return response.data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  // 3. Generate QR Code
  Future<Map<String, dynamic>> generateQRCode({
    required String phoneNumber,
    required double amount,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.generateQr,
        data: {
          'phone_number': phoneNumber,
          'amount': amount.toInt(),
          'merchant_code': 'MARTIP',
          'description': description,
          'qr_mode': 'single_use',
        },
      );
      return response.data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  // 4. Process Payment (QR Pay)
  Future<Map<String, dynamic>> paymentQR({
    required String qrCode,
    required String payerPhone,
    required int depositId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.paymentQr,
        data: {
          'qr_code': qrCode,
          'payer_phone': payerPhone,
        },
      );

      if (response.data['success'] == true || response.data['status'] == 'success') {
        // Save transaction locally
        await _saveTransaction(
          response.data['data']['transaction_id'] ?? 'TRX-${DateTime.now().millisecondsSinceEpoch}',
          depositId,
          payerPhone,
          response.data['data']['amount']?.toDouble() ?? 0.0,
          'completed',
          response.data.toString(),
        );
      }

      return response.data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  // 5. Topup Balance
  Future<Map<String, dynamic>> topup({
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.topup,
        data: {
          'phone_number': phoneNumber,
          'amount': amount,
        },
      );
      return response.data;
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  // Helper: Save transaction to local database
  Future<void> _saveTransaction(
    String transactionId,
    int depositId,
    String payerPhone,
    double amount,
    String status,
    String responseData,
  ) async {
    final database = await _db.database;
    await database.insert(
      'onopay_transactions',
      {
        'transaction_id': transactionId,
        'deposit_id': depositId,
        'payer_phone': payerPhone,
        'amount': amount,
        'status': status,
        'response_data': responseData,
        'synced': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get transaction by ID
  Future<Map<String, dynamic>?> getTransaction(String transactionId) async {
    final database = await _db.database;
    final result = await database.query(
      'onopay_transactions',
      where: 'transaction_id = ?',
      whereArgs: [transactionId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Get all transactions for user
  Future<List<Map<String, dynamic>>> getUserTransactions(String payerPhone) async {
    final database = await _db.database;
    return await database.query(
      'onopay_transactions',
      where: 'payer_phone = ?',
      whereArgs: [payerPhone],
      orderBy: 'created_at DESC',
    );
  }
}
