// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_wallet/api/topup_api_service.dart';
import 'package:e_wallet/models/account.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/models/customer_card.dart';
import 'package:e_wallet/models/topup_request.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class PaymentPage extends StatefulWidget {
  final CustomerCard selectedCard;
  final double amount;

  const PaymentPage(
      {super.key, required this.selectedCard, required this.amount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentInfoCard(),
            const Spacer(),
            ElevatedButton(
              onPressed: _topUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Confirm Payment',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    final String docIndicator = widget.selectedCard.docIndicator.trim();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount to Top Up:',
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            '\$${widget.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Card: ${widget.selectedCard.cardNo}',
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Card Type: ${docIndicator == "D" ? "Debit" : "Credit"}',
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Future<void> _topUp() async {
    Customer? customer = await getCustomer();
    Account? account = await getAccount();

    if (customer == null || account == null) {
      _redirectToLogin();
      return;
    }

    final topUpRequest = TopUpRequest(
      accountId: account.accountId,
      amount: widget.amount,
      cardNo: widget.selectedCard.cardNo,
      docIndicator: 'C',
      cardHolderName: widget.selectedCard.cardHname,
    );

    final accountUpdated = await TopUpApiService().topUp(topUpRequest);

    if (accountUpdated != null) {
      await saveAccount(accountUpdated);
      _showSnackBar('Top-up Successful');
      _redirectToHome();
    } else {
      _showSnackBar('Top-up Failed');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _redirectToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
