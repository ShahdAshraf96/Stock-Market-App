import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetBalanceScreen extends StatefulWidget {
  const SetBalanceScreen({super.key});

  @override
  State<SetBalanceScreen> createState() => _SetBalanceScreenState();
}

class _SetBalanceScreenState extends State<SetBalanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final balance = double.tryParse(_balanceController.text.trim());

    if (balance == null || balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive number')),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      // Step 1: Get UID from usernames/{username}
      final snapshot = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (!snapshot.exists || snapshot.data()?['uid'] == null) {
        throw Exception('User not found or missing UID');
      }

      final uid = snapshot.data()!['uid'];

      // Step 2: Save balance to account_balances/{uid}
      await FirebaseFirestore.instance
          .collection('account_balances')
          .doc(uid)
          .set({
        'openingBalance': balance,
        'endingBalance': balance,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Balance set successfully')),
      );

      _formKey.currentState!.reset();
      _usernameController.clear();
      _balanceController.clear();
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
      appBar: AppBar(title: const Text('Set Opening Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(labelText: 'Opening Balance'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                val == null || val.isEmpty ? 'Enter a balance' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: const Icon(Icons.check),
                label: const Text("Set Balance"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
