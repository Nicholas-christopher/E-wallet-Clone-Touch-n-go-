// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:e_wallet/models/account.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/models/customer_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCustomer(Customer customer) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String customerJson = jsonEncode(customer.toJson());
  print('Saving Customer: $customerJson'); // Debug print
  await prefs.setString('customer', customerJson);
}

Future<Customer?> getCustomer() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? customerJson = prefs.getString('customer');
  print('Retrieved Customer JSON: $customerJson'); // Debug print
  if (customerJson != null) {
    final Map<String, dynamic> customerMap = jsonDecode(customerJson);
    return Customer.fromJson(customerMap);
  }
  return null;
}

Future<void> saveAccount(Account account) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String accountJson = jsonEncode(account.toJson());
  print('Saving Account: $accountJson'); // Debug print
  await prefs.setString('account', accountJson);
}

Future<Account?> getAccount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accountJson = prefs.getString('account');
  print('Retrieved Account JSON: $accountJson'); // Debug print
  if (accountJson != null) {
    final Map<String, dynamic> accountMap = jsonDecode(accountJson);
    return Account.fromJson(accountMap);
  }
  return null;
}

Future<void> saveCard(CustomerCard card) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String cardJson = jsonEncode(card.toJson());
  print('Saving Card: $cardJson'); // Debug print
  await prefs.setString('card_${card.cardId}', cardJson);
}

Future<List<CustomerCard>> getCard(int customerId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<CustomerCard> customerCards = [];

  final keys = prefs.getKeys();
  for (String key in keys) {
    if (key.startsWith('card_')) {
      final String? cardJson = prefs.getString(key);
      if (cardJson != null) {
        final Map<String, dynamic> cardMap = jsonDecode(cardJson);
        final card = CustomerCard.fromJson(cardMap);
        if (card.customerId == customerId) {
          customerCards.add(card);
        }
      }
    }
  }

  return customerCards;
}
