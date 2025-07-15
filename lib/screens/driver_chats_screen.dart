import 'package:flutter/material.dart';
import '../widgets/driver_bottom_nav_bar.dart';
import '../widgets/driver_profile_drawer.dart';

/// Driver chats screen - displays chat conversations for the driver.
/// 
/// This screen provides:
/// - List of chat threads with passengers
/// - Navigation to individual chat details
class DriverChatsScreen extends StatefulWidget {
  const DriverChatsScreen();

  @override
  State<DriverChatsScreen> createState() => _DriverChatsScreenState();
}

class _DriverChatsScreenState extends State<DriverChatsScreen> {
  // hardcoded chat conversations with passengers from ride history
  final List<ChatConversation> _conversations = [
    ChatConversation(
      passengerName: 'Marie Tan',
      lastMessage: 'Thank you for the safe ride!',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      route: 'Tampines Hub → Temasek Polytechnic',
      messages: [
        ChatMessage(
          message: "Hi! I'm on my way to the pickup point",
          isFromDriver: true,
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
        ),
        ChatMessage(
          message: "Great! I'll be waiting at the main entrance",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 55)),
        ),
        ChatMessage(
          message: "I can see you! I'm in the Toyota Camry",
          isFromDriver: true,
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 50)),
        ),
        ChatMessage(
          message: "Perfect, coming now!",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 45)),
        ),
        ChatMessage(
          message: "Thank you for the safe ride!",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
        ),
      ],
    ),
    ChatConversation(
      passengerName: 'John Lim',
      lastMessage: 'See you next week!',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      route: 'Bedok Mall → Singapore Polytechnic',
      messages: [
        ChatMessage(
          message: "Good morning! Running 5 minutes late",
          isFromDriver: true,
          timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
        ),
        ChatMessage(
          message: "No worries, I'll wait by the entrance",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 55)),
        ),
        ChatMessage(
          message: "Thanks for understanding! Almost there",
          isFromDriver: true,
          timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 50)),
        ),
        ChatMessage(
          message: "All good, drive safely!",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 1, minutes: 45)),
        ),
        ChatMessage(
          message: "See you next week!",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 1)),
        ),
      ],
    ),
    ChatConversation(
      passengerName: 'Sarah Wong',
      lastMessage: 'Great ride, thanks!',
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      route: 'Jurong East → NTU',
      messages: [
        ChatMessage(
          message: "I'm at the pickup point, where should I wait?",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 2, hours: 1)),
        ),
        ChatMessage(
          message: "Please wait at the bus stop, I'll be there in 2 minutes",
          isFromDriver: true,
          timestamp: DateTime.now().subtract(Duration(days: 2, minutes: 58)),
        ),
        ChatMessage(
          message: "Perfect! I can see you coming",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 2, minutes: 55)),
        ),
        ChatMessage(
          message: "Great ride, thanks!",
          isFromDriver: false,
          timestamp: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00), // orange background theme
      // side drawer for profile menu
      endDrawer: DriverProfileDrawer(),
      body: Column(
        children: [
          // main content area with chats
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header section with title and profile icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // page title and subtitle
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CarpoolSG (Driver)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your conversations',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // profile icon that opens side drawer
                        GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Material(
                            elevation: 4, // shadow effect
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF8C00),
                              child: Icon(Icons.person, size: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // chat conversations list
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _conversations.isEmpty
                          ? _buildNoChatView()
                          : _buildConversationsList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottom navigation bar with rounded corners
          Container(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const DriverBottomNavBar(currentIndex: 3), // highlight chats tab
          ),
        ],
      ),
    );
  }

  // widget shown when no conversations exist
  Widget _buildNoChatView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No Conversations Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start offering rides to chat with passengers',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // widget showing list of conversations
  Widget _buildConversationsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return _buildConversationCard(conversation);
      },
    );
  }

  // helper widget to build individual conversation cards
  Widget _buildConversationCard(ChatConversation conversation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFFF8C00),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            conversation.passengerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.route,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                conversation.lastMessage,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Text(
            _formatTime(conversation.timestamp),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          onTap: () {
            _openChatDetail(conversation);
          },
        ),
      ),
    );
  }

  // opens detailed chat view for a conversation
  void _openChatDetail(ChatConversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverChatDetailScreen(conversation: conversation),
      ),
    );
  }

  // formats timestamp for display
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Driver chat detail screen - displays a single chat thread.
class DriverChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;

  const DriverChatDetailScreen({required this.conversation});

  @override
  State<DriverChatDetailScreen> createState() => _DriverChatDetailScreenState();
}

class _DriverChatDetailScreenState extends State<DriverChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8C00),
      body: Column(
        children: [
          // header section
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // passenger info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.conversation.passengerName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.conversation.route,
                          style: TextStyle(
                            color: const Color(0xCCFFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // chat messages area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // messages list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
                  ),
                  
                  // message input area
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      children: [
                        // text input field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // send button
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF8C00),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // helper widget to build individual message bubbles
  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isFromDriver 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: [
          if (!message.isFromDriver) ...[
            // passenger avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 16,
              ),
            ),
            SizedBox(width: 8),
          ],
          // message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromDriver 
                  ? Color(0xFFFF8C00)
                  : Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isFromDriver 
                        ? Colors.white
                        : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isFromDriver 
                        ? const Color(0xCCFFFFFF)
                        : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromDriver) ...[
            SizedBox(width: 8),
            // driver avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFF8C00),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // sends a new message
  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          message: _messageController.text.trim(),
          isFromDriver: true,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
    }
  }

  // formats timestamp for display
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// model classes for chat data
class ChatConversation {
  final String passengerName;
  final String lastMessage;
  final DateTime timestamp;
  final String route;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.passengerName,
    required this.lastMessage,
    required this.timestamp,
    required this.route,
    required this.messages,
  });
}

class ChatMessage {
  final String message;
  final bool isFromDriver;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isFromDriver,
    required this.timestamp,
  });
} 