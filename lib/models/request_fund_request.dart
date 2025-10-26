class RequestFundRequest {
  final int creditorCustomerId;
  final String? debitorMobileNumber;
  final double amount;
  final String? requestDetail;

  RequestFundRequest({
    required this.creditorCustomerId,
    this.debitorMobileNumber,
    required this.amount,
    this.requestDetail,
  });

  factory RequestFundRequest.fromJson(Map<String, dynamic> json) {
    return RequestFundRequest(
      creditorCustomerId: json['creditorCustomerId'] as int,
      debitorMobileNumber: json['debitorMobileNumber'] as String?,
      amount: (json['amount'] as num).toDouble(),
      requestDetail: json['requestDetail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creditorCustomerId': creditorCustomerId,
      'debitorMobileNumber': debitorMobileNumber,
      'amount': amount,
      'requestDetail': requestDetail,
    };
  }
}
