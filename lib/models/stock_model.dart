class Stock {
  final String ticker;
  final String company;
  final double price;
  final double change;// price change
  final int volume;// quantity of buy or selling

  Stock({
    required this.ticker,
    required this.company,
    required this.price,
    required this.change,
    required this.volume,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      ticker: json['ticker'] ?? '',
      company: json['company'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      change: (json['change'] ?? 0).toDouble(),
      volume: json['volume'] ?? 0,
    );
  }

}
