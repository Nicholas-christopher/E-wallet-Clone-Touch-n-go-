class RequestFundApproval {
  final int customerId;

  RequestFundApproval({required this.customerId});

  factory RequestFundApproval.fromJson(Map<String, dynamic> json) {
    return RequestFundApproval(
      customerId: json['customerId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
    };
  }
}
