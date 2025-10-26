class QrCode {
  final String qrString;

  QrCode({required this.qrString});

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      qrString: json['qrString'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrString': qrString,
    };
  }
}
