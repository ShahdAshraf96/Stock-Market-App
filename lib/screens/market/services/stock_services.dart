import 'package:http/http.dart' as http;
import 'dart:convert';


class StockService {
  final String _apiKey = '6824d81abb4174.09551585';
  final List<String> symbols = [
    'AAPL.US',
    'TSLA.US',
    'GOOGL.US',
    'MSFT.US',
    'AMZN.US',
    'META.US',
    'NVDA.US',
    'NFLX.US',
    'DIS.US',
    'INTC.US',
  ];

  Future<List<Map<String, String>>> fetchTopGainers() async {
    return _fetchStocks((change) => change > 0);
  }

  Future<List<Map<String, String>>> fetchTopLosers() async {
    return _fetchStocks((change) => change < 0);
  }

  Future<List<Map<String, String>>> _fetchStocks(bool Function(double) condition) async {
    final List<Map<String, String>> stocks = [];

    for (final symbol in symbols) {
      final uri = Uri.parse('https://corsproxy.io/?https://eodhd.com/api/real-time/$symbol?api_token=$_apiKey&fmt=json');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final change = data['change']?.toDouble() ?? 0;

          if (condition(change)) {
            stocks.add({
              'symbol': data['code'],
              'price': data['close'].toString(),
              'change': '${data['change_p']}%',
              'diff': data['change'].toString(),
              'vol': data['volume'].toString(),
            });
          }
        } catch (_) {
          continue;
        }
      }
    }
    return stocks;
  }
}
