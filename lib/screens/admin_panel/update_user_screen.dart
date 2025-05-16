import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();
  final _customerIdController = TextEditingController();
  bool _isAdmin = false;
  bool _userFound = false;
  bool _loading = false;

  Future<void> _searchUser() async {
    final username = _searchController.text.trim();
    if (username.isEmpty) return;

    try {
      setState(() {
        _loading = true;
        _userFound = false;
      });

      final doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _emailController.text = data['email'] ?? '';
        _customerIdController.text = data['customerId'] ?? '';
        _isAdmin = data['isAdmin'] ?? false;

        setState(() {
          _userFound = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateUser() async {
    final username = _searchController.text.trim();

    if (username.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and Email are required')),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      await FirebaseFirestore.instance.collection('usernames').doc(username).update({
        'email': _emailController.text.trim(),
        'customerId': _customerIdController.text.trim(),
        'isAdmin': _isAdmin,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
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
      appBar: AppBar(title: const Text('Update User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loading ? null : _searchUser,
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_userFound) ...[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isAdmin,
                onChanged: (val) => setState(() => _isAdmin = val),
                title: const Text('Is Admin'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _updateUser,
                icon: const Icon(Icons.save),
                label: const Text('Update User'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
