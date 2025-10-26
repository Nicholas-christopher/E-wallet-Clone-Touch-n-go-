import 'package:intl/intl.dart';

class AccountHistory {
  final int historyId;
  final String trxRefNo;
  final int accountId;
  final String trxCode;
  final DateTime trxDate;
  final double amount;
  final String docIndicator;
  final String? sobName;
  final String? trxDetail;

  AccountHistory({
    required this.historyId,
    required this.trxRefNo,
    required this.accountId,
    required this.trxCode,
    required this.trxDate,
    required this.amount,
    required this.docIndicator,
    this.sobName,
    this.trxDetail,
  });

  factory AccountHistory.fromJson(Map<String, dynamic> json) {
    return AccountHistory(
      historyId: json['historyId'],
      trxRefNo: json['trxRefNo'],
      accountId: json['accountId'],
      trxCode: json['trxCode'],
      trxDate: (json['trxDate'].toString().contains(".")
          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(json['trxDate'])
          : DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json['trxDate'])),
      amount: json['amount'],
      docIndicator: json['docIndicator'],
      sobName: json['sobName'],
      trxDetail: json['trxDetail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'historyId': historyId,
      'trxRefNo': trxRefNo,
      'accountId': accountId,
      'trxCode': trxCode,
      'trxDate': trxDate,
      'amount': amount,
      'docIndicator': docIndicator,
      'sobName': sobName,
      'trxDetail': trxDetail,
    };
  }
}
