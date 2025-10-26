// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:e_wallet/api/card_api_service.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/models/customer_card.dart';
import 'package:e_wallet/screen/Login_page.dart';
import 'package:e_wallet/shared_prefs.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNoController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _secCodeController = TextEditingController();
  final TextEditingController _cardHnameController = TextEditingController();

  String? _selectedDocIndicator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Card'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cardNoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
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
                    return 'Please enter card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expDateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Expiration Date (MM/YY)',
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
                    return 'Please enter expiration date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _secCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Security Code',
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
                    return 'Please enter security code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardHnameController,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
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
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDocIndicator,
                items: const [
                  DropdownMenuItem(
                    value: "D",
                    child: Text("Debit", style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: "C",
                    child:
                        Text("Credit", style: TextStyle(color: Colors.black)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDocIndicator = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Card Type',
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
                    return 'Please select card type';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCard();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Center(
                  child: Text(
                    'Add Card',
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

  void _saveCard() async {
    Customer? customer = await getCustomer();
    if (customer == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    final newCard = CustomerCard(
      cardId: 0,
      customerId: customer.customerId,
      cardNo: _cardNoController.text,
      expDate: _expDateController.text,
      secCode: int.parse(_secCodeController.text),
      cardHname: _cardHnameController.text,
      docIndicator: _selectedDocIndicator ?? "D",
    );

    final savedCard = await CardApiService().addCards(newCard);
    if (savedCard != null) {
      await saveCard(savedCard);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card Saved')),
      );
      Navigator.pop(context, newCard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card Failed to save')),
      );
    }
  }
}
