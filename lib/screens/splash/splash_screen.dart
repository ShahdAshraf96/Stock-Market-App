import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:stock_market_app/core/constants/app_assets.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Duration _duration = Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, PageRouteNames.login);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ZoomIn(
              duration: _duration,
              child: Image.asset(AppAssets.logo)
            )
          ),
        ],
      ),
    );
  }
}
