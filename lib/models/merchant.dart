class Merchant {
  final int merchantId;
  final String merchantCode;
  final String merchantName;

  Merchant({
    required this.merchantId,
    required this.merchantCode,
    required this.merchantName,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchantId'],
      merchantCode: json['merchantCode'],
      merchantName: json['merchantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantCode': merchantCode,
      'merchantName': merchantName,
    };
  }
}
