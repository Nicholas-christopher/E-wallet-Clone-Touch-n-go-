// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:e_wallet/api/merchant_api_service.dart';
import 'package:e_wallet/api/qr_api_service.dart';
import 'package:e_wallet/api/transfer_api_service.dart';
import 'package:e_wallet/models/customer.dart';
import 'package:e_wallet/models/qr_code.dart';
import 'package:e_wallet/screen/qr_payment_screen.dart';
import 'package:e_wallet/screen/qr_transfer_screen.dart';
import 'package:e_wallet/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = <Tab>[
    Tab(text: 'Pay'),
    Tab(text: 'Receive'),
  ];
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late TabController _tabController;
  String? _base64;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

    (() async {
      print('GetQrImage: Start');
      Customer? customer = await getCustomer();
      final response =
          await QrApiService().generateCustomerQr(customer!.customerId);
      if (mounted) {
        print('GetQrImage: mounted');
        if (response != null) {
          setState(() {
            print('GetQrImage: response.qrString => ${response.qrString}');
            _base64 = response.qrString;
          });
        } else {
          _base64 = "";
        }
      }
    })();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQrView(context),
          _buildQrGen(context),
        ],
      ),
    );
  }

  Widget _buildQrGen(BuildContext context) {
    if (_base64 == null) {
      return Container();
    } else {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: Image.memory(base64.decode(_base64!)),
      );
    }
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.dispose();
      await _handleQRCode(scanData.code);
    });
  }

  Future<void> _handleQRCode(String? qrData) async {
    if (qrData == null) return;

    final qrApiService = QrApiService();
    final qrCode = QrCode(qrString: qrData);
    final qrParseData = await qrApiService.parseQr(qrCode);

    if (qrParseData != null) {
      switch (qrParseData.trxType) {
        case 'CUS':
          // Handle QR Transfer
          await _handleQRTransfer(qrParseData.trxDetail);
          break;
        case 'MRC':
          // Handle QR Payment
          await _handleQRPayment(qrParseData.trxDetail);
          break;
        default:
          // Handle unknown txn type
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown QR code transaction type')),
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to parse QR code')),
      );
    }
  }

  Future<void> _handleQRTransfer(String mobileNumber) async {
    final transferApiService = TransferApiService();
    final beneficiary =
        await transferApiService.getRecipientByMobile(mobileNumber);

    if (beneficiary != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrTransferPage(
              recipientName: beneficiary.fullName,
              recipientMobile: mobileNumber),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beneficiary not found')),
      );
    }
  }

  Future<void> _handleQRPayment(String merchantCode) async {
    final merchantApiService = MerchantApiService();
    final merchant = await merchantApiService.getMerchantByCode(merchantCode);

    if (merchant != null) {
      final amount =
          await _getAmountFromUser('Pay to ${merchant.merchantName}');

      if (amount != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrPaymentPage(
                merchantName: merchant.merchantName,
                merchantCode: merchantCode),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merchant not found')),
      );
    }
  }

  Future<double?> _getAmountFromUser(String message) async {
    double? amount;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              amount = double.tryParse(value);
            },
            decoration: const InputDecoration(hintText: "Enter amount"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    return amount;
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
