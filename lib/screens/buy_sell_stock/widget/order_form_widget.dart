import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/services/order_service.dart';
import '../../../models/eodhd_stock_model.dart';
import '../../../core/services/eodhd_api_service.dart';
import '../../../models/order_model.dart';
import '../controllers/order_controller.dart';
import 'package:flutter/cupertino.dart';
import '../stock_selector_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_app/core/controllers/order_controller.dart' as logic_controller;
class OrderFormWidget extends StatefulWidget {
  final bool isBuy;
  final Key key;

  const OrderFormWidget({required this.isBuy, required this.key}) : super(key: key);


  @override
  State<OrderFormWidget> createState() => OrderFormWidgetState();
}

class OrderFormWidgetState extends State<OrderFormWidget> {
  String priceType = "Limit";
  String validity = "Today";
  DateTime? selectedDate;
  String custodian = "Kuwait Finance House - Egypt";
  String settlement = "T+0";

  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  bool isPrivate = false;
  bool isConditional = false;

  List<String> custodians = [
    "Kuwait Finance House - Egypt",
    "Banque Misr",
    "Commercial International Bank (CIB)",
  ];
  void resetForm() {
    priceType = "Limit";
    validity = "Today";
    selectedDate = null;
    custodian = "Kuwait Finance House - Egypt";
    settlement = "T+0";
    quantityController.clear();
    priceController.clear();
    isPrivate = false;
    isConditional = false;
    OrderController.selectedStock = null;
    OrderController.quoteData = null;
    setState(() {});
  }
  void selectStock() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StockSelectorScreen()),
    );

    if (result != null && result is EodhdStock) {
      final quote = await EodhdApiService.fetchEodData(result.code);
      OrderController.setSelectedStock(result, quote);

      if (priceType == "Market") {
        priceController.text = widget.isBuy
            ? OrderController.bestAsk
            : OrderController.bestBid;
      }

      setState(() {});
    }
  }


  void handlePriceTypeChange(String type) {
    setState(() {
      priceType = type;
      if (type == "Market" && OrderController.selectedStock != null) {
        final fallbackPrice = OrderController.lastPrice;
        final defaultPrice = widget.isBuy
            ? OrderController.bestAsk
            : OrderController.bestBid;

        priceController.text = (defaultPrice != "0.00") ? defaultPrice : fallbackPrice;
      } else {
        priceController.clear();
      }
    });
  }


  void selectValidity(String v) async {
    if (v == "Pick a Date") {
      int? pickedDay;
      int? pickedMonth;

      await showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Select Day & Month", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        hint: const Text("Day"),
                        value: pickedDay,
                        items: List.generate(31, (i) => i + 1)
                            .map((d) => DropdownMenuItem(value: d, child: Text("$d")))
                            .toList(),
                        onChanged: (val) => setState(() => pickedDay = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<int>(
                        hint: const Text("Month"),
                        value: pickedMonth,
                        items: List.generate(12, (i) => i + 1)
                            .map((m) => DropdownMenuItem(value: m, child: Text("$m")))
                            .toList(),
                        onChanged: (val) => setState(() => pickedMonth = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (pickedDay != null && pickedMonth != null) {
                      final now = DateTime.now();
                      selectedDate = DateTime(now.year, pickedMonth!, pickedDay!);
                      validity = "Valid until ${DateFormat('dd MMM yyyy').format(selectedDate!)}";
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  child: const Text("Confirm"),
                )
              ],
            ),
          );
        },
      );
    } else {
      setState(() {
        validity = v;
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stock = OrderController.selectedStock;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          /// ── Header Info + Search Icon ──────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        OrderController.selectedStock?.name ?? "Stock Name",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, size: 28),
                    onPressed: selectStock,
                  ),
                ],
              ),


              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change: ${OrderController.change}", style: const TextStyle(fontSize: 13)),
                  Text("Last Price: ${OrderController.lastPrice}", style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Best Ask: 0 x ${OrderController.bestAsk}", style: const TextStyle(fontSize: 13)),
                  Text("Best Bid: 0 x ${OrderController.bestBid}", style: const TextStyle(fontSize: 13)),
                ],
              ),
              const Divider(height: 24),
            ],
          ),


          if (stock != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "${stock.name} (${stock.code})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 24),
          ],

          /// ── Price Type Tabs ────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text("Limit"),
                    ),
                  ),
                  selected: priceType == "Limit",
                  onSelected: (_) => handlePriceTypeChange("Limit"),
                  labelStyle: const TextStyle(fontSize: 14),
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  backgroundColor: Colors.grey.shade200,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // to make them flush
                  ),
                ),
              ),
              Expanded(
                child: ChoiceChip(
                  label: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text("Market"),
                    ),
                  ),
                  selected: priceType == "Market",
                  onSelected: (_) => handlePriceTypeChange("Market"),
                  labelStyle: const TextStyle(fontSize: 14),
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  backgroundColor: Colors.grey.shade200,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // same here
                  ),
                ),
              ),
            ],
          ),



          const SizedBox(height: 8),

          /// ── T+ Chips (SELL only) ───────────────────────────────────
          if (!widget.isBuy)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ["T+0", "T+1", "T+2"].map((s) {
                return ChoiceChip(
                  label: Text(s),
                  selected: settlement == s,
                  onSelected: (_) => setState(() => settlement = s),
                );
              }).toList(),
            ),

          const SizedBox(height: 12),

          /// ── Quantity + Price ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Quantity"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  enabled: priceType == "Limit",
                  decoration: const InputDecoration(labelText: "Price"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ── Validity ───────────────────────────────────────────────
          DropdownButtonFormField<String>(
            value: validity == "Today" ? "Today" : (selectedDate != null ? "Pick a Date" : validity),
            items: ["Today", "Pick a Date", "Cancel"].map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            onChanged: (val) => selectValidity(val!),
            decoration: const InputDecoration(labelText: "Order Validity"),
          ),

          const SizedBox(height: 12),

          /// ── Custodian ──────────────────────────────────────────────
          DropdownButtonFormField<String>(
            value: custodian,
            items: custodians
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => custodian = val!),
            decoration: const InputDecoration(labelText: "Custodian"),
          ),

          const SizedBox(height: 12),

          /// ── Toggles ────────────────────────────────────────────────
          SwitchListTile(
            value: isPrivate,
            onChanged: (val) => setState(() => isPrivate = val),
            title: const Text("Private Order"),
          ),
          SwitchListTile(
            value: isConditional,
            onChanged: (val) => setState(() => isConditional = val),
            title: const Text("Conditional Order"),
          ),

          const SizedBox(height: 20),

          /// ── Submit Button ──────────────────────────────────────────
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isBuy ? Colors.green : Colors.red,
            ),
            onPressed: () async {
              final stock = OrderController.selectedStock;

              if (stock == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a stock")),
                );
                return;
              }

              final quantity = int.tryParse(quantityController.text.trim());
              final price = double.tryParse(priceController.text.trim());

              if (quantity == null || quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid positive quantity")),
                );
                return;
              }

              if (price == null || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid positive price")),
                );
                return;
              }


              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User not logged in")),
                );
                return;
              }
              print("Submitting from tab: ${widget.isBuy ? 'Buy' : 'Sell'}");

              final order = OrderModel(
                userId: currentUser.uid,
                stockName: stock.name,
                price: price,
                quantity: quantity,
                orderType: priceType,
                settlement: widget.isBuy ? "" : settlement,
                validity: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : validity,
                custodian: custodian,
                executionRule: "REGULAR",
                isPrivate: isPrivate,
                isConditional: isConditional,
                isBuy: widget.isBuy,
                timestamp: DateTime.now(),
              );

              try {
                final controller = logic_controller.OrderController();
                final customerName = currentUser.displayName ?? 'Unknown User';

                await controller.placeNewOrder(order: order);


                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${widget.isBuy ? 'Buy' : 'Sell'} order submitted")),
                );



                quantityController.clear();
                priceController.clear();
                setState(() {});
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to submit order")),
                );
              }
            }
            ,
            child: Text(widget.isBuy ? "Buy" : "Sell"),
          )
        ],
      ),
    );
  }
}
