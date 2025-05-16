import '../../../models/eodhd_stock_model.dart';

class OrderController {
  static EodhdStock? selectedStock;
  static Map<String, dynamic>? quoteData;

  static String lastPrice = "0.00";
  static String change = "NA";
  static String bestBid = "0.00";
  static String bestAsk = "0.00";

  static void setSelectedStock(EodhdStock stock, Map<String, dynamic> quote) {
    selectedStock = stock;
    quoteData = quote;

    lastPrice = quote['close']?.toString() ?? "0.00";
    change = "NA";
    bestBid = "0.00";
    bestAsk = "0.00";
  }
}
