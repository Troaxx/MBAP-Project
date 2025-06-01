import 'package:flutter/material.dart';

class DriverBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const DriverBottomNavBar({
    required this.currentIndex,
  });

  void _navigateToDriverHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/driver_home', 
      (route) => false
    );
  }

  void _navigateToDriverListings(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/driver_listings', 
      (route) => false
    );
  }

  void _navigateToDriverCreateListing(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/driver_create_listing', 
      (route) => false
    );
  }

  void _navigateToDriverChats(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/driver_chats', 
      (route) => false
    );
  }

  void _navigateToDriverHistory(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/driver_history', 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF8C00),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.home, currentIndex == 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.list, currentIndex == 1),
          label: 'My Listings',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.add_circle, currentIndex == 2),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.chat_bubble_outline, currentIndex == 3),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.history, currentIndex == 4),
          label: 'History',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            _navigateToDriverHome(context);
            break;
          case 1:
            _navigateToDriverListings(context);
            break;
          case 2:
            _navigateToDriverCreateListing(context);
            break;
          case 3:
            _navigateToDriverChats(context);
            break;
          case 4:
            _navigateToDriverHistory(context);
            break;
        }
      },
    );
  }

  Widget _buildIcon(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF8C00) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey[600],
        size: 20,
      ),
    );
  }
} 