// models/currency_model.dart
class Currency {
  final String code;
  final String name;
  final String symbol;
  final String? flag;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    this.flag,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'flag': flag,
    };
  }
}

class ExchangeRate {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final DateTime timestamp;

  ExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.timestamp,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      baseCurrency: json['baseCurrency'] ?? '',
      targetCurrency: json['targetCurrency'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ConversionHistory {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double amount;
  final double convertedAmount;
  final double exchangeRate;
  final DateTime timestamp;

  ConversionHistory({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.timestamp,
  });

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      id: json['id'] ?? '',
      baseCurrency: json['baseCurrency'] ?? '',
      targetCurrency: json['targetCurrency'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      convertedAmount: (json['convertedAmount'] ?? 0).toDouble(),
      exchangeRate: (json['exchangeRate'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'exchangeRate': exchangeRate,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}