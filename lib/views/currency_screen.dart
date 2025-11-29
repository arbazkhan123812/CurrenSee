// views/currency_converter.dart
import 'package:flutter/material.dart';
import 'package:my_project/models/currency_model.dart';
import 'package:my_project/services/currency_service.dart';
import 'package:intl/intl.dart';
import 'package:my_project/views/currency_conversion.dart';
import 'package:my_project/views/currency_list.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final CurrencyService _currencyService = CurrencyService();
  final TextEditingController _amountController = TextEditingController();
  
  Currency? _baseCurrency;
  Currency? _targetCurrency;
  double _exchangeRate = 0.0;
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  List<Currency> _currencies = [];

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final currencies = await _currencyService.getSupportedCurrencies();
      setState(() {
        _currencies = currencies;
        // Set default currencies
        _baseCurrency = currencies.firstWhere((c) => c.code == 'USD');
        _targetCurrency = currencies.firstWhere((c) => c.code == 'EUR');
      });
      await _fetchExchangeRate();
    } catch (e) {
      _showError('Failed to load currencies: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchExchangeRate() async {
    if (_baseCurrency == null || _targetCurrency == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final rate = await _currencyService.getExchangeRate(
        _baseCurrency!.code,
        _targetCurrency!.code,
      );
      
      setState(() {
        _exchangeRate = rate;
      });
      _convertAmount();
    } catch (e) {
      _showError('Failed to fetch exchange rate: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _convertAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _convertedAmount = amount * _exchangeRate;
    });
  }

  void _saveConversion() async {
    if (_baseCurrency == null || _targetCurrency == null) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return;

    try {
      final history = ConversionHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        baseCurrency: _baseCurrency!.code,
        targetCurrency: _targetCurrency!.code,
        amount: amount,
        convertedAmount: _convertedAmount,
        exchangeRate: _exchangeRate,
        timestamp: DateTime.now(),
      );

      await _currencyService.saveConversionHistory(history);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conversion saved to history')),
      );
    } catch (e) {
      _showError('Failed to save conversion: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _showCurrencyPicker(bool isBaseCurrency) async {
    final selectedCurrency = await showDialog<Currency>(
      context: context,
      builder: (context) => CurrencyListDialog(
        currencies: _currencies,
        selectedCurrency: isBaseCurrency ? _baseCurrency : _targetCurrency,
      ),
    );

    if (selectedCurrency != null) {
      setState(() {
        if (isBaseCurrency) {
          _baseCurrency = selectedCurrency;
        } else {
          _targetCurrency = selectedCurrency;
        }
      });
      await _fetchExchangeRate();
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _baseCurrency;
      _baseCurrency = _targetCurrency;
      _targetCurrency = temp;
    });
    _fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversionHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.currency_exchange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyListScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading && _currencies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Amount Input
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
                    ),
                    onChanged: (value) => _convertAmount(),
                  ),
                  SizedBox(height: 20),

                  // Currency Selection
                  Row(
                    children: [
                      Expanded(
                        child: _buildCurrencyCard(_baseCurrency, true),
                      ),
                      IconButton(
                        icon: Icon(Icons.swap_horiz),
                        onPressed: _swapCurrencies,
                      ),
                      Expanded(
                        child: _buildCurrencyCard(_targetCurrency, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Exchange Rate
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Exchange Rate',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1 ${_baseCurrency?.code} = ${_exchangeRate.toStringAsFixed(4)} ${_targetCurrency?.code}',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Converted Amount
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Converted Amount',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_convertedAmount.toStringAsFixed(2)} ${_targetCurrency?.code}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.refresh),
                          label: Text('Refresh Rate'),
                          onPressed: _fetchExchangeRate,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                          onPressed: _saveConversion,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCurrencyCard(Currency? currency, bool isBase) {
    return Card(
      child: ListTile(
        title: Text(currency?.code ?? 'Select Currency'),
        subtitle: Text(currency?.name ?? ''),
        trailing: Text(currency?.symbol ?? ''),
        onTap: () => _showCurrencyPicker(isBase),
      ),
    );
  }
}

// Currency List Dialog
class CurrencyListDialog extends StatefulWidget {
  final List<Currency> currencies;
  final Currency? selectedCurrency;

  const CurrencyListDialog({
    required this.currencies,
    this.selectedCurrency,
  });

  @override
  _CurrencyListDialogState createState() => _CurrencyListDialogState();
}

class _CurrencyListDialogState extends State<CurrencyListDialog> {
  late List<Currency> _filteredCurrencies;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = widget.currencies;
    _searchController.addListener(_filterCurrencies);
  }

  void _filterCurrencies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCurrencies = widget.currencies
          .where((currency) =>
              currency.code.toLowerCase().contains(query) ||
              currency.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Currencies',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = _filteredCurrencies[index];
                return ListTile(
                  title: Text(currency.code),
                  subtitle: Text(currency.name),
                  trailing: Text(currency.symbol),
                  selected: widget.selectedCurrency?.code == currency.code,
                  onTap: () {
                    Navigator.of(context).pop(currency);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}