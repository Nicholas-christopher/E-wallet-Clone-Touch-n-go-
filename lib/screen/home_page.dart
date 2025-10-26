// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/account.dart';
import 'package:e_wallet/models/account_history.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/screen/components.dart';
import 'package:e_wallet/screen/history_page.dart';
import 'package:e_wallet/screen/login_page.dart';
import 'package:e_wallet/screen/qr_scan_screen.dart';
import 'package:e_wallet/screen/receipt_page.dart';
import 'package:e_wallet/screen/req_fund_page.dart';
import 'package:e_wallet/screen/topup_page.dart';
import 'package:e_wallet/screen/transfer_page.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Customer? _customer;
  Account? _account;
  List<AccountHistory>? _history;

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

  Future<void> _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _customer == null || _account == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Welcome, ${_customer!.fullName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'RM ${_account!.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                        ),
                        children: [
                          transactionButton(
                            Icons.add_circle,
                            'Top Up',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TopUpPage(),
                                ),
                              );
                            },
                          ),
                          transactionButton(
                              Icons.quick_contacts_dialer_outlined, 'Transfer',
                              onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TransferPage(),
                              ),
                            );
                          }),
                          transactionButton(Icons.qr_code, 'QR Scan',
                              onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRViewExample(),
                              ),
                            );
                          }),
                          transactionButton(Icons.request_page, 'Request Fund',
                              onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestFundPage(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildHistory(context),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HistoryPage(), // Redirects to the history page
                                  ),
                                );
                              },
                              child: const Text('View Full History'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    if (_history == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('No recent transactions.'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _history!.length.clamp(0, 5),
        itemBuilder: (BuildContext context, int index) {
          final history = _history![index];
          return ListTile(
            title: Text('${history.sobName}'),
            subtitle: Text('Date: ${history.trxDate}'),
            trailing: Text('Amount: ${history.amount}'),
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
      );
    }
  }
}
