import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminResetRequestsScreen extends StatelessWidget {
  const AdminResetRequestsScreen({super.key});

  Future<void> _sendResetEmail(
      BuildContext context,
      String email,
      String docId,
      String username,
      ) async {
    try {
      // 1. Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // 2. Set forcePasswordChange = true for the user
      await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .update({'forcePasswordChange': true});

      // 3. Delete the reset request
      await FirebaseFirestore.instance
          .collection('reset_requests')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent to $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Reset Requests')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('reset_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reset requests found'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data();
              final docId = requests[index].id;
              final username = data['username'] ?? 'Unknown';
              final email = data['email'] ?? 'Unknown';
              final message = data['message'] ?? '';
              final timestampRaw = data['timestamp'];
              final timestamp = timestampRaw is Timestamp
                  ? timestampRaw.toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Username: $username'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $email'),
                      if (message.isNotEmpty) Text('Message: $message'),
                      Text('Date: ${timestamp.toString()}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.email_outlined, color: Colors.blue),
                    onPressed: () =>
                        _sendResetEmail(context, email, docId, username),
                    tooltip: 'Send Reset Email',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
