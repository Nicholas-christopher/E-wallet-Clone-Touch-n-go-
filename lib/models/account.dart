class Account {
  final int accountId;
  final int customerId;
  double balance;

  Account({
    required this.accountId,
    required this.customerId,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'] as int,
      customerId: json['customerId'] as int,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'customerId': customerId,
      'balance': balance,
    };
  }

  void updateBalance(double amount) {
    balance = amount;
  }
}
