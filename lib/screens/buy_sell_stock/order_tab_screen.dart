import 'package:flutter/material.dart';
import 'package:stock_market_app/screens/drawer.dart';
import 'widget/order_form_widget.dart';

class OrderTabScreen extends StatefulWidget {
  const OrderTabScreen({super.key});

  @override
  State<OrderTabScreen> createState() => _OrderTabScreenState();
}

class _OrderTabScreenState extends State<OrderTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<OrderFormWidgetState> _buyKey = GlobalKey<OrderFormWidgetState>();
  final GlobalKey<OrderFormWidgetState> _sellKey = GlobalKey<OrderFormWidgetState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _sellKey.currentState?.resetForm();
        } else {
          _buyKey.currentState?.resetForm();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Buy'),
            Tab(text: 'Sell'),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderFormWidget(key: _buyKey, isBuy: true),
          OrderFormWidget(key: _sellKey, isBuy: false),
        ],
      ),
    );
  }
}
