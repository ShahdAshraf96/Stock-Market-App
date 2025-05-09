import 'package:stock_market_app/core/constants/app_assets.dart';
import 'package:stock_market_app/core/extensions/validations.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:stock_market_app/core/widgets/custom_elevated_button.dart';
import 'package:stock_market_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppAssets.logo,
                    width: size.width * 0.25,
                    height: size.height * 0.2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 33
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          text: "First Name",
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: CustomTextFormField(
                          text: "Last Name",
                          keyboardType: TextInputType.name,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 13),
                  CustomTextFormField(
                    controller: _emailController,
                    text: "Email",
                    keyboardType: TextInputType.emailAddress,
                    hint: "Ex@gmail.com",
                    enableSuggestions: true,
                    onValidate: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email address";
                      }
                      else if (!Validations.validateEmail(value)) {
                        return "Please enter your email address right";
                      }
                      return null;
                    }
                  ),
                  SizedBox(height: 13),
                  CustomTextFormField(
                    text: "Password",
                    controller: _passwordController,
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
                  SizedBox(height: 20),
                  CustomElevatedButton(
                    text: "Create acoount",
                    buttonColor: const Color(0xFF9966CC),
                    onTap: (){}
                  ),
                  SizedBox(height: 20),
                  Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              fontSize: 13
                            )
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, PageRouteNames.login);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            )
                          )
                        ]
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
