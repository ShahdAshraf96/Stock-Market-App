import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_market_app/core/constants/app_assets.dart';
import 'package:stock_market_app/core/extensions/validations.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:stock_market_app/core/widgets/custom_elevated_button.dart';
import 'package:stock_market_app/core/widgets/custom_text_form_field.dart';
import 'package:stock_market_app/core/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import '../admin_panel/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _rememberMe = false;

  Future<String?> _getEmailFromUsername(String username) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();
      if (doc.exists) {
        final data = doc.data();
        return data?['email'];
      } else {
        return null;
      }

    } catch (e) {
      return null;
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both username and password")),
      );
      return;
    }

    final email = await _getEmailFromUsername(username);
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No account found for this username")),
      );
      return;
    }

    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('usernames')
            .doc(username)
            .get();

        final isAdmin = doc.data()?['isAdmin'] ?? false;
        final forceChange = doc.data()?['forcePasswordChange'] ?? false;

        if (isAdmin == true) {
          Navigator.pushReplacementNamed(context, PageRouteNames.adminDashboard);
          return;
        }

        if (forceChange) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Change Password"),
              content: const Text("You are using a temporary password. Would you like to change it now?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, PageRouteNames.homePage, arguments: {'title': 'Home'}),
                  child: const Text("Later"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      PageRouteNames.changePassword,
                      arguments: {'username': username},
                    );
                  },
                  child: const Text("Change Now"),
                ),
              ],
            ),
          );
        } else {
          Navigator.pushNamed(context, PageRouteNames.homePage, arguments: {'title': 'Home'});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Image.asset(AppAssets.logo, width: size.width * 0.25, height: size.height * 0.2),
                      const SizedBox(height: 20),
                      const Text("Log in", textAlign: TextAlign.center, style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        text: "Username",
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        hint: "Enter your username",
                        enableSuggestions: true,
                        hintColor: Colors.grey,
                        onValidate: (value) => null,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        text: "Password",
                        controller: _passwordController,
                        isPassword: true,
                        maxLines: 1,
                        onValidate: (value) => null,
                      ),
                      CheckboxListTile(
                        title: const Text("Remember me", style: TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w500)),
                        value: _rememberMe,
                        activeColor: AppColors.black,
                        checkColor: AppColors.white,
                        onChanged: (value) => setState(() => _rememberMe = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CustomElevatedButton(
                        text: "Login",
                        buttonColor: const Color(0xFF9966CC),
                        onTap: _login,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, PageRouteNames.forgetPassword),
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF9966CC)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
