import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    required this.currentIndex,
  });

  void _navigateToPassengerHome(BuildContext context) {
    Navigator.pushNamed(context, '/passenger_home');
  }

  void _navigateToPassengerViewListing(BuildContext context) {
    Navigator.pushNamed(context, '/passenger_listings_view');
  }

  void _navigateToPassengerActivity(BuildContext context) {
    Navigator.pushNamed(context, '/passenger_activity');
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
          label: 'Listing',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.directions_car, currentIndex == 2),
          label: 'Ride',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.chat_bubble_outline, currentIndex == 3),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(Icons.article_outlined, currentIndex == 4),
          label: 'Activity',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            _navigateToPassengerHome(context);
            break;
          case 1:
            _navigateToPassengerViewListing(context);
            break;
          case 4:
            _navigateToPassengerActivity(context);
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