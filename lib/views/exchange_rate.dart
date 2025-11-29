// views/exchange_rate_chart.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_project/services/currency_service.dart';
import 'package:intl/intl.dart';

class ExchangeRateChart extends StatefulWidget {
  final String baseCurrency;
  final String targetCurrency;

  const ExchangeRateChart({
    required this.baseCurrency,
    required this.targetCurrency,
  });

  @override
  _ExchangeRateChartState createState() => _ExchangeRateChartState();
}

class _ExchangeRateChartState extends State<ExchangeRateChart> {
  final CurrencyService _currencyService = CurrencyService();
  Map<DateTime, double> _historicalRates = {};
  bool _isLoading = false;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  Future<void> _loadHistoricalData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rates = await _currencyService.getHistoricalRates(
        widget.baseCurrency,
        widget.targetCurrency,
        _selectedDays,
      );
      setState(() {
        _historicalRates = rates;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load historical data: $e')),
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
        title: Text('${widget.baseCurrency}/${widget.targetCurrency} Rate History'),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Time Period Selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [7, 30, 90].map((days) {
                return ChoiceChip(
                  label: Text('$days days'),
                  selected: _selectedDays == days,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDays = days;
                    });
                    _loadHistoricalData();
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _historicalRates.isEmpty
                    ? Center(child: Text('No historical data available'))
                    : SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat.MMMd(),
                        ),
                        primaryYAxis: NumericAxis(
                          numberFormat: NumberFormat.compactCurrency(symbol: ''),
                        ),
                        series: <LineSeries<MapEntry<DateTime, double>, DateTime>>[
                          LineSeries<MapEntry<DateTime, double>, DateTime>(
                            dataSource: _historicalRates.entries.toList(),
                            xValueMapper: (entry, _) => entry.key,
                            yValueMapper: (entry, _) => entry.value,
                            name: 'Exchange Rate',
                            color: Colors.blue,
                            markerSettings: MarkerSettings(isVisible: true),
                          ),
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
          ),
        ],
      ),
    );
  }
}