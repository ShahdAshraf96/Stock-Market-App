import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_market_app/core/extensions/validations.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:stock_market_app/core/widgets/custom_elevated_button.dart';
import 'package:stock_market_app/core/widgets/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submitResetRequest() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (username.isEmpty || email.isEmpty || !Validations.validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid username and email.")),
      );
      return;
    }

    // Check if username exists in Firestore and email matches
    final doc = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(username)
        .get();

    if (!doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username not found.")),
      );
      return;
    }

    final storedEmail = doc.data()?['email'];
    if (storedEmail != email) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email does not match the registered email.")),
      );
      return;
    }

    // Proceed to submit request
    try {
      await FirebaseFirestore.instance.collection('reset_requests').add({
        'username': username,
        'email': email,
        'message': "Request Password Reset",
        'timestamp': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request sent to admin.")),
      );

      _usernameController.clear();
      _emailController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting request: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text("Forgot Password", style: TextStyle(fontSize: 33)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
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
                text: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hint: "Ex@gmail.com",
                enableSuggestions: true,
                hintColor: Colors.grey,
                onValidate: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email address";
                  } else if (!Validations.validateEmail(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 12),
              // CustomTextFormField(
              //   text: "Message (optional)",
              //   controller: _messageController,
              //   keyboardType: TextInputType.text,
              //   hint: "Type anything if needed...",
              //   maxLines: 2,
              //   enableSuggestions: true,
              //   hintColor: Colors.grey,
              //   onValidate: (value) => null,
              // ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: "Send",
                  buttonColor: const Color(0xFF9966CC),
                  onTap: _submitResetRequest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
