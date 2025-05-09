import 'package:stock_market_app/core/extensions/validations.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:stock_market_app/core/widgets/custom_elevated_button.dart';
import 'package:stock_market_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool _goodEmail = false;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Forgot Password",
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
              CustomTextFormField(
                text: "Email",
                keyboardType: TextInputType.emailAddress,
                hint: "Ex@gmail.com",
                enableSuggestions: true,
                hintColor: Colors.grey,
                onValidate: (value) {
                  if (value == null || value.trim().isEmpty) {
                    _goodEmail = false;
                    return "Please enter your email address";
                  }
                  else if (!Validations.validateEmail(value)) {
                    _goodEmail = false;
                    return "Please enter your email address right";
                  }
                  _goodEmail = true;
                  return null;
                }
              ),
              CustomElevatedButton(
                text: "Next",
                buttonColor:const Color(0xFF9966CC),
                onTap: () {
                  if (_goodEmail) Navigator.pushNamed(context, PageRouteNames.otp);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
