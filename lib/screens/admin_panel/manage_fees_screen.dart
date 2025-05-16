import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageFeesScreen extends StatefulWidget {
  const ManageFeesScreen({super.key});

  @override
  State<ManageFeesScreen> createState() => _ManageFeesScreenState();
}

class _ManageFeesScreenState extends State<ManageFeesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brokerController = TextEditingController();
  final _exchangeController = TextEditingController();
  final _fraController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingFees();
  }

  Future<void> _loadExistingFees() async {
    final doc = await FirebaseFirestore.instance
        .collection('billing_config')
        .doc('fees')
        .get();

    final data = doc.data();
    if (data != null) {
      _brokerController.text = data['brokerFee']?.toString() ?? '';
      _exchangeController.text = data['exchangeFee']?.toString() ?? '';
      _fraController.text = data['fraFee']?.toString() ?? '';
    }
  }

  Future<void> _saveFees() async {
    if (!_formKey.currentState!.validate()) return;

    final broker = double.tryParse(_brokerController.text);
    final exchange = double.tryParse(_exchangeController.text);
    final fra = double.tryParse(_fraController.text);

    if (broker == null || exchange == null || fra == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid numeric fee values')),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      await FirebaseFirestore.instance
          .collection('billing_config')
          .doc('fees')
          .set({
        'brokerFee': broker,
        'exchangeFee': exchange,
        'fraFee': fra,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fees updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Billing Fees')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _brokerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Broker Fee'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _exchangeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Exchange Fee'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fraController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'FRA Fee'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _saveFees,
                icon: const Icon(Icons.save),
                label: const Text('Save Fees'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
