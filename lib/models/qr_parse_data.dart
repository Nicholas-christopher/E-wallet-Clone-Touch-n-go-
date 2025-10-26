class QrParseData {
  final String trxType;
  final String trxDetail;

  QrParseData({required this.trxType, required this.trxDetail});

  factory QrParseData.fromJson(Map<String, dynamic> json) {
    return QrParseData(
      trxType: json['trxType'],
      trxDetail: json['trxDetail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trxType': trxType,
      'trxDetail': trxDetail,
    };
  }
}
