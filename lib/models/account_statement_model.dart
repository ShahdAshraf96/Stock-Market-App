import 'package:stock_market_app/models/stock_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountStatement {
  final String userId;
  final Stock stock;
  final bool isBuy;
  final int quantity;
  final DateTime date;

  AccountStatement({
    required this.stock,
    required this.isBuy,
    required this.quantity,
    required this.date,
    required this.userId,
  });

  factory AccountStatement.fromJson(Map<String, dynamic> json) {
    final dynamic dateField = json['date'];
    DateTime parsedDate;

    if (dateField is Timestamp) {
      parsedDate = dateField.toDate();
    } else if (dateField is String) {
      parsedDate = DateTime.tryParse(dateField) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }
    return AccountStatement(
      stock: Stock.fromJson(json['stock']),
      isBuy: json['isBuy'],
      quantity: json['quantity'],
      date: parsedDate,
      userId: json['userId'],

    );
  }
}
