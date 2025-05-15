import 'package:flutter/material.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/screens/news_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final List<Map<String, dynamic>> menuItems = [
    {'text': 'Portfolio', 'icon': Icons.show_chart},
    {'text': 'Market', 'icon': Icons.store},
    {'text': 'High Price', 'icon': Icons.trending_up},
    {'text': 'Account Statement', 'icon': Icons.receipt_long},
    {'text': 'Transaction Bills', 'icon': Icons.insert_drive_file},
    {'text': 'Transaction', 'icon': Icons.swap_horiz},
    {'text': 'News', 'icon': Icons.newspaper},
    {'text': 'Settings', 'icon': Icons.settings},
    {'text': 'Exit', 'icon': Icons.logout},
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Directionality(
          textDirection: TextDirection.ltr, // Make the drawer LTR
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
                    Navigator.pop(context);

                    if (item['text'] == 'Portfolio') {
                      Navigator.pushNamed(context, PageRouteNames.myStock);
                    } else if (item['text'] == 'News') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewsScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // Keep the body RTL if you want
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('لقد ضغطت على الزر هذا العدد من المرات:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'زيادة',
        child: const Icon(Icons.add),
      ),
    );
  }
}
