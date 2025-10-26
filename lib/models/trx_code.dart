class TrxCode {
  final String code;
  final String description;

  TrxCode({
    required this.code,
    required this.description,
  });

  factory TrxCode.fromJson(Map<String, dynamic> json) {
    return TrxCode(
      code: json['code'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
    };
  }
}
