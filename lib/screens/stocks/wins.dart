import 'package:flutter/material.dart';

void main() => runApp(const StockApp());

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

  final List<Map<String, String>> stocks = const [
    {
      "change": "10.00%",
      "symbol": "HBCO",
      "price": "4.070",
      "diff": "0.370",
      "vol": "455,582"
    },
    {
      "change": "19.97%",
      "symbol": "EGTS",
      "price": "7.570",
      "diff": "1.260",
      "vol": "44,516,555"
    },
    {
      "change": "9.84%",
      "symbol": "HBCO",
      "price": "4.130",
      "diff": "0.370",
      "vol": "397,516"
    },
    {
      "change": "9.89%",
      "symbol": "UTOP",
      "price": "37.560",
      "diff": "3.380",
      "vol": "68,586"
    },
    {
      "change": "7.44%",
      "symbol": "ELKA",
      "price": "2.310",
      "diff": "0.160",
      "vol": "44,997,036"
    },
    {
      "change": "7.63%",
      "symbol": "MBSC",
      "price": "84.470",
      "diff": "5.990",
      "vol": "10,162,255"
    },
    {
      "change": "6.78%",
      "symbol": "AIVC",
      "price": "0.126",
      "diff": "0.008",
      "vol": "41,826"
    },
    {
      "change": "6.80%",
      "symbol": "PRCL",
      "price": "10.370",
      "diff": "0.660",
      "vol": "32,737,297"
    },
    {
      "change": "6.17%",
      "symbol": "AFMC",
      "price": "26.500",
      "diff": "1.540",
      "vol": "11,359,691"
    },
    {
      "change": "6.71%",
      "symbol": "SCFM",
      "price": "89.810",
      "diff": "5.650",
      "vol": "6,067,826"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("أعلي اسهم"),
          centerTitle: true,
          backgroundColor: const Color(0xFF2D2F41),
          actions: [
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFF2D2F41),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab("رابحون", isSelected: true),
                  _buildTab("خاسرون"),
                  _buildTab("الاكثر نشاطاً"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: stocks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Add this line
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          stock["change"]!,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          stock["symbol"]!,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          stock["price"]!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stock["diff"]!,
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          stock["vol"]!,
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

  Widget _buildTab(String title, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        if (isSelected)
          Container(
            height: 2,
            width: 40,
            color: Colors.cyanAccent,
          ),
      ],
    );
  }
}
