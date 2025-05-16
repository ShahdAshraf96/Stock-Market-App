import 'package:flutter/material.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> menuItems = [
    {'text': 'Market', 'icon': Icons.store},
    {'text': 'High Price', 'icon': Icons.trending_up},
    {'text': 'New Order', 'icon': Icons.receipt_long},
    {'text': 'Account Statement', 'icon': Icons.account_balance_wallet_outlined},
    {'text': 'Invoices', 'icon': Icons.insert_drive_file},
    {'text': 'News', 'icon': Icons.newspaper},
    {'text': 'Settings', 'icon': Icons.settings},
    {'text': 'Exit', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              ...menuItems.map((item) => ListTile(
                leading: Icon(item['icon'], color: Colors.grey),
                title: Text(item['text']),
                onTap: () {
                  Navigator.pop(context);
                  switch (item['text']) {
                    case 'Account Statement':
                      Navigator.pushNamed(context, PageRouteNames.accountStatement);
                      break;
                    case 'Invoices':
                      Navigator.pushNamed(context, PageRouteNames.dualBillView);
                      break;
                    case 'Market':
                      break;
                    case 'News':
                      Navigator.pushNamed(context, PageRouteNames.accountStatement);
                      break;
                    case 'New Order':
                      Navigator.pushNamed(context, PageRouteNames.buyStock);
                      break;
                    case 'Exit':
                      Navigator.pushNamed(context, PageRouteNames.login);
                      break;
                  }
                },
              )),
            ],
          ),
        ),
      ),
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
              child: const Center(
                child: Icon(Icons.add, size: 40, color: Colors.teal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
