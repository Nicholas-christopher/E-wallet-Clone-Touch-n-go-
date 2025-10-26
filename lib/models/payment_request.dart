class PaymentRequest {
  final int debitorId;
  final String merchantCode;
  final double amount;

  PaymentRequest(
      {required this.debitorId,
      required this.merchantCode,
      required this.amount});

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      debitorId: json['debitorId'],
      merchantCode: json['merchantCode'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debitorId': debitorId,
      'merchantCode': merchantCode,
      'amount': amount,
    };
  }
}
