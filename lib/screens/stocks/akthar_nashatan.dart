import 'package:flutter/material.dart';

void main() {
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أعلي اسهم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StockHomePage(),
    );
  }
}

class StockHomePage extends StatelessWidget {
  const StockHomePage({super.key});

  final List<Map<String, dynamic>> stocks = const [
    {
      "change": "+0.50%",
      "price": "28.200",
      "symbol": "HRHO",
      "vol": "178,319,123",
      "diff": "+0.140"
    },
    {
      "change": "+1.84%",
      "price": "3.870",
      "symbol": "ZMID",
      "vol": "201,563,810",
      "diff": "+0.070"
    },
    {
      "change": "-3.08%",
      "price": "8.800",
      "symbol": "ISPH",
      "vol": "114,045,715",
      "diff": "-0.280"
    },
    {
      "change": "+0.91%",
      "price": "77.700",
      "symbol": "COMI",
      "vol": "161,106,833",
      "diff": "+0.700"
    },
    {
      "change": "-0.31%",
      "price": "6.520",
      "symbol": "PHDC",
      "vol": "82,454,981",
      "diff": "-0.020"
    },
    {
      "change": "+4.48%",
      "price": "2.800",
      "symbol": "RAYA",
      "vol": "96,546,099",
      "diff": "+0.120"
    },
    {
      "change": "-3.02%",
      "price": "1.930",
      "symbol": "EEII",
      "vol": "65,520,056",
      "diff": "-0.060"
    },
    {
      "change": "0.00%",
      "price": "0.629",
      "symbol": "",
      "vol": "81,692,674",
      "diff": "0.000"
    },
    {
      "change": "-0.04%",
      "price": "22.400",
      "symbol": "SKPC",
      "vol": "58,363,506",
      "diff": "-0.010"
    },
    {
      "change": "-0.98%",
      "price": "2.030",
      "symbol": "BTFH",
      "vol": "62,973,932",
      "diff": "-0.020"
    },
  ];

  Color getBorderColor(String change) {
    if (change.contains('+')) return Colors.green;
    if (change.contains('-')) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أعلي اسهم", textDirection: TextDirection.rtl),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[800],
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("الاكتر نشاطاً",
                      style: TextStyle(fontSize: 16),
                      textDirection: TextDirection.rtl),
                  Text("خاسرون",
                      style: TextStyle(fontSize: 16),
                      textDirection: TextDirection.rtl),
                  Text("رابحون",
                      style: TextStyle(fontSize: 16),
                      textDirection: TextDirection.rtl),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      1.2, // Adjusted from 1.5 to allow more height
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: getBorderColor(stock["change"]), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          stock["change"],
                          style: TextStyle(
                            color: getBorderColor(stock["change"]),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          stock["price"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          stock["symbol"],
                          style: const TextStyle(
                              color: Colors.cyanAccent, fontSize: 13),
                        ),
                        Text(stock["diff"],
                            style: const TextStyle(fontSize: 13)),
                        Text(
                          stock["vol"],
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
