import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/eodhd_stock_model.dart';

class EodhdApiService {
  static const _apiKey = '682098583ea398.53305105'; // your actual API key
  static const _base = 'https://eodhd.com/api';

  // 1. Get all Egyptian stocks
  static Future<List<EodhdStock>> fetchEgyptStocks() async {
    final url = Uri.parse("$_base/exchange-symbol-list/EGX?api_token=$_apiKey&fmt=json");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List jsonData = json.decode(res.body);
      return jsonData.map((e) => EodhdStock.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load stock list.");
    }
  }

  // 2. Get end-of-day stock details for one ticker
  static Future<Map<String, dynamic>> fetchEodData(String code) async {
    final url = Uri.parse("$_base/eod/$code.EGX?api_token=$_apiKey&fmt=json");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      if (data.isNotEmpty) {
        return {
          'close': data[0]['close'] ?? 0.0,
          'volume': data[0]['volume'] ?? 0,
          'date': data[0]['date'] ?? '',
        };
      }
    }
    return {};
  }
}
