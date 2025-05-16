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

  final List<Map<String, String>> stocks = const [
    {
      "change": "7.14%-",
      "symbol": "VERTIKA",
      "price": "1.430",
      "diff": "0.110-",
      "vol": "1,933,728"
    },
    {
      "change": "10.78%-",
      "symbol": "EGREF",
      "price": "9.680",
      "diff": "1.170-",
      "vol": "5,205"
    },
    {
      "change": "5.18%-",
      "symbol": "EALR",
      "price": "77.380",
      "diff": "4.230-",
      "vol": "909,300"
    },
    {
      "change": "5.47%-",
      "symbol": "KWIN",
      "price": "28.530",
      "diff": "1.650-",
      "vol": "26,720"
    },
    {
      "change": "4.67%-",
      "symbol": "OBRI",
      "price": "13.060",
      "diff": "0.640-",
      "vol": "37,379,669"
    },
    {
      "change": "4.91%-",
      "symbol": "CPCI",
      "price": "158.000",
      "diff": "8.160-",
      "vol": "926,961"
    },
    {
      "change": "3.60%-",
      "symbol": "elex",
      "price": "23.000",
      "diff": "0.860-",
      "vol": "1,523,762"
    },
    {
      "change": "3.98%-",
      "symbol": "AMES",
      "price": "21.720",
      "diff": "0.900-",
      "vol": "2,394,391"
    },
    {
      "change": "3.07%-",
      "symbol": "OIH",
      "price": "0.662",
      "diff": "0.021-",
      "vol": "52,025,629"
    },
    {
      "change": "3.08%-",
      "symbol": "ISPH",
      "price": "8.800",
      "diff": "0.280-",
      "vol": "114,045,715"
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
          actions: [
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          ],
          backgroundColor: const Color(0xFF2D2F41),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFF2D2F41),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab("رابحون", isSelected: false),
                  _buildTab("خاسرون", isSelected: true),
                  _buildTab("الاكثر نشاطاً", isSelected: false),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: stocks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          stock["change"]!,
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Text(
                          stock["symbol"]!,
                          style: const TextStyle(
                              color: Colors.cyanAccent, fontSize: 14),
                        ),
                        Text(
                          stock["price"]!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
            )
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
