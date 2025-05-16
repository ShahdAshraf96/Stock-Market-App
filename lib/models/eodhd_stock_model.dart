class EodhdStock {
  final String code;
  final String name;
  final String exchange;
  final String currency;
  final String type;

  EodhdStock({
    required this.code,
    required this.name,
    required this.exchange,
    required this.currency,
    required this.type,
  });

  factory EodhdStock.fromJson(Map<String, dynamic> json) {
    return EodhdStock(
      code: json['Code'],
      name: json['Name'],
      exchange: json['Exchange'],
      currency: json['Currency'],
      type: json['Type'],
    );
  }
}
