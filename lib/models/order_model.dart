// order_model.dart

class OrderModel {
  final String stockName;
  final double price;
  final int quantity;
  final String orderType; // e.g., Limit, Market
  final String? settlement; // T+0, T+1, T+2
  final String validity; // Day, Good Till Date
  final String custodian;
  final String executionRule; // REGULAR, FOK, IOC
  final bool isPrivate;
  final bool isConditional;
  final bool isBuy;
  final DateTime timestamp;
  final String userId;

  OrderModel({
    required this.userId,
    required this.stockName,
    required this.price,
    required this.quantity,
    required this.orderType,
    required this.settlement,
    required this.validity,
    required this.custodian,
    required this.executionRule,
    required this.isPrivate,
    required this.isConditional,
    required this.isBuy,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'stockName': stockName,
      'price': price,
      'quantity': quantity,
      'orderType': orderType,
      'settlement': settlement ?? "",
      'validity': validity,
      'custodian': custodian,
      'executionRule': executionRule,
      'isPrivate': isPrivate,
      'isConditional': isConditional,
      'isBuy': isBuy,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
    };
  }

  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      stockName: map['stockName'],
      price: map['price'],
      quantity: map['quantity'],
      orderType: map['orderType'],
      settlement: map['settlement'],
      validity: map['validity'],
      custodian: map['custodian'],
      executionRule: map['executionRule'],
      isPrivate: map['isPrivate'],
      isConditional: map['isConditional'],
      isBuy: map['isBuy'],
      timestamp: DateTime.parse(map['timestamp']),
      userId: map['userId'],
    );
  }
}

