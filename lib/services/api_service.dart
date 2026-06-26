import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:martip_mobile/constants/app_constants.dart';
import 'package:martip_mobile/helpers/logger_helper.dart';
import 'package:martip_mobile/helpers/storage_helper.dart';

class ApiService {
  static Future<dynamic> get(
    String endpoint, {
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final defaultHeaders = _getHeaders(requiresAuth);

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      LoggerHelper.debug('GET Request: $url');

      final response = await http
          .get(url, headers: defaultHeaders)
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      LoggerHelper.error('GET Error: $e', e, stackTrace);
      rethrow;
    }
  }

  static Future<dynamic> post(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final defaultHeaders = _getHeaders(requiresAuth);

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      LoggerHelper.debug('POST Request: $url\nBody: $body');

      final response = await http
          .post(url, headers: defaultHeaders, body: jsonEncode(body))
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      LoggerHelper.error('POST Error: $e', e, stackTrace);
      rethrow;
    }
  }

  static Future<dynamic> put(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final defaultHeaders = _getHeaders(requiresAuth);

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      LoggerHelper.debug('PUT Request: $url\nBody: $body');

      final response = await http
          .put(url, headers: defaultHeaders, body: jsonEncode(body))
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      LoggerHelper.error('PUT Error: $e', e, stackTrace);
      rethrow;
    }
  }

  static Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
      final defaultHeaders = _getHeaders(requiresAuth);

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      LoggerHelper.debug('DELETE Request: $url');

      final response = await http
          .delete(url, headers: defaultHeaders)
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e, stackTrace) {
      LoggerHelper.error('DELETE Error: $e', e, stackTrace);
      rethrow;
    }
  }

  static Map<String, String> _getHeaders(bool requiresAuth) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = StorageHelper.getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static dynamic _handleResponse(http.Response response) {
    LoggerHelper.debug('Response Status: ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      LoggerHelper.info('Success Response: ${response.body}');
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      LoggerHelper.warning('Unauthorized - Token expired');
      StorageHelper.clearUserData();
      throw ApiException(
        'Session Anda telah berakhir. Silakan login kembali',
        statusCode: 401,
      );
    } else if (response.statusCode == 403) {
      throw ApiException('Akses ditolak', statusCode: 403);
    } else if (response.statusCode == 404) {
      throw ApiException('Data tidak ditemukan', statusCode: 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Kesalahan server', statusCode: response.statusCode);
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        throw ApiException(
          errorBody['message'] ?? 'Terjadi kesalahan',
          statusCode: response.statusCode,
        );
      } catch (e) {
        throw ApiException(
          'Kesalahan: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
