import 'package:stock_market/core/extensions/validations.dart';
import 'package:stock_market/core/theme/app_colors.dart';
import 'package:stock_market/core/widgets/custom_elevated_button.dart';
import 'package:stock_market/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "New Password",
          style: TextStyle(
            fontSize: 33
          )
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                runSpacing: 20,
                children: [
                  CustomTextFormField(
                    text: "New password",
                    controller: _passwordController1,
                    isPassword: true,
                    maxLines: 1,
                    onValidate: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your password";
                      }
                      else if (!Validations.validatePassword(value)) {
                        return "Please enter your password right";
                      }
                      return null;
                    }
                  ),
                  CustomTextFormField(
                    text: "Confirm new password",
                    controller: _passwordController2,
                    isPassword: true,
                    maxLines: 1,
                    onValidate: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your password";
                      }
                      else if (!Validations.validatePassword(value)) {
                        return "Please enter your password right";
                      }
                      return null;
                    }
                  ),
                ],
              ),
              CustomElevatedButton(
                text: "Reset Password",
                buttonColor: AppColors.red,
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
