// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:e_wallet/models/customer_card.dart';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';

class CardApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  Future<List<CustomerCard>?> fetchCardsByCustomerId(int customerId) async {
    final url = Uri.parse('$baseUrl/api/card/cards/$customerId');
    final response = await http.get(url);

    if (response.statusCode.isSuccessfulHttpStatusCode) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CustomerCard.fromJson(json)).toList();
    } else {
      _handleHttpError(response);
    }
    return null;
  }

  Future<CustomerCard?> addCards(CustomerCard card) async {
    try {
      final url = Uri.parse('$baseUrl/api/card/addcard');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
        },
        body: jsonEncode(card.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        print(CustomerCard.fromJson(jsonDecode(response.body)));
        return CustomerCard.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        print('Request URL: $url');
        print('Request Body: ${jsonEncode(card.toJson())}');
        return null;
      }
    } catch (e) {
      print('Error adding card: $e');
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
