import 'package:stock_market_app/core/constants/app_assets.dart';
import 'package:stock_market_app/core/extensions/validations.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/core/theme/app_colors.dart';
import 'package:stock_market_app/core/widgets/custom_elevated_button.dart';
import 'package:stock_market_app/core/widgets/custom_text_form_field.dart';
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
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Image.asset(
                        AppAssets.logo,
                        width: size.width * 0.25,
                        height: size.height * 0.2,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Log in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
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
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        text: "Password",
                        controller: _passwordController,
                        isPassword: true,
                        maxLines: 1,
                        onValidate: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your password";
                          } else if (!Validations.validatePassword(value)) {
                            return "Please enter a valid password";
                          }
                          return null;
                        },
                      ),
                      CheckboxListTile(
                        title: const Text(
                          "Remember me",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
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
                        buttonColor: const Color(0xFF9966CC), // Amethyst color
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageRouteNames.homePage,
                            arguments: {'title': "Home"},
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageRouteNames.forgetPassword);
                          },
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9966CC), // Amethyst
                            ),
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
