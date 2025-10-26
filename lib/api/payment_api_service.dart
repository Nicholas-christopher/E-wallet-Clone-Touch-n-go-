// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:e_wallet/models/account_history.dart';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:e_wallet/models/payment_request.dart';

class PaymentApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  Future<AccountHistory?> processPayment(PaymentRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/api/payment/process');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return AccountHistory.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error processing payment: $e');
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
