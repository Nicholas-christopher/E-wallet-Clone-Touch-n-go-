// ignore_for_file: use_build_context_synchronously

import 'package:e_wallet/models/account_history.dart';
import 'package:e_wallet/screen/home_page.dart';
import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final AccountHistory history;

  const ReceiptPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Receipt'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getWidgets(context, history),
        ),
      ),
    );
  }

  List<Widget> _getWidgets(BuildContext context, AccountHistory history) {
    List<Widget> widgets = [];

    //Common fields
    widgets.add(const Text('Transaction Receipt',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Text(
      'Reference Number: ${history.trxRefNo}',
      style: const TextStyle(fontSize: 16),
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Text(
      'Transaction Date/Time: ${history.trxDate}',
      style: const TextStyle(fontSize: 16),
    ));
    widgets.add(const SizedBox(height: 10));

    //Field specific to transaction code
    switch (history.trxCode) {
      case 'TOPUP':
        widgets.add(const Text(
          'Transaction Type: TOP-UP',
          style: TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        widgets.add(Text(
          'Card Holder Name: ${history.sobName}',
          style: const TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        break;
      case 'TRF_MBNO':
        widgets.add(const Text(
          'Transaction Type: Transfer to Mobile No',
          style: TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        if (history.docIndicator == "D") {
          widgets.add(Text(
            'Recipient Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        } else {
          widgets.add(Text(
            'Sender Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        }
        widgets.add(const SizedBox(height: 10));
        break;
      case 'TRF_QR':
        widgets.add(const Text(
          'Transaction Type: QR Transfer',
          style: TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        if (history.docIndicator == "D") {
          widgets.add(Text(
            'Recipient Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        } else {
          widgets.add(Text(
            'Sender Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        }
        widgets.add(const SizedBox(height: 10));
        break;
      case 'PYMT':
        widgets.add(const Text(
          'Transaction Type: QR Payment',
          style: TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        widgets.add(Text(
          'Merchant Name: ${history.sobName}',
          style: const TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        break;
      case 'REQ_FUND':
        widgets.add(const Text(
          'Transaction Type: Request Fund',
          style: TextStyle(fontSize: 16),
        ));
        widgets.add(const SizedBox(height: 10));
        if (history.docIndicator == "D") {
          widgets.add(Text(
            'Recipient Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        } else {
          widgets.add(Text(
            'Sender Name: ${history.sobName}',
            style: const TextStyle(fontSize: 16),
          ));
        }
        widgets.add(const SizedBox(height: 10));
        break;
      default:
        break;
    }
    if (history.docIndicator == "D") {
      widgets.add(Text(
        'Amount: RM ${history.amount.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16, color: Colors.red),
      ));
    } else {
      widgets.add(Text(
        'Amount: RM ${history.amount.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16, color: Colors.green),
      ));
    }
    widgets.add(const SizedBox(height: 10));
    widgets.add(Text(
      'Transaction Detail: ${history.trxDetail!}',
      style: const TextStyle(fontSize: 16),
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'Go to Home',
        style: TextStyle(fontSize: 18.0),
      ),
    ));
    return widgets;
  }
}
