import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moon/logger/logger.dart';

class PriceManager {
  Future<double> getPrice() async {
    try {
      final result = await http.get(Uri.parse(
          "https://api.binance.com/api/v3/ticker/price?symbol=BNBUSDT"));
      final price = double.parse(json.decode(result.body)["price"]);
      return price;
    } catch (e) {
      logError("Error: $e");
      return 0;
    }
  }
}
