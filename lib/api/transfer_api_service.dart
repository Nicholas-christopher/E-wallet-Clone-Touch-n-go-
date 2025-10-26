// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:e_wallet/models/account_history.dart';
import 'package:e_wallet/models/request_fund.dart';
import 'package:e_wallet/models/request_fund_approval.dart';
import 'package:e_wallet/models/request_fund_request.dart';
import 'package:e_wallet/models/transfer_request.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:e_wallet/models/customer.dart';
import 'package:http_status/http_status.dart';

class TransferApiService {
  final String baseUrl = 'http://xxx.xxx.xxx.xx:xxx';

  Future<Customer?> getRecipientByMobile(String mobileNumber) async {
    final url =
        Uri.parse('$baseUrl/api/transfer/getRecipientByMobile/$mobileNumber');

    try {
      final response = await http.get(url, headers: {
        'accept': 'application/json',
      });

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return Customer.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching recipient: $e');
      return null;
    }
  }

  Future<AccountHistory?> transfer(TransferRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/api/transfer/transfer');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        print("here is the response.body${response.body}");
        return AccountHistory.fromJson(jsonDecode(response.body));
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during transfer: $e');
      return null;
    }
  }

  Future<AccountHistory?> qrTransfer(TransferRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/api/transfer/qr-transfer');
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
      print('Error during QR transfer: $e');
      return null;
    }
  }

  Future<RequestFundRequest?> requestFund(RequestFundRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/api/transfer/request-fund');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return RequestFundRequest.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during fund request: $e');
      return null;
    }
  }

  Future<RequestFundApproval?> approveRequestFund(
      int requestId, RequestFundApproval request) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/transfer/request-fund/approve/$requestId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return RequestFundApproval.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during fund request approval: $e');
      return null;
    }
  }

  Future<RequestFundApproval?> rejectRequestFund(
      int requestId, RequestFundApproval request) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/transfer/request-fund/reject/$requestId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return RequestFundApproval.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during fund request rejection: $e');
      return null;
    }
  }

  Future<RequestFundApproval?> cancelRequestFund(
      int requestId, RequestFundApproval request) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/transfer/request-fund/cancel/$requestId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        return RequestFundApproval.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error during fund request cancellation: $e');
      return null;
    }
  }

  Future<List<RequestFund>> fetchOutgoingRequests() async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return [];
      }

      final url = Uri.parse(
          '$baseUrl/api/transfer/request-fund/out/${customer.customerId}');
      final response = await http.get(url);

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => RequestFund.fromJson(json)).toList();
      } else {
        _handleHttpError(response);
        return [];
      }
    } catch (e) {
      print('Error fetching outgoing requests: $e');
      return [];
    }
  }

  Future<List<RequestFund>> fetchIncomingRequests() async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return [];
      }

      final url = Uri.parse(
          '$baseUrl/api/transfer/request-fund/in/${customer.customerId}');
      final response = await http.get(url);

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => RequestFund.fromJson(json)).toList();
      } else {
        _handleHttpError(response);
        return [];
      }
    } catch (e) {
      print('Error fetching incoming requests: $e');
      return [];
    }
  }

  Future<List<AccountHistory>?> getRecentHistory(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transfer/history/recent/$customerId'),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AccountHistory.fromJson(json)).toList();
      } else {
        print('Failed to load recent history: ${response.statusCode}');
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching recent history: $e');
      return null;
    }
  }

  Future<List<AccountHistory>?> getHistory(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/transfer/history/$customerId'),
      );

      if (response.statusCode.isSuccessfulHttpStatusCode) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => AccountHistory.fromJson(json)).toList();
      } else {
        print('Failed to load history: ${response.statusCode}');
        _handleHttpError(response);
        return null;
      }
    } catch (e) {
      print('Error fetching history: $e');
      return null;
    }
  }

  // Error handling function
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
