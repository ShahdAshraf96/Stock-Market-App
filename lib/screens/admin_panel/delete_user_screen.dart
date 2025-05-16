import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({super.key});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  final _usernameController = TextEditingController();
  bool _loading = false;
  String? _email;
  String? _customerId;
  bool _found = false;

  Future<void> _searchUser() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    try {
      setState(() {
        _loading = true;
        _found = false;
        _email = null;
        _customerId = null;
      });

      final doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _email = data['email'] ?? '';
        _customerId = data['customerId'] ?? '';
        setState(() => _found = true);
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

  Future<void> _confirmDelete() async {
    final username = _usernameController.text.trim();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete user "$username"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteUser(username);
    }
  }

  Future<void> _deleteUser(String username) async {
    try {
      setState(() => _loading = true);

      await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );

      _usernameController.clear();
      setState(() {
        _found = false;
        _email = null;
        _customerId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Enter Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loading ? null : _searchUser,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_found) ...[
              Text("Email: $_email"),
              Text("Customer ID: $_customerId"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                onPressed: _loading ? null : _confirmDelete,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                label: const Text("Delete User"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
