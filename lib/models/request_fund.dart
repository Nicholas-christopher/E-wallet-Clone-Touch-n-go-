class RequestFund {
  final int requestId;
  final int customerId;
  final int beneCustomerId;
  final DateTime requestDate;
  final String status;
  final double amount;
  final String? requestDetail;

  RequestFund({
    required this.requestId,
    required this.customerId,
    required this.beneCustomerId,
    required this.requestDate,
    required this.status,
    required this.amount,
    this.requestDetail,
  });

  factory RequestFund.fromJson(Map<String, dynamic> json) {
    return RequestFund(
      requestId: json['requestId'] as int,
      customerId: json['customerId'] as int,
      beneCustomerId: json['beneCustomerId'] as int,
      requestDate: DateTime.parse(json['requestDate'] as String),
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      requestDetail: json['requestDetail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'customerId': customerId,
      'beneCustomerId': beneCustomerId,
      'requestDate': requestDate.toIso8601String(),
      'status': status,
      'amount': amount,
      'requestDetail': requestDetail,
    };
  }
}
