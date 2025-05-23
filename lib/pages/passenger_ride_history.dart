import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';

class PassengerRideHistory extends StatelessWidget {
  const PassengerRideHistory();

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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Ride History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                    // Ride History List
                    Expanded(
                      child: ListView(
                        children: [
                          _buildRideHistoryCard(
                            context,
                            driverName: 'Michael Wong',
                            from: 'Jurong East MRT',
                            to: 'NTU',
                            date: 'Oct 15, 2024',
                            time: '7:30 AM',
                            price: 'S\$7.20',
                            status: 'Completed',
                            statusColor: Colors.green,
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing3');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            context,
                            driverName: 'Sarah Lim',
                            from: 'Bedok Mall',
                            to: 'Singapore Polytechnic',
                            date: 'Oct 12, 2024',
                            time: '7:45 AM',
                            price: 'S\$6.00',
                            status: 'Completed',
                            statusColor: Colors.green,
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing2');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            context,
                            driverName: 'John Tan',
                            from: 'Tampines Hub',
                            to: 'Temasek Polytechnic',
                            date: 'Oct 10, 2024',
                            time: '8:00 AM',
                            price: 'S\$5.50',
                            status: 'Completed',
                            statusColor: Colors.green,
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing1');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            context,
                            driverName: 'David Chen',
                            from: 'Orchard MRT',
                            to: 'NUS',
                            date: 'Oct 8, 2024',
                            time: '8:15 AM',
                            price: 'S\$8.00',
                            status: 'Cancelled',
                            statusColor: Colors.red,
                            onTap: () {
                              // No navigation for cancelled rides
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
            child: const BottomNavBar(currentIndex: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildRideHistoryCard(
    BuildContext context, {
    required String driverName,
    required String from,
    required String to,
    required String date,
    required String time,
    required String price,
    required String status,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: status == 'Completed' ? onTap : null,
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
            // Header with driver and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFFF8C00),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      driverName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 4),
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
            const SizedBox(height: 12),
            // Date, time, and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
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
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFF8C00),
                  ),
                ),
              ],
            ),
            if (status == 'Completed')
              const SizedBox(height: 8),
            if (status == 'Completed')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
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