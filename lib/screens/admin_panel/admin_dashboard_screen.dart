import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import 'admin_reset_requests_screen.dart';
import 'create_user_screen.dart';
import 'update_user_screen.dart';
import 'delete_user_screen.dart';
import 'set_balance_screen.dart';
import 'manage_fees_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_AdminAction> actions = [
      _AdminAction(
        title: 'Create User',
        icon: Icons.person_add,
        screen: const CreateUserScreen(),
      ),
      _AdminAction(
        title: 'Update User',
        icon: Icons.edit,
        screen: const UpdateUserScreen(),
      ),
      _AdminAction(
        title: 'Delete User',
        icon: Icons.delete,
        screen: const DeleteUserScreen(),
      ),
      _AdminAction(
        title: 'Set User Balance',
        icon: Icons.account_balance,
        screen: const SetBalanceScreen(),
      ),
      _AdminAction(
        title: 'Manage Fees',
        icon: Icons.money,
        screen: const ManageFeesScreen(),
      ),
      _AdminAction(
        title: 'Requests',
        icon: Icons.request_page,
        screen: const AdminResetRequestsScreen(),
      ),
      _AdminAction(
        title: 'Exit',
        icon: Icons.logout,
        screen: const SizedBox(), // we'll handle it manually
      ),

    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView.separated(
        itemCount: actions.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final action = actions[index];
          return ListTile(
            leading: Icon(action.icon, color: Colors.deepPurple),
            title: Text(action.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              if (action.title == 'Exit') {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => action.screen),
                );
              }
            },

          );
        },
      ),
    );
  }
}

class _AdminAction {
  final String title;
  final IconData icon;
  final Widget screen;

  _AdminAction({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
