import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceService {
  static Future<String> generateSerial() async {
    final ref = FirebaseFirestore.instance.collection('invoice_metadata').doc('serial');

    // Atomically increment serial number
    await ref.set({'lastSerial': FieldValue.increment(1)}, SetOptions(merge: true));

    final updated = await ref.get();
    final lastSerial = updated.data()?['lastSerial'] ?? 2025000;

    return 'INV-$lastSerial';
  }

  static Future<void> saveInvoiceToFirestore({
    required Map<String, dynamic> stock,
    required String customerName,
    required String customerId,
    required int quantity,
    required bool isBuy,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("No user logged in");
    }

    // Fetch fees
    final feesDoc = await FirebaseFirestore.instance
        .collection('billing_config')
        .doc('fees')
        .get();

    final fees = feesDoc.data()!;
    final broker = (fees['brokerFee'] as num).toDouble();
    final exchange = (fees['exchangeFee'] as num).toDouble();
    final fra = (fees['fraFee'] as num).toDouble();

    final double price = stock['price'];
    final double base = price * quantity;
    final double totalFees = base * (broker + exchange + fra);
    final double finalAmount = base + totalFees;

    final serial = await generateSerial();

    await FirebaseFirestore.instance.collection('invoices').add({
      'userId': uid,
      'customerName': customerName,
      'customerId': customerId,
      'isBuy': isBuy,
      'stock': stock,
      'quantity': quantity,
      'fees': {
        'broker': broker,
        'exchange': exchange,
        'fra': fra,
      },
      'finalAmount': finalAmount,
      'timestamp': FieldValue.serverTimestamp(),
      'serial': serial,
    });
  }
}
