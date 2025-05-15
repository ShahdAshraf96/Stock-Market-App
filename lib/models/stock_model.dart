class Stock {
  final String ticker;
  final String company;
  final double price;
  final double change;
  final int volume;

  Stock({
    required this.ticker,
    required this.company,
    required this.price,
    required this.change,
    required this.volume,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      ticker: json['ticker'],
      company: json['company'],
      price: json['price'].toDouble(),
      change: json['change'].toDouble(),
      volume: json['volume'],
    );
  }
}
