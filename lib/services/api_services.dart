import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_project/models/Currency_news.dart';
import 'package:intl/intl.dart';

class ApiService {
  // API Keys (Replace with your own keys)
  static const String NEWS_API_KEY = '5e8c7aaec47144cb8e425213075687a7';
  static const String EXCHANGE_RATE_API_KEY = 'YOUR_EXCHANGERATE_API_KEY';
  static const String CRYPTO_API_KEY = 'YOUR_CRYPTO_API_KEY';
  
  // Base URLs
  static const String NEWS_API_URL = 'https://newsapi.org/v2/everything';
  static const String EXCHANGE_RATE_API_URL = 'https://api.exchangerate-api.com/v4/latest/USD';
  static const String CRYPTO_API_URL = 'https://api.coingecko.com/api/v3';
  static const String FINANCIAL_NEWS_API_URL = 'https://finnhub.io/api/v1/news';

  // NewsAPI se currency, crypto aur forex news fetch karna
  Future<List<CurrencyNews>> fetchCurrencyNews() async {
    try {
      final queryParams = {
        'q': 'currency OR forex OR cryptocurrency OR bitcoin OR ethereum OR stock market',
        'apiKey': NEWS_API_KEY,
        'language': 'en',
        'sortBy': 'publishedAt',
        'pageSize': '10',
        'domains': 'bloomberg.com,reuters.com,coindesk.com,cointelegraph.com,financialtimes.com'
      };

      final uri = Uri.parse(NEWS_API_URL).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        
        List<CurrencyNews> newsList = [];
        
        for (var article in articles) {
          // Filter out articles without proper content
          if (article['title'] != null && 
              article['description'] != null &&
              article['title'].toString().toLowerCase().contains(RegExp(r'(currency|forex|crypto|bitcoin|ethereum|stock|market|exchange|finance)'))) {
            
            newsList.add(CurrencyNews(
              id: article['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: article['title'] ?? 'No Title',
              description: article['description'] ?? 'No Description',
              source: article['source']['name'] ?? 'Unknown Source',
              date: DateTime.parse(article['publishedAt'] ?? DateTime.now().toIso8601String()),
              imageUrl: article['urlToImage'],
              category: _determineCategory(article['title']),
              currencyPair: _extractCurrencyPair(article['title']),
              url: article['url'],
            ));
          }
        }
        
        return newsList;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      // Fallback: Mock data agar API fail ho jaye
      return _getMockNews();
    }
  }

  // Real-time exchange rates fetch karna
  Future<Map<String, dynamic>> fetchExchangeRates() async {
    try {
      // Option 1: ExchangeRate-API (Free)
      final response = await http.get(Uri.parse(EXCHANGE_RATE_API_URL));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        // Calculate changes (ye demo hai, real app mein previous rates compare karen)
        return {
          'usd_to_pkr': {
            'rate': rates['PKR']?.toDouble() ?? 280.0,
            'change': (rates['PKR']?.toDouble() ?? 280.0) - 279.5,
            'change_percent': (((rates['PKR']?.toDouble() ?? 280.0) - 279.5) / 279.5 * 100).toStringAsFixed(2),
          },
          'usd_to_eur': {
            'rate': rates['EUR']?.toDouble() ?? 0.92,
            'change': (rates['EUR']?.toDouble() ?? 0.92) - 0.91,
            'change_percent': (((rates['EUR']?.toDouble() ?? 0.92) - 0.91) / 0.91 * 100).toStringAsFixed(2),
          },
          'usd_to_gbp': {
            'rate': rates['GBP']?.toDouble() ?? 0.79,
            'change': (rates['GBP']?.toDouble() ?? 0.79) - 0.78,
            'change_percent': (((rates['GBP']?.toDouble() ?? 0.79) - 0.78) / 0.78 * 100).toStringAsFixed(2),
          },
          'updated_at': DateTime.now().toIso8601String(),
          'base_currency': data['base'],
        };
      }
      
      throw Exception('Failed to fetch exchange rates');
    } catch (e) {
      print('Error fetching exchange rates: $e');
      return _getMockExchangeRates();
    }
  }

  // Crypto prices fetch karna
  Future<Map<String, dynamic>> fetchCryptoPrices() async {
    try {
      final response = await http.get(
        Uri.parse('$CRYPTO_API_URL/simple/price?ids=bitcoin,ethereum,ripple,cardano&vs_currencies=usd&include_24hr_change=true')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return {
          'bitcoin': {
            'price': data['bitcoin']['usd']?.toDouble() ?? 0,
            'change_24h': data['bitcoin']['usd_24h_change']?.toDouble() ?? 0,
            'symbol': 'BTC',
          },
          'ethereum': {
            'price': data['ethereum']['usd']?.toDouble() ?? 0,
            'change_24h': data['ethereum']['usd_24h_change']?.toDouble() ?? 0,
            'symbol': 'ETH',
          },
          'ripple': {
            'price': data['ripple']['usd']?.toDouble() ?? 0,
            'change_24h': data['ripple']['usd_24h_change']?.toDouble() ?? 0,
            'symbol': 'XRP',
          },
          'updated_at': DateTime.now().toIso8601String(),
        };
      }
      
      throw Exception('Failed to fetch crypto prices');
    } catch (e) {
      print('Error fetching crypto prices: $e');
      return _getMockCryptoPrices();
    }
  }

  // Helper function to determine category
  String _determineCategory(String title) {
    final titleLower = title.toLowerCase();
    
    if (titleLower.contains('bitcoin') || titleLower.contains('crypto')) {
      return 'Cryptocurrency';
    } else if (titleLower.contains('forex') || titleLower.contains('currency')) {
      return 'Forex';
    } else if (titleLower.contains('stock') || titleLower.contains('market')) {
      return 'Stock Market';
    } else {
      return 'Finance';
    }
  }

  // Helper function to extract currency pair
  String? _extractCurrencyPair(String title) {
    final regex = RegExp(r'([A-Z]{3}/[A-Z]{3}|[A-Z]{3}-[A-Z]{3})');
    final match = regex.firstMatch(title.toUpperCase());
    return match?.group(0);
  }

  // Mock data functions (fallback)
  List<CurrencyNews> _getMockNews() {
    return [
      CurrencyNews(
        id: '1',
        title: 'Bitcoin Surges Past 45,000 Amid ETF Approval Rumors',
        description: 'Bitcoin price jumped 5% following rumors of potential ETF approvals in the US market.',
        source: 'CoinDesk',
        date: DateTime.now().subtract(Duration(hours: 2)),
        imageUrl: 'https://images.cointelegraph.com/images/1200_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS91cGxvYWRzLzIwMjMtMTIvYjQxODI1MjctODk2NC00N2NhLTg5ZDUtNmUxY2U3ZDhmYTM1LmpwZw==.jpg',
        category: 'Cryptocurrency',
        currencyPair: 'BTC/USD',
      ),
      CurrencyNews(
        id: '2',
        title: 'Pakistani Rupee Strengthens Against US Dollar',
        description: 'PKR gains 50 paisa against USD in interbank trading following improved economic indicators.',
        source: 'Bloomberg',
        date: DateTime.now().subtract(Duration(hours: 4)),
        imageUrl: 'https://www.bloomberg.com/features/2019-currency/assets/img/og-image.jpg',
        category: 'Forex',
        currencyPair: 'USD/PKR',
      ),
      CurrencyNews(
        id: '3',
        title: 'Federal Reserve Holds Interest Rates Steady',
        description: 'The Federal Reserve maintains current interest rates, impacting global currency markets.',
        source: 'Reuters',
        date: DateTime.now().subtract(Duration(hours: 6)),
        category: 'Finance',
        currencyPair: null,
      ),
    ];
  }

  Map<String, dynamic> _getMockExchangeRates() {
    return {
      'usd_to_pkr': {'rate': 280.25, 'change': 0.75, 'change_percent': 0.27},
      'usd_to_eur': {'rate': 0.92, 'change': -0.01, 'change_percent': -1.08},
      'usd_to_gbp': {'rate': 0.79, 'change': 0.02, 'change_percent': 2.59},
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _getMockCryptoPrices() {
    return {
      'bitcoin': {'price': 45230.50, 'change_24h': 3.5, 'symbol': 'BTC'},
      'ethereum': {'price': 2410.75, 'change_24h': 2.1, 'symbol': 'ETH'},
      'ripple': {'price': 0.62, 'change_24h': 1.2, 'symbol': 'XRP'},
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}