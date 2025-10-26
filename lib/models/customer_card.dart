class CustomerCard {
  final int cardId;
  final int customerId;
  final String cardNo;
  final String expDate;
  final int secCode;
  final String cardHname;
  final String docIndicator;

  CustomerCard(
      {required this.cardId,
      required this.customerId,
      required this.cardNo,
      required this.expDate,
      required this.secCode,
      required this.cardHname,
      required this.docIndicator});

  factory CustomerCard.fromJson(Map<String, dynamic> json) {
    return CustomerCard(
        cardId: json['cardId'] ?? 0,
        customerId: json['customerId'] ?? 0,
        cardNo: json['cardNo'] ?? '',
        expDate: json['expDate'] ?? '',
        secCode: json['secCode'] ?? 0,
        cardHname: json['cardHname'] ?? '',
        docIndicator: json['docIndicator'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'customerId': customerId,
      'cardNo': cardNo,
      'expDate': expDate,
      'secCode': secCode,
      'cardHname': cardHname,
      'docIndicator': docIndicator
    };
  }
}
