// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:e_wallet/models/qr_code.dart';
import 'package:e_wallet/models/qr_parse_data.dart';

class QrApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  Future<QrCode?> generateCustomerQr(int customerId) async {
    try {
      final url = Uri.parse('$baseUrl/api/qr/customer/$customerId');
      final response = await http.get(url);

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return QrCode.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error generating customer QR: $e');
      return null;
    }
  }

  Future<QrCode?> generateMerchantQr(int merchantId) async {
    try {
      final url = Uri.parse('$baseUrl/api/qr/merchant/$merchantId');
      final response = await http.get(url);

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return QrCode.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error generating merchant QR: $e');
      return null;
    }
  }

  Future<QrParseData?> parseQr(QrCode qrCode) async {
    try {
      final url = Uri.parse('$baseUrl/api/qr/parse');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(qrCode.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return QrParseData.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error parsing QR: $e');
      return null;
    }
  }

  void _handleHttpError(http.Response response) {
    print('HTTP Error: ${response.statusCode} ${response.reasonPhrase}');
    switch (response.statusCode) {
      case 400:
        print('Bad Request: ${response.body}');
        break;
      case 401:
        print('Unauthorized');
        break;
      case 403:
        print('Forbidden');
        break;
      case 404:
        print('Not Found');
        break;
      case 500:
        print('Internal Server Error');
        break;
      default:
        print('Unknown error');
    }
  }
}
