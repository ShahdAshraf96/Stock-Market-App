import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Map<String, dynamic>> menuItems = [
    {'text': 'Portfolio', 'icon': Icons.show_chart},
    {'text': 'Market', 'icon': Icons.store},
    {'text': 'High Price', 'icon': Icons.trending_up},
    {'text': 'Account Statement', 'icon': Icons.receipt_long},
    {'text': 'Transaction Bills', 'icon': Icons.insert_drive_file},
    {'text': 'Transaction', 'icon': Icons.swap_horiz},
    {'text': 'News', 'icon': Icons.newspaper},
    {'text': 'Settings', 'icon': Icons.settings},
    {'text': 'Currency', 'icon': Icons.currency_exchange},
    {'text': 'Exit', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF9966CC)),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ...menuItems.map(
                (item) => ListTile(
                  leading: Icon(item['icon'], color: Colors.grey),
                  title: Text(item['text']),
                  onTap: () {
                    switch(item["text"]) {
                      case 'Portfolio':
                        Navigator.pushNamed(context, PageRouteNames.myStock);
                        break;
                      case 'Market':
                        // Navigator.pushNamed(context, PageRouteNames.stockDetail);
                        break;
                      case 'High Price':
                        // Navigator.pushNamed(context, PageRouteNames.stockDetail);
                        break;
                      case 'Account Statement':
                        Navigator.pushNamed(context, PageRouteNames.accountStatement);
                        break;
                      case 'Transaction Bills':
                        Navigator.pushNamed(context, PageRouteNames.dualBillView);
                        break;
                      case 'Transaction':
                        // Navigator.pushNamed(context, PageRouteNames.billView);
                        break;
                      case 'News':
                        Navigator.pushNamed(context, PageRouteNames.news);
                        break;
                      case 'Settings':
                        // Handle settings navigation
                        break;
                      case 'Currency':
                        Navigator.pushNamed(context, PageRouteNames.currency);
                        break;
                      case 'Exit':
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        }
                        else if (Platform.isIOS) {
                          exit(0);
                        }
                        break;
                      default:
                        // Handle default case
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Icon(Icons.show_chart, size: 80, color: Theme.of(context).primaryColor),
        const SizedBox(height: 24),
        Text(
          'Welcome to Stock Market App',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Track your portfolio, view market trends, and stay updated with the latest news.',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
          ],
        ),
      )
    );
  }
}
