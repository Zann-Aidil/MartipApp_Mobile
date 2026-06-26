class ApiEndpoints {
  // Base URLs
  static const String onopayBaseUrl = 'https://onopay.web.id/api/v1';
  static const String martipBaseUrl = 'http://martip.test/api'; // Optional backend sync

  // OnoPay Endpoints
  static const String checkUser = '/merchant/check-user';
  static const String checkBalance = '/merchant/check-balance';
  static const String generateQr = '/payment/qr/generate';
  static const String paymentQr = '/payment/qr/pay';
  static const String topup = '/payment/topup';
}
