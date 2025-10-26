// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_wallet/screen/qr_transfer_confirmation_screen.dart';
import 'package:flutter/material.dart';

class QrTransferPage extends StatefulWidget {
  final String recipientName;
  final String recipientMobile;

  const QrTransferPage(
      {super.key, required this.recipientName, required this.recipientMobile});

  @override
  _QrTransferPageState createState() => _QrTransferPageState();
}

class _QrTransferPageState extends State<QrTransferPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionDetailController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.recipientName}',
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _transactionDetailController,
                decoration: const InputDecoration(
                  labelText: 'Transaction Detail',
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
                    return 'Please enter a transaction detail';
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
        builder: (context) => QrTransferConfirmationPage(
            recipientName: widget.recipientName,
            recipientMobile: widget.recipientMobile,
            amount: double.parse(_amountController.text.trim()),
            transactionDetail: _transactionDetailController.text.trim()),
      ),
    );
  }
}
