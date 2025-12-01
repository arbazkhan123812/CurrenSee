// lib/services/rate_alert_service.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rate_alert_model.dart';
import 'currency_service.dart'; // To fetch real-time rates
import '../utils/helper.dart'; // For showNotificationn

class RateAlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CurrencyService _currencyService = CurrencyService();

  // 1. Save New Rate Alert
  Future<void> saveRateAlert(RateAlert alert) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in. Cannot save alert.');
    }

    try {
      // Store the alert in a separate collection within the user's document
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rateAlerts')
          .doc(alert.id)
          .set(alert.toJson());
    } catch (e) {
      throw Exception('Error saving rate alert: $e');
    }
  }

  // 2. Get User's Active Rate Alerts
  Future<List<RateAlert>> getActiveRateAlerts() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rateAlerts')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => RateAlert.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching active rate alerts: $e');
    }
  }
  
  // 3. Deactivate Alert (after it's hit)
  Future<void> deactivateAlert(String alertId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('rateAlerts')
          .doc(alertId)
          .update({'isActive': false});
    } catch (e) {
      throw Exception('Error deactivating alert: $e');
    }
  }

  // 4. Check Rates and Trigger Alerts (The core logic)
  Future<void> checkRatesAndTriggerAlerts(BuildContext context) async {
    final activeAlerts = await getActiveRateAlerts();

    if (activeAlerts.isEmpty) return;

    // Use a Map to cache current rates and minimize API calls
    final Map<String, double> rateCache = {};

    for (var alert in activeAlerts) {
      final cacheKey = '${alert.baseCurrency}:${alert.targetCurrency}';
      double currentRate;

      // Check cache first
      if (rateCache.containsKey(cacheKey)) {
        currentRate = rateCache[cacheKey]!;
      } else {
        // Fetch rate using CurrencyService (assuming it has getExchangeRate method)
        try {
          currentRate = await _currencyService.getExchangeRate(
            alert.baseCurrency,
            alert.targetCurrency,
          );
          rateCache[cacheKey] = currentRate; // Save to cache
        } catch (e) {
          // Skip this alert if rate fetching fails
          continue; 
        }
      }

      // Check if the current rate meets the user's threshold
      if (currentRate >= alert.thresholdRate) {
        // --- Trigger Notification ---
        showNotificationn(
          '1 ${alert.baseCurrency} = ${currentRate.toStringAsFixed(4)} ${alert.targetCurrency}',
          'RATE ALERT HIT!',
          context,
        );

        // --- Deactivate the Alert ---
        await deactivateAlert(alert.id);
      }
    }
  }
}