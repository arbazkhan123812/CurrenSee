import 'package:flutter/material.dart';
import 'package:my_project/models/chat_msg.dart';
import 'package:my_project/services/ai_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  final Uuid _uuid = Uuid();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // Predefined questions for quick access
  final List<Map<String, String>> _quickQuestions = [
    {'emoji': '💰', 'text': 'Bitcoin price analysis?'},
    {'emoji': '📈', 'text': 'Market trends today?'},
    {'emoji': '💱', 'text': 'Best forex pairs to trade?'},
    {'emoji': '⚡', 'text': 'Ethereum 2.0 update?'},
    {'emoji': '🔒', 'text': 'How to secure crypto?'},
    {'emoji': '🎯', 'text': 'Beginner trading tips?'},
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      text: '''👋 Hello! I'm CryptoExpert AI 🤖

I can help you with:
• Cryptocurrency information and prices
• Forex market updates and analysis
• Trading strategies and risk management
• Blockchain technology explanations
• Market news and trends

How can I assist you with crypto and forex markets today?''',
      timestamp: DateTime.now(),
      isUser: false,
    );
    
    setState(() {
      _messages.add(welcomeMessage);
    });
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: messageText,
      timestamp: DateTime.now(),
      isUser: true,
    );

    // Add loading indicator
    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      text: 'Thinking...',
      timestamp: DateTime.now(),
      isUser: false,
      isLoading: true,
    );

    setState(() {
      _messages.add(userMessage);
      _messages.add(loadingMessage);
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    // Get AI response
    try {
      final aiResponse = await _aiService.getAIResponse(messageText);
      
      // Remove loading message and add AI response
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: aiResponse,
          timestamp: DateTime.now(),
          isUser: false,
        ));
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting AI response: $e');
      
      // Add error message
      setState(() {
        _messages.removeLast(); // Remove loading message
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: 'Sorry, I encountered an error. Please try again.',
          timestamp: DateTime.now(),
          isUser: false,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleQuickQuestion(String question) {
    _messageController.text = question;
    _sendMessage();
  }

  Future<void> _getMarketAnalysis() async {
    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      text: 'Generating market analysis...',
      timestamp: DateTime.now(),
      isUser: false,
      isLoading: true,
    );

    setState(() {
      _messages.add(loadingMessage);
    });

    _scrollToBottom();

    try {
      final analysis = await _aiService.getMarketAnalysis();
      
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: analysis,
          timestamp: DateTime.now(),
          isUser: false,
        ));
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: 'Unable to generate market analysis at the moment.',
          timestamp: DateTime.now(),
          isUser: false,
        ));
      });
    }

    _scrollToBottom();
  }

  Future<void> _getTradingTips() async {
    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      text: 'Getting trading tips...',
      timestamp: DateTime.now(),
      isUser: false,
      isLoading: true,
    );

    setState(() {
      _messages.add(loadingMessage);
    });

    _scrollToBottom();

    try {
      final tips = await _aiService.getTradingTips();
      
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: tips,
          timestamp: DateTime.now(),
          isUser: false,
        ));
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          id: _uuid.v4(),
          text: 'Unable to fetch trading tips at the moment.',
          timestamp: DateTime.now(),
          isUser: false,
        ));
      });
    }

    _scrollToBottom();
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat'),
        content: Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
              });
              _addWelcomeMessage();
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: _getMarketAnalysis,
            tooltip: 'Market Analysis',
          ),
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: _getTradingTips,
            tooltip: 'Trading Tips',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Questions Bar
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.indigo[50],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickQuestions.length,
              itemBuilder: (context, index) {
                final question = _quickQuestions[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: () => _handleQuickQuestion(question['text']!),
                    icon: Text(question['emoji']!),
                    label: Text(
                      question['text']!,
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.indigo.shade200),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Ask about crypto or forex...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                            ),
                            maxLines: null,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file, color: Colors.indigo),
                          onPressed: () {
                            // Optional: Add file attachment functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.blue],
                    ),
                  ),
                  child: IconButton(
                    icon: _isLoading 
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: EdgeInsets.only(right: 8, top: 4),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 16,
                child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
              ),
            ),
          
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.indigo[50] : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isUser ? Colors.indigo.shade100 : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: message.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.indigo,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              message.text,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : SelectableText(
                          message.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                ),
                
                SizedBox(height: 4),
                
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser)
            Container(
              margin: EdgeInsets.only(left: 8, top: 4),
              child: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 16,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}