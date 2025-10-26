class TopUpRequest {
  final int accountId;
  final double amount;
  final String cardNo;
  final String docIndicator;
  final String cardHolderName;

  TopUpRequest({
    required this.accountId,
    required this.amount,
    required this.cardNo,
    required this.docIndicator,
    required this.cardHolderName,
  });

  factory TopUpRequest.fromJson(Map<String, dynamic> json) {
    return TopUpRequest(
        accountId: json["accountId"],
        amount: json["amount"],
        cardNo: json["cardNo"],
        docIndicator: json["docIndicator"],
        cardHolderName: json["cardHolderName"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'amount': amount,
      'cardNo': cardNo,
      'docIndicator': docIndicator,
      'cardHolderName': cardHolderName,
    };
  }
}
