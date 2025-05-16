import 'package:flutter/material.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/screens/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home Page"),
      ),
      drawer: AppDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PageRouteNames.buyStock);
            },
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
              child: const Center(child: Icon(Icons.add, size: 40, color: Colors.teal)),
            ),
          ),
        ),
      ),
    );
  }
}
