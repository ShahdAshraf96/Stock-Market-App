import 'package:flutter/material.dart';
import 'package:stock_market_app/core/routes/page_route_names.dart';

class AppDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'text': 'Market', 'icon': Icons.store},
    {'text': 'New Order', 'icon': Icons.receipt_long},
    {'text': 'Account Statement', 'icon': Icons.account_balance_wallet_outlined},
    {'text': 'Invoices', 'icon': Icons.insert_drive_file},
    {'text': 'News', 'icon': Icons.newspaper},
    {'text': 'Currency', 'icon': Icons.currency_exchange},
    {'text': 'Exit', 'icon': Icons.exit_to_app_outlined},
    {'text': 'Back', 'icon': Icons.arrow_back},
  ];

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                      case 'Market':
                        Navigator.pushNamed(context, PageRouteNames.market);
                        break;
                      case 'Account Statement':
                        Navigator.pushNamed(context, PageRouteNames.accountStatement);
                        break;
                      case 'Invoices':
                        Navigator.pushNamed(context, PageRouteNames.dualBillView);
                        break;
                      case 'News':
                        Navigator.pushNamed(context, PageRouteNames.news);
                        break;
                      case 'Currency':
                        Navigator.pushNamed(context, PageRouteNames.currency);
                        break;
                      case 'New Order':
                        Navigator.pushNamed(context, PageRouteNames.buyStock);
                        break;
                      case "Exit":
                        Navigator.pushNamed(context, PageRouteNames.login);
                        break;
                      case 'Back':
                        Navigator.pushNamed(context, PageRouteNames.homePage);
                        break;
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
