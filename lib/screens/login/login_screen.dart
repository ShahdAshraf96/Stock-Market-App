import 'package:stock_market/core/constants/app_assets.dart';
import 'package:stock_market/core/extensions/validations.dart';
import 'package:stock_market/core/routes/page_route_names.dart';
import 'package:stock_market/core/theme/app_colors.dart';
import 'package:stock_market/core/widgets/custom_elevated_button.dart';
import 'package:stock_market/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

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
                    "Log in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 33
                    ),
                  ),
                  SizedBox(height: 40),
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
                      }
                      else if (!Validations.validateEmail(value)) {
                        return "Please enter your email address right";
                      }
                      return null;
                    }
                  ),
                  SizedBox(height: 12),
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
                  CheckboxListTile(
                    title: Text(
                      "Remeber me",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    value: _rememberMe,
                    activeColor: AppColors.black,
                    checkColor: AppColors.white,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CustomElevatedButton(
                    text: "Login",
                    buttonColor: AppColors.red,
                    onTap: (){
                      Navigator.pushNamed(context, PageRouteNames.homePage, arguments: {'title': "Home"});
                    }
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRouteNames.forgetPassword);
                        },
                        child: Wrap(
                          children: [
                            Text(
                              'Forgot your password?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.red,
                            )
                          ]
                        ),
                      )
                    ],
                  ),
                  Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13
                            )
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, PageRouteNames.createAccount);
                              },
                              child: Text(
                                "Create account",
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
