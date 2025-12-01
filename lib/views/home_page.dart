import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:my_project/models/Currency_news.dart';
import 'package:my_project/services/api_services.dart';
import 'package:my_project/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  StorageService _storageService = StorageService();
}

class _HomePageState extends State<HomePage> {
  List<CurrencyNews> newsList = [];
  Map<String, dynamic> exchangeRates = {};
  Map<String, dynamic> cryptoPrices = {};
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchAllMarketData();
  }

  Future<void> _fetchAllMarketData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final news = await _apiService.fetchCurrencyNews();
      final rates = await _apiService.fetchExchangeRates();
      final crypto = await _apiService.fetchCryptoPrices();
      
      setState(() {
        newsList = news;
        exchangeRates = rates;
        cryptoPrices = crypto;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching market data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Markets"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[800],
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchAllMarketData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAllMarketData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Market Trends Section
                    _buildMarketTrendsSection(),
                    
                    // Crypto Section
                    _buildCryptoSection(),
                    
                    // Currency News Section
                    _buildCurrencyNewsSection(),
                    
                    // Your Existing Product Carousel
                    _buildProductCarousel(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMarketTrendsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "💱 Forex Exchange Rates",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          
          // Exchange Rates Cards
          if (exchangeRates.isNotEmpty) ...[
            _buildForexCard("USD → PKR", exchangeRates['usd_to_pkr']['rate'],
                exchangeRates['usd_to_pkr']['change'], exchangeRates['usd_to_pkr']['change_percent']),
            SizedBox(height: 10),
            _buildForexCard("USD → EUR", exchangeRates['usd_to_eur']['rate'],
                exchangeRates['usd_to_eur']['change'], exchangeRates['usd_to_eur']['change_percent']),
            SizedBox(height: 10),
            _buildForexCard("USD → GBP", exchangeRates['usd_to_gbp']['rate'],
                exchangeRates['usd_to_gbp']['change'], exchangeRates['usd_to_gbp']['change_percent']),
          ],
          
          SizedBox(height: 10),
          Text(
            "Base: ${exchangeRates['base_currency'] ?? 'USD'} • Updated: ${DateFormat('hh:mm a').format(DateTime.now())}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForexCard(String title, double rate, double change, String changePercent) {
    bool isPositive = change >= 0;
    
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                "1 ${title.split(' → ')[0]}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rate.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 2),
                        Text(
                          "${isPositive ? '+' : ''}$changePercent%",
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${isPositive ? '+' : ''}${change.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💰 Cryptocurrency",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          
          if (cryptoPrices.isNotEmpty) ...[
            _buildCryptoCard("Bitcoin", cryptoPrices['bitcoin']),
            SizedBox(height: 10),
            _buildCryptoCard("Ethereum", cryptoPrices['ethereum']),
            SizedBox(height: 10),
            _buildCryptoCard("Ripple", cryptoPrices['ripple']),
          ],
          
          SizedBox(height: 10),
          Text(
            "Data from CoinGecko • 24h Change",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(String name, Map<String, dynamic> data) {
    bool isPositive = data['change_24h'] >= 0;
    
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCryptoColor(name),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    data['symbol'] ?? name[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    data['symbol'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${data['price'].toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 2),
                    Text(
                      "${isPositive ? '+' : ''}${data['change_24h'].toStringAsFixed(2)}%",
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCryptoColor(String name) {
    switch (name.toLowerCase()) {
      case 'bitcoin':
        return Colors.orange;
      case 'ethereum':
        return Colors.purple;
      case 'ripple':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCurrencyNewsSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "📰 Latest Financial News",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _fetchAllMarketData,
                icon: Icon(Icons.refresh, size: 16),
                label: Text("Refresh"),
              ),
            ],
          ),
          SizedBox(height: 10),
          
          if (newsList.isEmpty)
            _buildEmptyNewsState()
          else
            ...newsList.take(5).map((news) => _buildNewsCard(news)).toList(),
          
          if (newsList.length > 5)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to all news page
                  },
                  child: Text("View All News"),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(CurrencyNews news) {
    return GestureDetector(
      onTap: () {
        if (news.url != null) {
          _launchURL(news.url!);
        }
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image
              if (news.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    news.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(news.category),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCategoryIcon(news.category),
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(news.category),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(news.category),
                    color: Colors.white,
                  ),
                ),
              
              SizedBox(width: 12),
              
              // News Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    if (news.category != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(news.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          news.category!,
                          style: TextStyle(
                            fontSize: 10,
                            color: _getCategoryColor(news.category),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 6),
                    
                    // Title
                    Text(
                      news.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 4),
                    
                    // Description
                    Text(
                      news.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Source and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          news.source,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(news.date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'cryptocurrency':
        return Colors.orange;
      case 'forex':
        return Colors.blue;
      case 'stock market':
        return Colors.green;
      case 'finance':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'cryptocurrency':
        return Icons.currency_bitcoin;
      case 'forex':
        return Icons.currency_exchange;
      case 'stock market':
        return Icons.trending_up;
      case 'finance':
        return Icons.monetization_on;
      default:
        return Icons.article;
    }
  }

  Widget _buildEmptyNewsState() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off, size: 50, color: Colors.grey),
          SizedBox(height: 15),
          Text(
            "No Internet Connection",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Check your connection and try again",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: _fetchAllMarketData,
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCarousel() {
    return FutureBuilder(
      future: widget._storageService.getproductdata(null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(); // Hide if error
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(); // Empty widget if no products
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Featured Products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: Swiper(
                  itemCount: snapshot.data!.length > 3 ? 3 : snapshot.data!.length,
                  autoplay: true,
                  autoplayDelay: 3000,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: Colors.blue,
                      size: 8.0,
                      activeSize: 12.0,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.amber,
                        child: Center(
                          child: Text(
                            "Product ${index + 1}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}