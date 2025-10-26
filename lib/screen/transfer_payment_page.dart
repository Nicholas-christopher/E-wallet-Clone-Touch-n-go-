// ignore_for_file: use_build_context_synchronously

import 'package:e_wallet/api/account_api_service.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/screen/login_page.dart';
import 'package:e_wallet/screen/receipt_page.dart';
import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/transfer_request.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/models/account.dart';

class TransferPaymentPage extends StatelessWidget {
  final String recipientName;
  final String recipientMobile;
  final double amount;
  final String transactionDetail;

  const TransferPaymentPage({
    super.key,
    required this.recipientName,
    required this.recipientMobile,
    required this.amount,
    required this.transactionDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Confirm Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recipient Details',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Name: $recipientName',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(
              'Mobile: $recipientMobile',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Transaction Detail: $transactionDetail',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Amount: RM ${amount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _confirmTransfer(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Confirm Transfer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmTransfer(BuildContext context) async {
    Customer? customer = await getCustomer();
    Account? account = await getAccount();

    if (customer == null || account == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      return;
    }

    final transferRequest = TransferRequest(
      debitorId: customer.customerId,
      creditorMobileNumber: recipientMobile,
      amount: amount,
      transferDetail: transactionDetail,
    );

    final response = await TransferApiService().transfer(transferRequest);

    if (response != null) {
      final updateAccount =
          await AccountApiService().getAccountByCustomerId(customer.customerId);

      if (updateAccount != null) {
        await saveAccount(updateAccount);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer successful!')),
      );
      // Navigate to the Receipt Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
            history: response,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer failed')),
      );
    }
  }
}
