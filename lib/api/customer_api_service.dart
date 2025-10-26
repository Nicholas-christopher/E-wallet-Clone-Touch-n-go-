// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:e_wallet/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:http_status/http_status.dart';

class ApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  Future<Customer?> registerCustomer(Customer customer) async {
    try {
      final url = Uri.parse('$baseUrl/api/customers/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
        },
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return Customer.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        print('Request URL: $url');
        print('Request Body: ${jsonEncode(customer.toJson())}');

        return null;
      }
    } catch (e) {
      print('Error registering customer: $e');
      return null;
    }
  }

  Future<Customer?> loginCustomer(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/customers/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return Customer.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        print('Request URL: $url');

        return null;
      }
    } catch (e) {
      print('Error logging in customer: $e');
      return null;
    }
  }

  Future<Customer?> getCustomer(int customerId) async {
    try {
      final url = Uri.parse('$baseUrl/api/customers/$customerId');
      final response = await http.get(url);

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return Customer.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching customer: $e');
      return null;
    }
  }

  void _handleHttpError(http.Response response) {
    print('HTTP Error: ${response.statusCode} ${response.reasonPhrase}');
    switch (response.statusCode) {
      case 400:
        print('Bad Request');
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
