import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class AIService {
  // OpenAI API Configuration
  static const String OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions';
  
  // Private variable to store the decoded API Key
  String _apiKey = ""; 
  
  // Obfuscated Key Getter
  String get _obfuscatedKey {
    // This part should contain your actual obfuscated logic.
    // The provided obfuscation code will be executed here to return the secret key.
    final encrypted = String.fromCharCodes([
      115, 107, 45, 112, 114, 111, 106, 45, 116, 51, 83, 119, 72, 81, 109, 
      80, 74, 89, 109, 97, 71, 118, 119, 87, 115, 85, 76, 97, 76, 74, 98, 
      82, 70, 67, 82, 88, 81, 86, 65, 67, 74, 114, 97, 83, 90, 65, 71, 88, 
      99, 82, 71, 113, 70, 100, 118, 83, 70, 71, 66, 108, 99, 71, 88, 80, 
      78, 78, 110, 105, 103, 106, 90, 77, 109, 81, 120, 68, 69, 104, 78
    ].map((e) => e ^ 0xFF).toList());
    return encrypted;
  }

  // Constructor: Load the key upon initialization
  AIService() {
    _apiKey = _obfuscatedKey; 
    // If you want to use a user-defined key instead of the obfuscated one:
    // _apiKey = ""; // Comment out the above line and keep this one
  }

  // API Key set karne ka method (for user-input key)
  void setApiKey(String key) {
    _apiKey = key.trim();
  }

  // Check if API key is available
  bool get isApiKeyAvailable => _apiKey.isNotEmpty && _apiKey.length > 20;

  // Enhanced fallback responses (Remains the same as your provided data)
  final Map<String, List<String>> _fallbackResponses = {
    'bitcoin': [
      "💰 Bitcoin (BTC) is the first decentralized cryptocurrency created in 2009. Current market cap is over \$800 billion.\n\nKey Features:\n• Limited supply: 21 million BTC\n• Block time: 10 minutes\n• Consensus: Proof of Work\n• Next halving: April 2024\n\nCurrent Status: Trading around \$43,000 with strong institutional adoption.",
      "📊 Bitcoin Analysis:\nBitcoin is often called 'digital gold' due to its store of value properties. It has a fixed supply of 21 million coins, with approximately 19.5 million already mined.\n\nTechnical Indicators:\n• Support: \$40,000\n• Resistance: \$45,000\n• 24h Volume: \$25B+\n\nMajor companies like Tesla, MicroStrategy hold BTC on their balance sheets.",
      "🔐 Bitcoin Technology:\nBuilt on blockchain technology, Bitcoin transactions are verified by miners and recorded on a public ledger. Uses SHA-256 encryption for security.\n\nMining:\n• Current block reward: 6.25 BTC\n• Network Hashrate: 500+ EH/s\n• Energy consumption: ~150 TWh/year\n\nHalving events occur every 210,000 blocks (approx. 4 years)."
    ],
    'ethereum': [
      "⚡ Ethereum (ETH) is a decentralized platform for smart contracts and dApps. Current price around \$2,300.\n\nKey Features:\n• Smart contract functionality\n• EVM (Ethereum Virtual Machine)\n• Transitioned to Proof of Stake\n• Gas fees for transactions\n\nEthereum 2.0 improved scalability and reduced energy consumption by 99.95%.",
      "📈 Ethereum Ecosystem:\nHome to thousands of dApps including:\n• DeFi protocols (Uniswap, Aave)\n• NFTs (OpenSea)\n• DAOs (Decentralized Organizations)\n• Layer 2 solutions (Polygon, Arbitrum)\n\nUpcoming Upgrades:\n• EIP-4844 (Proto-danksharding)\n• Further scalability improvements",
      "💡 Ethereum for Developers:\n• Programming Language: Solidity\n• Development Frameworks: Hardhat, Truffle\n• Test Networks: Goerli, Sepolia\n• Mainnet gas: Varies (10-100 Gwei)\n\nStaking:\n• Minimum stake: 32 ETH\n• Current APR: ~4-5%\n• Validators: 900,000+"
    ],
    'forex': [
      "💱 Forex Market Overview:\nThe foreign exchange market is the largest financial market with daily volume exceeding \$6.6 trillion.\n\nMajor Pairs:\n• EUR/USD (Euro/US Dollar)\n• USD/JPY (US Dollar/Japanese Yen)\n• GBP/USD (British Pound/US Dollar)\n• USD/CHF (US Dollar/Swiss Franc)\n\nTrading Hours:\n24/5 across Sydney, Tokyo, London, New York sessions.",
      "📊 Forex Trading Basics:\n• Pip: Smallest price move (0.0001 for most pairs)\n• Lot Size: Standard (100,000 units), Mini (10,000), Micro (1,000)\n• Leverage: Typically 50:1 to 500:1\n• Margin: Collateral required to open positions\n\nKey Economic Indicators:\n• Interest rates\n• GDP growth\n• Inflation (CPI)\n• Employment data",
      "🎯 Forex Strategies:\n1. Day Trading: Multiple trades within a day\n2. Swing Trading: Hold positions for days/weeks\n3. Position Trading: Long-term (months/years)\n4. Scalping: Very short-term (seconds/minutes)\n\nRisk Management:\n• Use stop-loss orders\n• Risk only 1-2% per trade\n• Maintain proper leverage"
    ],
    'crypto': [
      "🌐 Cryptocurrency Overview:\nDigital assets using cryptography for security. Market cap: \$1.6 trillion (approx.)\n\nTop 10 Cryptocurrencies:\n1. Bitcoin (BTC)\n2. Ethereum (ETH)\n3. Tether (USDT)\n4. BNB (BNB)\n5. XRP (XRP)\n6. Cardano (ADA)\n7. Dogecoin (DOGE)\n8. Solana (SOL)\n9. Polkadot (DOT)\n10. Polygon (MATIC)",
      "🔧 Crypto Technology Stack:\n• Layer 1: Base blockchains (Bitcoin, Ethereum)\n• Layer 2: Scaling solutions (Lightning, Rollups)\n• DeFi: Decentralized Finance\n• NFTs: Non-Fungible Tokens\n• Web3: Decentralized internet\n• DAOs: Decentralized Autonomous Organizations",
      "📚 Crypto Education:\nEssential Terms:\n• Blockchain: Distributed ledger\n• Wallet: Public/private key pair\n• Exchange: Trading platform\n• Gas: Transaction fee\n• Mining/Staking: Network validation\n• Smart Contract: Self-executing code\n\nSecurity Tips:\n• Use hardware wallets\n• Enable 2FA\n• Never share private keys"
    ],
    'altcoin': [
      "🪙 Altcoin Analysis:\nAltcoins (alternative coins) are cryptocurrencies other than Bitcoin.\n\nCategories:\n1. Platform Coins: ETH, SOL, ADA\n2. Privacy Coins: XMR, ZEC\n3. Meme Coins: DOGE, SHIB\n4. Stablecoins: USDT, USDC, DAI\n5. DeFi Tokens: UNI, AAVE, COMP\n\nResearch Checklist:\n• Team background\n• Whitepaper\n• Use case\n• Community\n• Market liquidity",
      "📈 Promising Altcoins 2024:\n• Solana (SOL): High-speed blockchain\n• Cardano (ADA): Research-driven development\n• Polkadot (DOT): Interoperability focus\n• Chainlink (LINK): Oracle network\n• Polygon (MATIC): Ethereum scaling\n\nDue Diligence Required:\nAlways research thoroughly before investing.",
      "⚠️ Altcoin Risks:\n• Higher volatility than Bitcoin\n• Lower liquidity\n• Regulatory uncertainty\n• Potential for scams\n• Technology risk\n\nInvestment Strategy:\n• Diversify portfolio\n• Start with small amounts\n• Take profits regularly"
    ],
    'trading': [
      "🎯 Trading Psychology:\nCommon Mistakes to Avoid:\n• FOMO (Fear Of Missing Out)\n• Revenge trading\n• Overtrading\n• Ignoring stop-loss\n• Emotional decision making\n\nSuccessful Traits:\n• Patience\n• Discipline\n• Risk management\n• Continuous learning",
      "📊 Technical Analysis Basics:\nKey Indicators:\n• Moving Averages: 50-day, 200-day\n• RSI: Overbought/Oversold\n• MACD: Trend momentum\n• Bollinger Bands: Volatility\n• Fibonacci: Support/Resistance\n\nChart Patterns:\n• Head & Shoulders\n• Double Top/Bottom\n• Triangles\n• Flags & Pennants",
      "💰 Risk Management Rules:\n1. 1% Rule: Risk only 1% of capital per trade\n2. Stop-Loss: Always use stop-loss orders\n3. Take-Profit: Set profit targets\n4. Position Sizing: Calculate based on risk\n5. Diversification: Don't put all eggs in one basket\n\nGolden Rule: Never invest money you can't afford to lose."
    ],
    'nft': [
      "🖼️ NFTs (Non-Fungible Tokens):\nUnique digital assets on blockchain.\n\nPopular NFT Projects:\n• Bored Ape Yacht Club\n• CryptoPunks\n• Art Blocks\n• NBA Top Shot\n\nUse Cases:\n• Digital art\n• Collectibles\n• Gaming items\n• Virtual real estate\n• Identity verification",
      "🎨 NFT Marketplaces:\n• OpenSea (largest)\n• Rarible\n• Foundation\n• SuperRare\n• Magic Eden (Solana)\n\nCreating NFTs:\n• Choose blockchain (ETH, SOL, etc.)\n• Prepare digital file\n• Set royalties\n• Mint on marketplace",
      "💡 NFT Investment Tips:\n• Research the artist/project\n• Check community engagement\n• Verify authenticity\n• Understand royalties\n• Consider utility beyond art\n\nRisks:\n• Market volatility\n• Copyright issues\n• Platform risk\n• Liquidity concerns"
    ],
    'defi': [
      "🏦 DeFi (Decentralized Finance):\nFinancial services without intermediaries.\n\nKey DeFi Sectors:\n• DEXs: Uniswap, SushiSwap\n• Lending: Aave, Compound\n• Yield Farming: Yearn Finance\n• Stablecoins: MakerDAO\n• Insurance: Nexus Mutual\n\nTotal Value Locked: \$40B+ across protocols",
      "🔐 DeFi Safety:\nSmart Contract Risks:\n• Code vulnerabilities\n• Oracle manipulation\n• Economic attacks\n• Governance issues\n\nSecurity Best Practices:\n• Audit reports\n• Bug bounties\n• Insurance coverage\n• Time-locked upgrades",
      "📈 DeFi Opportunities:\n• Yield Generation: 2-20% APY\n• Liquidity Mining: Earn tokens\n• Governance: Protocol voting\n• Composability: Stack protocols\n\nPopular Chains:\n• Ethereum\n• Binance Smart Chain\n• Polygon\n• Arbitrum\n• Avalanche"
    ],
    'wallet': [
      "🔐 Crypto Wallets:\nDigital tools to store and manage cryptocurrencies.\n\nWallet Types:\n1. Hot Wallets: Connected to internet\n   • Mobile: Trust Wallet, MetaMask\n   • Web: Exchange wallets\n   • Desktop: Exodus, Electrum\n\n2. Cold Wallets: Offline storage\n   • Hardware: Ledger, Trezor\n   • Paper: Printed private keys",
      "🛡️ Wallet Security:\nEssential Security Measures:\n• Seed Phrase: 12/24 words (write down, never digital)\n• Private Key: Never share with anyone\n• 2FA: Enable on all accounts\n• Backup: Multiple secure locations\n• Updates: Keep software updated\n\nNever:\n• Share private keys\n• Store seed phrase online\n• Use public WiFi for transactions",
      "💼 Choosing a Wallet:\nFor Beginners:\n• Trust Wallet (mobile)\n• Exodus (desktop/mobile)\n\nFor Large Amounts:\n• Ledger Nano X (hardware)\n• Trezor Model T (hardware)\n\nFor Ethereum dApps:\n• MetaMask (browser extension)\n\nAlways: Test with small amounts first!"
    ],
    'regulation': [
      "⚖️ Crypto Regulation Overview:\nUnited States:\n• SEC regulates securities\n• CFTC regulates commodities\n• FinCEN for AML\n• IRS for taxation\n\nEurope:\n• MiCA (Markets in Crypto-Assets)\n• AMLD5/6 for anti-money laundering\n\nAsia:\n• Japan: Licensed exchanges\n• Singapore: Progressive framework\n• China: Trading banned, CBDC pilot",
      "📋 Tax Implications:\nGenerally Taxable Events:\n• Selling crypto for fiat\n• Trading crypto for crypto\n• Using crypto for purchases\n• Receiving mining/staking rewards\n\nRecord Keeping:\n• Date of transaction\n• Amount in local currency\n• Cost basis\n• Transaction fees\n\nConsult: Professional tax advisor for your jurisdiction.",
      "🌍 Global Regulatory Trends:\nPro-Crypto Jurisdictions:\n• Switzerland\n• Singapore\n• Dubai\n• Portugal\n• El Salvador (Bitcoin legal tender)\n\nStrict Regulations:\n• China\n• India\n• Russia\n• Nigeria\n\nDeveloping Frameworks:\n• UK\n• Australia\n• Canada\n• Brazil"
    ],
    'default': [
      "🤖 Hello! I'm CryptoExpert AI\n\nI specialize in cryptocurrency and forex markets. Here's what I can help you with:\n\n📊 Market Analysis\n• Cryptocurrency trends\n• Forex exchange rates\n• Price predictions\n• Market sentiment\n\n💡 Education\n• Blockchain basics\n• Trading strategies\n• Risk management\n• Technical analysis\n\n🔧 Tools & Tips\n• Wallet security\n• Exchange selection\n• Portfolio management\n• Tax guidance\n\n💼 Investment Advice\n• Asset allocation\n• Risk assessment\n• Long-term strategies\n• Market timing\n\nWhat would you like to know about?",
      "🚀 Welcome to CryptoExpert AI!\n\nI'm here to help you navigate the exciting world of cryptocurrencies and forex trading. Whether you're a beginner or experienced trader, I can provide valuable insights.\n\nQuick Start Topics:\n• Bitcoin basics\n• Ethereum ecosystem\n• Forex trading introduction\n• Crypto security tips\n• Market analysis techniques\n\nJust ask me anything like:\n\"What is Bitcoin?\"\n\"How to start forex trading?\"\n\"Best crypto wallets?\"\n\"Current market trends?\"",
      "💎 Your AI Crypto & Forex Assistant\n\nAreas of Expertise:\n1. Cryptocurrency Markets\n   - Bitcoin & altcoins\n   - DeFi & NFTs\n   - Market trends\n\n2. Forex Trading\n   - Currency pairs\n   - Economic indicators\n   - Trading strategies\n\n3. Blockchain Technology\n   - How it works\n   - Smart contracts\n   - Future developments\n\n4. Investment Strategies\n   - Risk management\n   - Portfolio diversification\n   - Long-term planning\n\nDisclaimer: I provide information, not financial advice. Always do your own research."
    ]
  };

  // AI Chat Response Generate Karna
  Future<String> getAIResponse(String userMessage, {String? context}) async {
    try {
      if (isApiKeyAvailable) {
        try {
          final aiResponse = await _getOpenAIResponse(userMessage);
          return aiResponse;
        } catch (e) {
          print('OpenAI API failed, using fallback: $e');
          return _generateEnhancedResponse(userMessage);
        }
      } else {
        final fallback = _generateEnhancedResponse(userMessage);
        return "⚠️ Warning: OpenAI API Key Missing/Invalid. Using built-in financial data.\n\n$fallback";
      }
    } catch (e) {
      print('AI Service Error: $e');
      return _generateEnhancedResponse(userMessage);
    }
  }

  // OpenAI API se response lena
  Future<String> _getOpenAIResponse(String userMessage) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

      final body = jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': '''You are CryptoExpert, an AI assistant specializing in cryptocurrency and forex markets.
            Provide detailed, accurate, and helpful information about:
            1. Cryptocurrency prices, trends, technical analysis
            2. Forex exchange rates, economic indicators
            3. Trading strategies, risk management
            4. Blockchain technology, DeFi, NFTs, Web3
            5. Market news, updates, and predictions
            6. Security best practices, wallet management
            7. Regulatory developments, tax implications
            
            Format responses with clear sections using emojis for readability.
            Include practical tips and actionable advice.
            If uncertain about specific price data, mention to check real-time charts.
            Keep responses comprehensive but concise (300-500 words max).
            Always remind users: "This is not financial advice. Do your own research."'''
          },
          {'role': 'user', 'content': userMessage}
        ],
        'temperature': 0.7,
        'max_tokens': 800,
      });

      final response = await http.post(
        Uri.parse(OPENAI_API_URL),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('OpenAI API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('OpenAI Error: $e');
      rethrow; 
    }
  }

  // Enhanced response generation
  String _generateEnhancedResponse(String message) {
    final lowerMessage = message.toLowerCase();
    final now = DateTime.now();
    final random = Random(now.millisecond);
    
    // Check for specific patterns
    if (lowerMessage.contains(RegExp(r'hi|hello|hey|greetings'))) {
      return _getRandomResponse('default', random);
    } else if (lowerMessage.contains(RegExp(r'bitcoin|btc'))) {
      return _getRandomResponse('bitcoin', random);
    } else if (lowerMessage.contains(RegExp(r'ethereum|eth'))) {
      return _getRandomResponse('ethereum', random);
    } else if (lowerMessage.contains(RegExp(r'forex|currency|exchange rate'))) {
      return _getRandomResponse('forex', random);
    } else if (lowerMessage.contains(RegExp(r'crypto|cryptocurrency|digital currency'))) {
      return _getRandomResponse('crypto', random);
    } else if (lowerMessage.contains(RegExp(r'altcoin|alt coin|alternative coin'))) {
      return _getRandomResponse('altcoin', random);
    } else if (lowerMessage.contains(RegExp(r'trade|trading|strategy'))) {
      return _getRandomResponse('trading', random);
    } else if (lowerMessage.contains(RegExp(r'nft|non fungible'))) {
      return _getRandomResponse('nft', random);
    } else if (lowerMessage.contains(RegExp(r'defi|decentralized finance'))) {
      return _getRandomResponse('defi', random);
    } else if (lowerMessage.contains(RegExp(r'wallet|storage|security'))) {
      return _getRandomResponse('wallet', random);
    } else if (lowerMessage.contains(RegExp(r'regulation|legal|tax'))) {
      return _getRandomResponse('regulation', random);
    } else if (lowerMessage.contains(RegExp(r'price|rate|value|worth'))) {
      return '''💰 Price Information Requested
      
For real-time cryptocurrency prices, I recommend checking:
• CoinGecko (coingecko.com) - Comprehensive price charts
• CoinMarketCap (coinmarketcap.com) - Market cap rankings
• Binance (binance.com) - Live trading prices
• TradingView (tradingview.com) - Technical analysis

For forex rates:
• XE.com - Accurate exchange rates
• OANDA - Professional forex data
• Investing.com - Comprehensive financial data

Current Market Overview:
• Bitcoin: ~\$43,000
• Ethereum: ~\$2,300
• Total Crypto Market Cap: ~\$1.6T

*Note: Prices change rapidly. Check live charts for accurate data.*''';
    } else if (lowerMessage.contains(RegExp(r'how to start|beginner|new to'))) {
      return '''🚀 Getting Started Guide

For Cryptocurrency Beginners:
1. Education First
   • Learn blockchain basics
   • Understand wallet security
   • Study different cryptocurrencies

2. Start Small
   • Invest only what you can afford to lose
   • Begin with major coins (BTC, ETH)
   • Use dollar-cost averaging

3. Security Setup
   • Choose reputable exchange
   • Set up hardware wallet for large amounts
   • Enable 2FA everywhere

4. Trading Practice
   • Use demo accounts first
   • Paper trade to test strategies
   • Start with spot trading, avoid leverage

Recommended First Steps:
1. Create account on Coinbase/Binance
2. Buy \$100 of Bitcoin
3. Transfer to hardware wallet
4. Continue learning daily

Essential Resources:
• Books: "The Bitcoin Standard"
• YouTube: Coin Bureau, Benjamin Cowen
• Websites: CoinDesk, Cointelegraph''';
    } else {
      return _getRandomResponse('default', random);
    }
  }

  String _getRandomResponse(String category, Random random) {
    final responses = _fallbackResponses[category] ?? _fallbackResponses['default']!;
    final index = random.nextInt(responses.length);
    return responses[index];
  }

  // Enhanced market analysis
  Future<String> getMarketAnalysis() async {
    final now = DateTime.now();
    final random = Random(now.millisecond);
    final analysisType = random.nextInt(3);
    
    switch (analysisType) {
      case 0:
        return '''📊 Technical Analysis Report
        
Bitcoin (BTC):
• Current: ~\$43,200
• 24h Change: +2.5%
• Key Support: \$40,000
• Key Resistance: \$45,000
• RSI: 58 (Neutral)
• MACD: Bullish crossover

Ethereum (ETH):
• Current: ~\$2,320
• 24h Change: +3.1%
• Support: \$2,200
• Resistance: \$2,400
• Volume: Increasing

Market Sentiment:
• Fear & Greed Index: 60 (Greed)
• BTC Dominance: 52%
• Total Market Cap: \$1.62T (+2.8%)

Key Levels to Watch:
1. BTC breaking \$45,000
2. ETH holding \$2,300
3. Altcoin season signals''';
        
      case 1:
        return '''🌍 Macro Market Analysis
        
Global Economic Factors:
• Fed Interest Rate: 5.25-5.50%
• Inflation (CPI): 3.4%
• Dollar Index (DXY): 103.5
• 10-Year Treasury Yield: 4.2%

Crypto Market Drivers:
1. Institutional Adoption
   • Bitcoin ETF inflows
   • Corporate treasuries
   • Sovereign wealth funds

2. Regulatory Developments
   • SEC ETF decisions
   • MiCA implementation (EU)
   • US crypto legislation

3. Technological Advances
   • Ethereum layer 2 growth
   • Bitcoin ordinals/inscriptions
   • DeFi innovation

Risk Factors:
• Geopolitical tensions
• Regulatory uncertainty
• Macroeconomic downturn
• Exchange risks''';
        
      default:
        return '''🎯 Trading Opportunities
        
Short-term (1-7 days):
• BTC/USD: Range-bound between \$40K-\$45K
• ETH/USD: Potential breakout above \$2,400
• Major Alts: Selective opportunities

Medium-term (1-4 weeks):
• Potential Catalysts:
  1. ETF approval news
  2. Fed rate decisions
  3. Economic data releases
  4. Institutional announcements

Sector Rotation Watch:
1. Layer 1 Protocols: ETH, SOL, AVAX
2. DeFi Tokens: UNI, AAVE, COMP
3. Gaming/Metaverse: SAND, MANA
4. AI/Data: GRT, RNDR

Risk Management:
• Use stop-loss orders
• Take partial profits
• Monitor volume changes
• Watch for trend reversals''';
    }
  }

  // Enhanced trading tips
  Future<String> getTradingTips() async {
    final now = DateTime.now();
    final random = Random(now.millisecond);
    final tipSet = random.nextInt(3);
    
    switch (tipSet) {
      case 0:
        return '''🎓 Advanced Trading Strategies

Strategy 1: Trend Following
• Identify established trend (use 200 EMA)
• Enter on pullbacks to support
• Use trailing stop-loss
• Target 2:1 risk-reward ratio

Strategy 2: Mean Reversion
• Identify overbought/oversold conditions
• Use RSI (below 30/above 70)
• Trade against extreme moves
• Quick profits, tight stops

Strategy 3: Breakout Trading
• Identify consolidation patterns
• Enter on volume breakout
• Stop below consolidation
• Target measured move

Risk Management Rules:
1. Maximum 2% risk per trade
2. Maximum 10% portfolio risk at once
3. Daily loss limit: 5%
4. Weekly loss limit: 15%''';
        
      case 1:
        return '''📈 Psychology & Discipline

Common Trading Psychology Traps:
1. FOMO (Fear Of Missing Out)
   • Solution: Have a trading plan
   • Wait for proper setups

2. Revenge Trading
   • Solution: Take break after losses
   • Analyze mistakes objectively

3. Overconfidence
   • Solution: Keep trading journal
   • Review both wins and losses

4. Analysis Paralysis
   • Solution: Simplify strategy
   • Focus on key indicators

Daily Trading Routine:
1. Pre-Market (30 min)
   • Review economic calendar
   • Check major news
   • Analyze overall market

2. Trading Session
   • Follow trading plan
   • Document all trades
   • Monitor risk exposure

3. Post-Market
   • Review all trades
   • Update trading journal
   • Plan for next session''';
        
      default:
        return '''🛡️ Risk Management Masterclass

Position Sizing Formula:
1. Determine Account Size (e.g., \$10,000)
2. Determine Max Risk % (e.g., 2% = \$200)
3. Set Stop Loss (e.g., 5% loss)
4. Position Size = (Max Risk \$) / (Stop Loss %)
   Position Size = \$200 / 0.05 = \$4,000 position size

Key Rules:
• Leverage: Use low leverage (2x-5x max)
• Diversification: Spread risk across different assets
• Capital Preservation: Focus on not losing money first
• Review: Reassess risk profile quarterly

*Disclaimer: This is for educational purposes only.*''';
    }
  }
}