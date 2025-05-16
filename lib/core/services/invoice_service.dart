import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceService {
  static Future<String> generateSerial() async {
    final docRef = FirebaseFirestore.instance.collection('invoice_metadata').doc('serial');
    final doc = await docRef.get();

    int lastSerial = doc.data()?['lastSerial'] ?? 2025000;
    int newSerial = lastSerial + 1;

    await docRef.set({'lastSerial': newSerial});
    return "INV-$newSerial";
  }

  static Future<void> saveInvoiceToFirestore({
    required String uid,
    required bool isBuy,
    required Map<String, dynamic> stock,
    required int quantity,
    required double price,
    required double broker,
    required double exchange,
    required double fra,
  }) async {
    //  Debug log to verify uid is passed
    print("Saving invoice for UID: $uid");

    // Step 1: Lookup user by UID in 'usernames' collection
    String customerName = "Unknown";
    String customerId = "";

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usernames')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();
        customerName = userDoc['username'] ?? "Unknown";
        customerId = userDoc['customerId'] ?? "";
      } else {
        print("No user found for UID: $uid");
      }
    } catch (e) {
      print("Error fetching user info for invoice: $e");
    }

    // Step 2: Calculate fields
    final double base = price * quantity;
    final double totalFees = base * (broker + exchange + fra);
    final double finalAmount = base + totalFees;
    final serial = await generateSerial();

    // Step 3: Save invoice
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

    print("Invoice saved for $customerName [$customerId]");
  }
}
