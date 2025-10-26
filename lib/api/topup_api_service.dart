// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';
import 'package:e_wallet/models/account.dart';
import 'package:e_wallet/models/topup_request.dart';

class TopUpApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  // Method to handle top-up
  Future<Account?> topUp(TopUpRequest request) async {
    final url = Uri.parse('$baseUrl/api/topup/topup');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        print("response:${response.body}");
        return Account.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during top-up: $e');
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
