import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';
import '../services/booking_service.dart';

// passenger chats page - messaging interface with drivers
// displays chat conversations and messaging functionality
class PassengerChatsPage extends StatefulWidget {
  const PassengerChatsPage();

  @override
  State<PassengerChatsPage> createState() => _PassengerChatsPageState();
}

class _PassengerChatsPageState extends State<PassengerChatsPage> {
  final BookingService _bookingService = BookingService();
  final TextEditingController _messageController = TextEditingController();
  
  // sample chat messages for demo
  final List<ChatMessage> _messages = [
    ChatMessage(
      message: "Hi! I'm on my way to the pickup point",
      isFromDriver: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      message: "Great! I'll be waiting at the main entrance",
      isFromDriver: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    ),
    ChatMessage(
      message: "I'm driving a Toyota Camry, license plate SBA1234X",
      isFromDriver: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
    ChatMessage(
      message: "Perfect, I can see you!",
      isFromDriver: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final currentBooking = _bookingService.currentBooking;
    final hasActiveBooking = _bookingService.hasActiveBooking;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00), // orange background theme
      // side drawer for profile menu
      endDrawer: ProfileDrawer(),
      body: Column(
        children: [
          // header section
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back button and title
                  Row(
                    children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasActiveBooking ? currentBooking!.driverName : 'Chats',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (hasActiveBooking && currentBooking!.carModel != null)
                            Text(
                              currentBooking.carModel!,
                              style: TextStyle(
                                color: const Color(0xCCFFFFFF),
                                fontSize: 14,
                              ),
                            ),
                        ],
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
            ),
          ),
          
          // chat content area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: hasActiveBooking 
                ? _buildChatView()
                : _buildNoChatView(),
            ),
          ),
          Container(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const BottomNavBar(currentIndex: 3),
          ),
        ],
      ),
    );
  }

  // widget shown when no active booking (no chat available)
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
            'No Active Chats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a ride to start chatting with your driver',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/passenger_listings_view');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF8C00),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Browse Rides',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // widget shown when there's an active booking (chat interface)
  Widget _buildChatView() {
    return Column(
      children: [
        // chat messages area
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
    );
  }

  // helper widget to build individual message bubbles
  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isFromDriver 
          ? MainAxisAlignment.start 
          : MainAxisAlignment.end,
        children: [
          if (message.isFromDriver) ...[
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
            SizedBox(width: 8),
          ],
          // message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromDriver 
                  ? Colors.grey[100] 
                  : Color(0xFFFF8C00),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isFromDriver 
                        ? Colors.black87 
                        : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isFromDriver 
                        ? Colors.grey[600] 
                        : const Color(0xCCFFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!message.isFromDriver) ...[
            SizedBox(width: 8),
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
          isFromDriver: false,
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

// model class for chat messages
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