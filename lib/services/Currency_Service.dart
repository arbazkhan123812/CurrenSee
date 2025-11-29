// services/currency_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/currency_model.dart';

class CurrencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const String _historicalUrl = 'https://api.exchangerate-api.com/v4/history';

  // Get real-time exchange rate
  Future<double> getExchangeRate(String baseCurrency, String targetCurrency) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$baseCurrency'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return rates[targetCurrency]?.toDouble() ?? 0.0;
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }

  // Get historical exchange rates
  Future<Map<DateTime, double>> getHistoricalRates(
      String baseCurrency, String targetCurrency, int days) async {
    final Map<DateTime, double> historicalRates = {};
    final DateTime endDate = DateTime.now();
    final DateTime startDate = endDate.subtract(Duration(days: days));

    // In a real app, you'd use a proper historical API
    // This is a simplified version
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      try {
        // Simulate historical data (replace with actual API call)
        final rate = await getExchangeRate(baseCurrency, targetCurrency);
        // Add some variation for demo purposes
        final variedRate = rate * (0.95 + (0.1 * (i / days)));
        historicalRates[date] = variedRate;
      } catch (e) {
        // If API fails, use a default variation
        historicalRates[date] = 1.0 * (0.95 + (0.1 * (i / days)));
      }
    }

    return historicalRates;
  }

  // Save conversion history
  Future<void> saveConversionHistory(ConversionHistory history) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('conversionHistory')
            .doc(history.id)
            .set(history.toJson());
      }
    } catch (e) {
      throw Exception('Error saving conversion history: $e');
    }
  }

  // Get conversion history
  Future<List<ConversionHistory>> getConversionHistory() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('conversionHistory')
            .get();

        return snapshot.docs
            .map((doc) => ConversionHistory.fromJson(doc.data()))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error fetching conversion history: $e');
    }
  }

  // Get supported currencies
  Future<List<Currency>> getSupportedCurrencies() async {
    // This would typically come from an API
    // For demo, returning a static list
    return [
      Currency(code: 'USD', name: 'US Dollar', symbol: '\$'),
      Currency(code: 'EUR', name: 'Euro', symbol: '€'),
      Currency(code: 'GBP', name: 'British Pound', symbol: '£'),
      Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
      Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$'),
      Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$'),
      Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF'),
      Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
      Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
      Currency(code: 'PKR', name: 'Pakistani Rupee', symbol: 'Rs'),
      Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
      Currency(code: 'SAR', name: 'Saudi Riyal', symbol: 'ر.س'),
    ];
  }

  // Search currencies
  Future<List<Currency>> searchCurrencies(String query) async {
    final currencies = await getSupportedCurrencies();
    return currencies
        .where((currency) =>
            currency.code.toLowerCase().contains(query.toLowerCase()) ||
            currency.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}