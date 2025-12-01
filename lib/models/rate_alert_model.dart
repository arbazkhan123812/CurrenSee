// lib/models/rate_alert_model.dart

class RateAlert {
  final String id;
  final String userId;
  final String baseCurrency;
  final String targetCurrency;
  final double thresholdRate;
  final bool isActive;
  final DateTime createdAt;

  RateAlert({
    required this.id,
    required this.userId,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.thresholdRate,
    required this.isActive,
    required this.createdAt,
  });

  // Factory constructor to create a RateAlert object from a Firestore map
  factory RateAlert.fromJson(Map<String, dynamic> json) {
    return RateAlert(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      baseCurrency: json['baseCurrency'] ?? '',
      targetCurrency: json['targetCurrency'] ?? '',
      thresholdRate: (json['thresholdRate'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? true,
      // Date ko sahi se parse karein
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Method to convert RateAlert object to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'baseCurrency': baseCurrency,
      'targetCurrency': targetCurrency,
      'thresholdRate': thresholdRate,
      'isActive': isActive,
      // Date ko ISO string mein convert karein
      'createdAt': createdAt.toIso8601String(),
    };
  }
}