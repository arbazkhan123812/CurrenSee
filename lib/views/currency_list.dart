// views/currency_list_screen.dart
import 'package:flutter/material.dart';
import 'package:my_project/models/currency_model.dart';
import 'package:my_project/services/currency_service.dart';

class CurrencyListScreen extends StatefulWidget {
  @override
  _CurrencyListScreenState createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  final CurrencyService _currencyService = CurrencyService();
  List<Currency> _currencies = [];
  List<Currency> _filteredCurrencies = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
    _searchController.addListener(_filterCurrencies);
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currencies = await _currencyService.getSupportedCurrencies();
      setState(() {
        _currencies = currencies;
        _filteredCurrencies = currencies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load currencies: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = _currencies
          .where((currency) =>
              currency.code.toLowerCase().contains(query) ||
              currency.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supported Currencies'),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search currencies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredCurrencies.isEmpty
                    ? Center(child: Text('No currencies found'))
                    : ListView.builder(
                        itemCount: _filteredCurrencies.length,
                        itemBuilder: (context, index) {
                          final currency = _filteredCurrencies[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(currency.symbol),
                              ),
                              title: Text(currency.code),
                              subtitle: Text(currency.name),
                              trailing: Icon(Icons.currency_exchange),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}