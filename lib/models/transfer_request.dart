class TransferRequest {
  final int debitorId;
  final String? creditorMobileNumber;
  final double amount;
  final String? transferDetail;

  TransferRequest({
    required this.debitorId,
    this.creditorMobileNumber,
    required this.amount,
    this.transferDetail,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) {
    return TransferRequest(
      debitorId: json['debitorId'] ?? 0,
      creditorMobileNumber: json['creditorMobileNumber'] ?? '',
      amount: json['amount'] ?? 0.0,
      transferDetail: json['transferDetail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debitorId': debitorId,
      'creditorMobileNumber': creditorMobileNumber,
      'amount': amount,
      'transferDetail': transferDetail,
    };
  }
}
