import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';
import '../widgets/search_bar_widget.dart';

class PassengerListingsView extends StatelessWidget {
  const PassengerListingsView();

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00),
      endDrawer: ProfileDrawer(
        onProfileTap: () {
          // Navigate to profile page
        },
        onHistoryTap: () {
          // Navigate to history page
        },
        onSettingsTap: () {
          // Navigate to settings page
        },
        onLogoutTap: () {
          // Handle logout
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Listings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Material(
                            elevation: 4,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF8C00),
                              child: Icon(
                                Icons.person,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    const SearchBarWidget(
                      hintText: 'Search destinations...',
                    ),
                    const SizedBox(height: 20),
                    // Listings
                    Expanded(
                      child: ListView(
                        children: [
                          _buildListingCard(
                            context,
                            driverName: 'John Tan',
                            from: 'Tampines Hub',
                            to: 'Temasek Polytechnic',
                            time: '8:00 AM',
                            price: 'S\$5.50',
                            availableSeats: '2 seats left',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing1');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildListingCard(
                            context,
                            driverName: 'Sarah Lim',
                            from: 'Bedok Mall',
                            to: 'Singapore Polytechnic',
                            time: '7:45 AM',
                            price: 'S\$6.00',
                            availableSeats: '1 seat left',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing2');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildListingCard(
                            context,
                            driverName: 'Michael Wong',
                            from: 'Jurong East',
                            to: 'NTU',
                            time: '7:30 AM',
                            price: 'S\$7.20',
                            availableSeats: '3 seats left',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing3');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar
          Container(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const BottomNavBar(currentIndex: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(
    BuildContext context, {
    required String driverName,
    required String from,
    required String to,
    required String time,
    required String price,
    required String availableSeats,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver info
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFFF8C00),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        availableSeats,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFFF8C00),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Route info
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFFF8C00),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    from,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.flag,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    to,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 