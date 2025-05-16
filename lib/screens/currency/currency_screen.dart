import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stock_market_app/screens/drawer.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _result = '';
  bool _isLoading = false;
  String _errorMessage = '';
  final List<String> _currencies = [
    'USD',
    'EUR',
    'SAR',
    'EGP',
    'AED',
    'QAR',
    'KWD',
    'BHD',
    'OMR',
    'JOD',
    'IQD',
    'LBP',
    'SYP',
    'MAD',
    'TND',
    'DZD',
    'SDG',
    'YER',
    'AUD',
    'CAD'
  ];

  Future<void> _convertCurrency() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$_fromCurrency'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates'][_toCurrency];
        final result = amount * rate;
        
        setState(() {
          _result = '${amount.toStringAsFixed(2)} $_fromCurrency = ${result.toStringAsFixed(2)} $_toCurrency';
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch exchange rates';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.currency_exchange_rounded),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCurrencyDropdown(_fromCurrency, (value) {
                  setState(() {
                    _fromCurrency = value!;
                  });
                }, 'From'),
                _buildCurrencyDropdown(_toCurrency, (value) {
                  setState(() {
                    _toCurrency = value!;
                  });
                }, 'To'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _convertCurrency,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              )
            else if (_result.isNotEmpty)
              Text(
                _result,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(String value, Function(String?) onChanged, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: _currencies.map<DropdownMenuItem<String>>(
                (String currency) => DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                ),
              ).toList(),
        ),
      ],
    );
  }
}
