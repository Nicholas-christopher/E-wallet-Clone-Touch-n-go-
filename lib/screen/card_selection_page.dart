// ignore_for_file: avoid_print

import 'package:e_wallet/api/card_api_service.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/screen/card_add.dart';
import 'package:e_wallet/screen/payment_page.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:e_wallet/models/customer_card.dart';

class CardSelectionPage extends StatefulWidget {
  final double selectedAmount;

  const CardSelectionPage({super.key, required this.selectedAmount});

  @override
  State<CardSelectionPage> createState() => _CardSelectionPageState();
}

class _CardSelectionPageState extends State<CardSelectionPage> {
  Customer? _customer;
  bool _isLoading = true;
  List<CustomerCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCustomerAndCards();
  }

  Future<void> _loadCustomerAndCards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customer = await getCustomer();
      if (customer != null) {
        List<CustomerCard> cards = await getCard(customer.customerId);

        if (cards.isEmpty) {
          cards = (await CardApiService()
              .fetchCardsByCustomerId(customer.customerId))!;
          for (var card in cards) {
            await saveCard(card);
          }
        }

        setState(() {
          _customer = customer;
          _cards = cards;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading customer or cards: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_customer == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No customer data found',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final CustomerCard? newCard = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCardPage(),
                    ),
                  );

                  if (newCard != null) {
                    _loadCustomerAndCards(); // Reload cards after adding a new one
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add New Card',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Select a Card'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Amount: RM ${widget.selectedAmount}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Card(
                  color: Colors.blue[800],
                  child: ListTile(
                    title: Text(
                      'Card Number: ${card.cardNo}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Exp: ${card.expDate}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.white),
                    onTap: () {
                      _navigateToPaymentPage(card);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final CustomerCard? newCard = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCardPage(),
                  ),
                );

                if (newCard != null) {
                  _loadCustomerAndCards(); // Reload cards after adding a new one
                }
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add New Card',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPaymentPage(CustomerCard selectedCard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          selectedCard: selectedCard,
          amount: widget.selectedAmount,
        ),
      ),
    );
  }
}
