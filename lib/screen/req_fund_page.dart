// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:e_wallet/api/customer_api_service.dart';
import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/request_fund_approval.dart';
import 'package:e_wallet/models/request_fund_request.dart';
import 'package:e_wallet/screen/req_fund_detail_page.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/models/request_fund.dart';

class RequestFundPage extends StatefulWidget {
  const RequestFundPage({super.key});

  @override
  _RequestFundPageState createState() => _RequestFundPageState();
}

class _RequestFundPageState extends State<RequestFundPage> {
  final TransferApiService _apiService = TransferApiService();
  List<RequestFund>? _incomingRequests;
  List<RequestFund>? _outgoingRequests;
  final ApiService _customerApiService = ApiService();
  final Map<int, String> _customerNames = {}; // Store fetched names

  @override
  void initState() {
    super.initState();
    fetchIncomingRequests();
    fetchOutgoingRequests();
  }

  Future<void> fetchCustomerName(int customerId) async {
    if (!_customerNames.containsKey(customerId)) {
      final customer = await _customerApiService.getCustomer(customerId);
      if (customer != null) {
        setState(() {
          _customerNames[customerId] = customer.fullName;
        });
      } else {
        setState(() {
          _customerNames[customerId] = 'Unknown';
        });
      }
    }
  }

  Future<List<RequestFund>> fetchIncomingRequests() async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return [];
      }

      final response = await _apiService.fetchIncomingRequests();

      setState(() {
        _incomingRequests = response;
      });
      for (var request in _incomingRequests ?? []) {
        await fetchCustomerName(request.customerId);
      }
      return response;
    } catch (e) {
      print('Error fetching incoming requests: $e');
      return [];
    }
  }

  Future<List<RequestFund>> fetchOutgoingRequests() async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return [];
      }

      final response = await _apiService.fetchOutgoingRequests();

      setState(() {
        _outgoingRequests = response;
      });
      for (var request in _outgoingRequests ?? []) {
        await fetchCustomerName(request.beneCustomerId);
      }
      return response;
    } catch (e) {
      print('Error fetching outgoing requests: $e');
      return [];
    }
  }

  Future<void> requestFundOut({
    required String debtorMobileNumber,
    required double amount,
    String? requestDetail,
  }) async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return;
      }

      final request = RequestFundRequest(
        creditorCustomerId: customer.customerId,
        debitorMobileNumber: debtorMobileNumber,
        amount: amount,
        requestDetail: requestDetail,
      );

      final response = await _apiService.requestFund(request);

      if (response != null) {
        print('Fund request successful: ${response.toJson()}');
        fetchOutgoingRequests(); // Refresh the list
      } else {
        print('Error: Fund request failed.');
      }
    } catch (e) {
      print('Error during fund request: $e');
    }
  }

  Future<void> approveRequest(int requestId) async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return;
      }

      final request = RequestFundApproval(customerId: customer.customerId);
      final response = await _apiService.approveRequestFund(requestId, request);

      if (response != null) {
        print('Request approved successfully.');
        fetchIncomingRequests(); // Refresh the list
      } else {
        print('Error: Request approval failed.');
      }
    } catch (e) {
      print('Error during request approval: $e');
    }
  }

  Future<void> rejectRequest(int requestId) async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return;
      }

      final request = RequestFundApproval(customerId: customer.customerId);
      final response = await _apiService.rejectRequestFund(requestId, request);

      if (response != null) {
        print('Request rejected successfully.');
        fetchIncomingRequests(); // Refresh the list
      } else {
        print('Error: Request rejection failed.');
      }
    } catch (e) {
      print('Error during request rejection: $e');
    }
  }

  Future<void> cancelRequest(int requestId) async {
    try {
      final customer = await getCustomer();
      if (customer == null) {
        print('Error: No customer found.');
        return;
      }

      final request = RequestFundApproval(customerId: customer.customerId);
      final response = await _apiService.cancelRequestFund(requestId, request);

      if (response != null) {
        print('Request cancelled successfully.');
        fetchOutgoingRequests(); // Refresh the list
      } else {
        print('Error: Request cancellation failed.');
      }
    } catch (e) {
      print('Error during request cancellation: $e');
    }
  }

  void _showRequestDialog() {
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Fund Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mobileController,
                decoration:
                    const InputDecoration(labelText: 'Debtor Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'Request Detail'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final debtorMobileNumber = mobileController.text;
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final requestDetail = detailController.text;

                if (debtorMobileNumber.isNotEmpty && amount > 0) {
                  requestFundOut(
                    debtorMobileNumber: debtorMobileNumber,
                    amount: amount,
                    requestDetail: requestDetail,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetailsPage(RequestFund request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestFundDetailPage(request: request),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Fund'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Outgoing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: _incomingRequests?.length ?? 0,
              itemBuilder: (context, index) {
                final request = _incomingRequests![index];
                final customerName =
                    _customerNames[request.customerId] ?? 'Loading...';
                return ListTile(
                  title: Text('Request from $customerName'),
                  subtitle: Text('Amount: ${request.amount}'),
                  trailing: Text('Status: ${request.status}'),
                  onTap: () => _navigateToDetailsPage(request),
                );
              },
            ),
            ListView.builder(
              itemCount: _outgoingRequests?.length ?? 0,
              itemBuilder: (context, index) {
                final request = _outgoingRequests![index];
                final beneCustomerName =
                    _customerNames[request.beneCustomerId] ?? 'Loading...';
                return ListTile(
                  title: Text('Request to $beneCustomerName'),
                  subtitle: Text('Amount: ${request.amount}'),
                  trailing: Text('Status: ${request.status}'),
                  onTap: () => _navigateToDetailsPage(request),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showRequestDialog,
          tooltip: 'Add Request',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
