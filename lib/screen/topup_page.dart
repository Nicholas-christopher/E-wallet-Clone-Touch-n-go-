// ignore_for_file: library_private_types_in_public_api

import 'package:e_wallet/screen/card_selection_page.dart';
import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double? _selectedAmount;
  final _customAmountController = TextEditingController();

  void _onAmountSelected(double amount) {
    setState(() {
      _selectedAmount = amount;
      _customAmountController.clear();
    });
  }

  void _onCustomAmountEntered() {
    setState(() {
      _selectedAmount = double.tryParse(_customAmountController.text);
    });
  }

  void _proceedToCardSelection() {
    if (_selectedAmount != null && _selectedAmount! > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CardSelectionPage(selectedAmount: _selectedAmount!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Top-Up'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select or enter an amount to top-up:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10.0, // Space between buttons
              runSpacing: 10.0, // Space between rows
              children: [
                for (var amount in [50.0, 100.0, 150.0, 200.0])
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    onPressed: () => _onAmountSelected(amount),
                    child: Text(
                      'RM $amount',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _customAmountController,
              decoration: const InputDecoration(
                labelText: 'Enter custom amount',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              onChanged: (_) => _onCustomAmountEntered(),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _selectedAmount != null
                    ? 'RM ${_selectedAmount!.toStringAsFixed(2)}'
                    : 'RM 0.00',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _proceedToCardSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
