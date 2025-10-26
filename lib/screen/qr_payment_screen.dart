// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_wallet/screen/qr_payment_confirmation.dart';
import 'package:flutter/material.dart';

class QrPaymentPage extends StatefulWidget {
  final String merchantName;
  final String merchantCode;

  const QrPaymentPage(
      {super.key, required this.merchantName, required this.merchantCode});

  @override
  _QrPaymentPageState createState() => _QrPaymentPageState();
}

class _QrPaymentPageState extends State<QrPaymentPage> {
  final TextEditingController _amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.merchantName}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const Spacer(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _navigateToQrConfirmationScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Center(
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToQrConfirmationScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrPaymentConfirmationPage(
            merchantName: widget.merchantName,
            merchantCode: widget.merchantCode,
            amount: double.parse(_amountController.text.trim())),
      ),
    );
  }
}
