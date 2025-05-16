import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';


class OrderService {
  final CollectionReference _orderRef = FirebaseFirestore.instance.collection('orders');

  Future<void> saveOrder(OrderModel order) async {
    try {
      await _orderRef.add(order.toMap());
      print('Order saved successfully');
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> fetchOrders({bool? isBuy}) async {
    try {
      QuerySnapshot snapshot = await _orderRef
          .where('isBuy', isEqualTo: isBuy)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }
}
