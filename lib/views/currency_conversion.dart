// views/conversion_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/models/currency_model.dart';
import 'package:my_project/services/currency_service.dart';

class ConversionHistoryScreen extends StatefulWidget {
  @override
  _ConversionHistoryScreenState createState() => _ConversionHistoryScreenState();
}

class _ConversionHistoryScreenState extends State<ConversionHistoryScreen> {
  final CurrencyService _currencyService = CurrencyService();
  List<ConversionHistory> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await _currencyService.getConversionHistory();
      setState(() {
        _history = history;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load history: $e')),
      );
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
        title: Text('Conversion History'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No conversion history'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(item.baseCurrency),
                        ),
                        title: Text(
                          '${item.amount.toStringAsFixed(2)} ${item.baseCurrency} → ${item.convertedAmount.toStringAsFixed(2)} ${item.targetCurrency}',
                        ),
                        subtitle: Text(
                          'Rate: ${item.exchangeRate.toStringAsFixed(4)} • ${DateFormat('MMM dd, yyyy HH:mm').format(item.timestamp)}',
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    );
                  },
                ),
    );
  }
}