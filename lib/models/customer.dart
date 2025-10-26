class Customer {
  final int customerId;
  final String fullName;
  final String mobileNo;
  final String email;
  final String password;
  final String status;
  final String pin;

  Customer({
    required this.customerId,
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.password,
    required this.status,
    required this.pin,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'] ?? 0,
      fullName: json['fullName'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      status: json['status'] ?? '',
      pin: json['pin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'fullName': fullName,
      'mobileNo': mobileNo,
      'email': email,
      'password': password,
      'status': status,
      'pin': pin,
    };
  }
}
