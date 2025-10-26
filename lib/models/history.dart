class History {
  final int historyId;
  final int customerId;
  final String trxRefNo;
  final DateTime histDate;
  final String trxCode;
  final String? histDetail;

  History({
    required this.historyId,
    required this.customerId,
    required this.trxRefNo,
    required this.histDate,
    required this.trxCode,
    this.histDetail,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      historyId: json['historyId'] as int,
      customerId: json['customerId'] as int,
      trxRefNo: json['trxRefNo'] as String,
      histDate: DateTime.parse(json['histDate'] as String),
      trxCode: json['trxCode'] as String,
      histDetail: json['histDetail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'historyId': historyId,
      'customerId': customerId,
      'trxRefNo': trxRefNo,
      'histDate': histDate.toIso8601String(),
      'trxCode': trxCode,
      'histDetail': histDetail,
    };
  }
}
