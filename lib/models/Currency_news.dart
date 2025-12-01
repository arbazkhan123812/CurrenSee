import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyNews {
  final String id;
  final String title;
  final String description;
  final String source;
  final DateTime date;
  final String? imageUrl;
  final String? category;
  final String? currencyPair;
  final String? url; // Added for direct article link

  CurrencyNews({
    required this.id,
    required this.title,
    required this.description,
    required this.source,
    required this.date,
    this.imageUrl,
    this.category,
    this.currencyPair,
    this.url,
  });

  factory CurrencyNews.fromMap(Map<String, dynamic> data) {
    return CurrencyNews(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      source: data['source'] ?? '',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      imageUrl: data['imageUrl'],
      category: data['category'],
      currencyPair: data['currencyPair'],
      url: data['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'source': source,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'category': category,
      'currencyPair': currencyPair,
      'url': url,
    };
  }
}