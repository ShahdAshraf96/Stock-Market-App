import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/order_model.dart';
import '../services/order_service.dart';
import '../services/invoice_service.dart';

class OrderController {
  final OrderService _orderService = OrderService();

  Future<void> placeNewOrder({
    required OrderModel order,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    final uid = user.uid;

    // Fetch username & customerId from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(uid)
        .get();

    final customerName = userDoc.data()?['username'] ?? 'Unknown';
    final customerId = userDoc.data()?['customerId'] ?? uid;

    // Fetch current billing fees from Firestore
    final billingDoc = await FirebaseFirestore.instance
        .collection('billing_config')
        .doc('fees')
        .get();

    final brokerFee = (billingDoc.data()?['brokerFee'] ?? 0.0).toDouble();
    final exchangeFee = (billingDoc.data()?['exchangeFee'] ?? 0.0).toDouble();
    final fraFee = (billingDoc.data()?['fraFee'] ?? 0.0).toDouble();

    final total = order.price * order.quantity;
    final totalFees = total * (brokerFee + exchangeFee + fraFee);
    final finalAmount = order.isBuy ? total + totalFees : total - totalFees;

    final now = Timestamp.now();

    // Save to 'orders'
    await FirebaseFirestore.instance.collection('orders').add(order.toMap());

    // Save to 'account_statements'
    await FirebaseFirestore.instance.collection('account_statements').add({
      'userId': uid,
      'date': now,
      'isBuy': order.isBuy,
      'quantity': order.quantity,
      'stock': {
        'company': order.stockName,
        'price': order.price,
      },
    });

    // Save to 'invoices'
    await FirebaseFirestore.instance.collection('invoices').add({
      'customerId': customerId,
      'customerName': customerName,
      'quantity': order.quantity,
      'isBuy': order.isBuy,
      'timestamp': now,
      'stock': {
        'company': order.stockName,
        'ticker': '', // optional
        'price': order.price,
        'change': 0.0, // optional
        'volume': order.quantity,
      },
      'fees': {
        'broker': brokerFee,
        'exchange': exchangeFee,
        'fra': fraFee,
      },
      'finalAmount': finalAmount,
    });
  }

}
