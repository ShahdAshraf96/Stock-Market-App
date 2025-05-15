import 'package:flutter/material.dart';

class MyStocksPage extends StatelessWidget {
  const MyStocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // LTR layout
      child: Scaffold(
        appBar: AppBar(title: const Text('Portfolio')),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.teal.withOpacity(0.4), Colors.transparent],
                stops: [0.6, 1],
              ),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 40, color: Colors.teal),
            ),
          ),
        ),
      ),
    );
  }
}
