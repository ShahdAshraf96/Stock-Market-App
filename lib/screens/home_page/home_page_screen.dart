import 'package:flutter/material.dart';
import 'package:stock_market/core/routes/page_route_names.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final List<Map<String, dynamic>> menuItems = [
    {'text': 'أسهمي', 'icon': Icons.show_chart},
    {'text': 'السوق', 'icon': Icons.store},
    {'text': 'أعلى أسهم', 'icon': Icons.trending_up},
    {'text': 'الأوامر', 'icon': Icons.list},
    {'text': 'تنبيهات', 'icon': Icons.notifications},
    {'text': 'المحفظة', 'icon': Icons.account_balance_wallet},
    {'text': 'الحسابات', 'icon': Icons.account_balance},
    {'text': 'كشف حساب', 'icon': Icons.receipt_long},
    {'text': 'التدفق النقدي', 'icon': Icons.attach_money},
    {'text': 'استعلام أوامر', 'icon': Icons.history},
    {'text': 'الفواتير', 'icon': Icons.insert_drive_file},
    {'text': 'إكتتاب/استحواذ', 'icon': Icons.assignment},
    {'text': 'تحويلات', 'icon': Icons.swap_horiz},
    {'text': 'نماذج', 'icon': Icons.article},
    {'text': 'الأخبار', 'icon': Icons.newspaper},
    {'text': 'تقارير', 'icon': Icons.bar_chart},
    {'text': 'صندوق الوارد', 'icon': Icons.mail},
    {'text': 'الإعدادات', 'icon': Icons.settings},
    {'text': 'عن البرنامج', 'icon': Icons.info},
    {'text': 'تسجيل خروج', 'icon': Icons.logout},
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Center(
                  child: Text(
                    'القائمة',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ...menuItems.map((item) => ListTile(
                leading: Icon(item['icon'], color: Colors.teal),
                title: Text(item['text']),
                onTap: () {
                  Navigator.pop(context);
                  if (item['text'] == 'أسهمي') {
                    Navigator.pushNamed(context, PageRouteNames.myStock);
                  }
                },
              )),
            ],
          ),
        ),
        body: Center(
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
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'زيادة',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
