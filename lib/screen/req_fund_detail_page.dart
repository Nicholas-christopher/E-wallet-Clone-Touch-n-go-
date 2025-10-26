// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:e_wallet/models/request_fund_approval.dart';
import 'package:e_wallet/screen/req_fund_page.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/request_fund.dart';
import 'package:e_wallet/shared_prefs.dart';

class RequestFundDetailPage extends StatefulWidget {
  final RequestFund request;

  const RequestFundDetailPage({super.key, required this.request});

  @override
  State<RequestFundDetailPage> createState() => _RequestFundDetailPageState();
}

class _RequestFundDetailPageState extends State<RequestFundDetailPage> {
  bool isIncoming = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfIncoming();
  }

  Future<void> _checkIfIncoming() async {
    final customer = await getCustomer();
    if (customer != null) {
      setState(() {
        isIncoming = widget.request.beneCustomerId == customer.customerId;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Request Fund Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isPending = widget.request.status == 'PENDING';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Fund Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request ID: ${widget.request.requestId}'),
            Text('Amount: ${widget.request.amount}'),
            Text('Status: ${widget.request.status}'),
            if (widget.request.requestDetail != null)
              Text('Details: ${widget.request.requestDetail}'),
            if (isPending)
              if (isIncoming)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _approveRequest(context),
                      child: const Text('Approve'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _rejectRequest(context),
                      child: const Text('Reject'),
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: () => _cancelRequest(context),
                  child: const Text('Cancel'),
                ),
            if (!isPending)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestFundPage(),
                    ),
                  );
                },
                child: const Text('Close'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _approveRequest(BuildContext context) async {
    final apiService = TransferApiService();
    final customer = await getCustomer();
    if (customer == null) return;

    try {
      final success = await apiService.approveRequestFund(
          widget.request.requestId,
          RequestFundApproval(customerId: customer.customerId));
      if (success != null) {
        Navigator.pop(context); // Close the details page
      } else {
        _showErrorDialog(context, 'Failed to approve request.');
      }
    } catch (e) {
      print('Error approving request: $e');
      _showErrorDialog(context, 'Failed to approve request.');
    }
  }

  Future<void> _rejectRequest(BuildContext context) async {
    final apiService = TransferApiService();
    final customer = await getCustomer();
    if (customer == null) return;

    try {
      final success = await apiService.rejectRequestFund(
          widget.request.requestId,
          RequestFundApproval(customerId: customer.customerId));
      if (success != null) {
        Navigator.pop(context); // Close the details page
      } else {
        _showErrorDialog(context, 'Failed to reject request.');
      }
    } catch (e) {
      print('Error rejecting request: $e');
      _showErrorDialog(context, 'Failed to reject request.');
    }
  }

  Future<void> _cancelRequest(BuildContext context) async {
    final apiService = TransferApiService();
    final customer = await getCustomer();
    if (customer == null) return;

    try {
      final success = await apiService.cancelRequestFund(
          widget.request.requestId,
          RequestFundApproval(customerId: customer.customerId));
      if (success != null) {
        Navigator.pop(context); // Close the details page
      } else {
        _showErrorDialog(context, 'Failed to cancel request.');
      }
    } catch (e) {
      print('Error canceling request: $e');
      _showErrorDialog(context, 'Failed to cancel request.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
