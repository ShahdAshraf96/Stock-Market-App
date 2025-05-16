import 'package:stock_market_app/core/routes/page_route_names.dart';
import 'package:stock_market_app/screens/account_statement/account_statement_screen.dart';
import 'package:stock_market_app/screens/bill/bill_view_screen.dart';
import 'package:stock_market_app/screens/bill/dual_bill_screen.dart';
import 'package:stock_market_app/screens/currency/currency_screen.dart';
import 'package:stock_market_app/screens/forget_password/forget_password_screen.dart';
import 'package:stock_market_app/screens/home_page/home_page_screen.dart';
import 'package:stock_market_app/screens/login/login_screen.dart';
import 'package:stock_market_app/screens/change_password/change_password_screen.dart';
import 'package:stock_market_app/screens/news_screen.dart';
import 'package:stock_market_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:stock_market_app/screens/stock_detail/stock_detail_screen.dart';
import 'package:stock_market_app/models/stock_model.dart';
import 'package:stock_market_app/screens/market/market_screen.dart';
import '../../screens/admin_panel/admin_dashboard_screen.dart';
import '../../screens/buy_sell_stock/order_tab_screen.dart';

abstract class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case PageRouteNames.initial:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
          settings: settings
        );
      case PageRouteNames.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings
        );
      case PageRouteNames.forgetPassword:
        return MaterialPageRoute(
          builder: (context) => ForgetPasswordScreen(),
          settings: settings
        );
      case PageRouteNames.news:
        return MaterialPageRoute(
          builder: (context) => NewsScreen(),
          settings: settings
        );
      case PageRouteNames.currency:
        return MaterialPageRoute(
          builder: (context) => CurrencyConverterScreen(),
          settings: settings
        );
      case PageRouteNames.changePassword:
        return MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(),
          settings: settings
        );
      case PageRouteNames.buyStock:
        return MaterialPageRoute(
          builder: (context) => const OrderTabScreen(),
          settings: settings,
        );
      case PageRouteNames.market:
        return MaterialPageRoute(
          builder: (context) => StockHomePage(),
          settings: settings,
        );
      case PageRouteNames.accountStatement:
        return MaterialPageRoute(
          builder: (context) => AccountStatementScreen(),
          settings: settings
        );
      case PageRouteNames.dualBillView:
        return MaterialPageRoute(
          builder: (context) => DualBillScreen(),
          settings: settings
        );
      case PageRouteNames.billView:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          final Stock stock = args['stock'];
          final bool isBuy = args['isBuy'];
          final String customerName = args['customerName'];
          final String customerId = args['customerId'];
          return MaterialPageRoute(
            builder: (context) => BillViewScreen(
              stock: stock,
              isBuy: isBuy,
              customerName: customerName,
              customerId: customerId
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Error: bill details not provided.'),
            ),
          ),
          settings: settings,
        );
      case PageRouteNames.homePage:
        return MaterialPageRoute(
          builder: (context) => MyHomePage(),
          settings: settings,
        );
      case PageRouteNames.stockDetail:
        if (settings.arguments is Map<String, dynamic>) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          final Stock stock = args['stock'];
          return MaterialPageRoute(
            builder: (context) => StockDetailScreen(
              stock: stock
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Error: Stock details not provided.'),
            ),
          ),
          settings: settings,
        );
      case PageRouteNames.adminDashboard:
        return MaterialPageRoute(
            builder: (context) => AdminDashboardScreen(),
            settings: settings
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Error: Route not found.'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
