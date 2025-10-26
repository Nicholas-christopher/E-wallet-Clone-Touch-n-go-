// ignore_for_file: unused_field, avoid_print

import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/account.dart';
import 'package:e_wallet/models/account_history.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/screen/receipt_page.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<AccountHistory>? _history;
  Customer? _customer;
  Account? _account;

  @override
  void initState() {
    super.initState();
    loadCustomerAndAccount();
  }

  Future<void> loadCustomerAndAccount() async {
    Customer? customer = await getCustomer();
    Account? account = await getAccount();
    List<AccountHistory>? history =
        await TransferApiService().getHistory(customer!.customerId);

    print('Loaded Customer: ${customer.toJson()}'); // Debug print
    print('Loaded Account: ${account?.toJson()}'); // Debug print

    if (mounted) {
      setState(() {
        _customer = customer;
        _account = account;

        print('Loaded history: $history'); // Debug print
        if (history != null) {
          _history = history;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Transactions History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildHistory(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    if (_history == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('No transactions.'),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _history!.length,
          itemBuilder: (BuildContext context, int index) {
            final history = _history![index];
            final color =
                history.docIndicator == 'C' ? Colors.green : Colors.red;

            return ListTile(
              title: Text('${history.sobName}'),
              subtitle: Text('Date: ${history.trxDate}'),
              trailing: Text(
                'Amount: ${history.amount}',
                style: TextStyle(color: color),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptPage(
                      history: history,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
