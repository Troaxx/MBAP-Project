import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';

/// Passenger ride history screen - displays past rides for the passenger.
/// 
/// This screen provides:
/// - List of completed and cancelled rides
/// - Details for each ride
/// - Navigation to ride details or rebook
class PassengerRideHistoryScreen extends StatelessWidget {
  const PassengerRideHistoryScreen();

  @override
  Widget build(BuildContext context) {
    // key to control drawer opening from profile icon
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00), // orange background theme
      // side drawer for profile menu
      endDrawer: ProfileDrawer(),
      body: Column(
        children: [
          // main content area with ride history
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header section with back button and profile icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back navigation and page title
                        Row(
                          children: [
                            // back button to return to previous page
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0x33FFFFFF), // modern white background with 20% opacity
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // page title
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
                    
                    // scrollable list of ride history cards
                    Expanded(
                      child: ListView(
                        children: [
                          // individual ride cards showing trip details
                          _buildRideHistoryCard(
                            driverName: 'John Tan',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 15, 2024',
                            time: '8:00 AM',
                            cost: 'S\$5.50',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            driverName: 'Sarah Lim',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 14, 2024',
                            time: '7:45 AM',
                            cost: 'S\$6.00',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            driverName: 'Michael Wong',
                            route: 'Jurong East → NTU',
                            date: 'Oct 13, 2024',
                            time: '7:30 AM',
                            cost: 'S\$7.20',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 16),
                          _buildRideHistoryCard(
                            driverName: 'Linda Chen',
                            route: 'Woodlands → Republic Polytechnic',
                            date: 'Oct 12, 2024',
                            time: '8:15 AM',
                            cost: 'S\$8.50',
                            status: 'Cancelled',
                          ),
                        ],
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
            child: const BottomNavBar(currentIndex: 2), // highlight ride tab
          ),
        ],
      ),
    );
  }

  // helper widget to create ride history cards
  // displays individual trip details with driver info, route, and payment status
  Widget _buildRideHistoryCard({
    required String driverName,
    required String route,
    required String date,
    required String time,
    required String cost,
    required String status,
  }) {
    // determine status color based on ride completion
    Color statusColor = status == 'Completed' ? Colors.green : Colors.red;
    
    return GestureDetector(
      onTap: () {
        // future: navigate to detailed ride view
        // could show receipt, route map, driver rating, etc.
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // driver profile section
            Column(
              children: [
                // driver avatar
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFFF8C00),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                // ride status badge with color-coded background
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Completed' 
                      ? const Color(0x1A4CAF50) // modern green background
                      : const Color(0x1AF44336), // modern red background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // trip details section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // driver name
                  Text(
                    'Driver: $driverName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // route with arrow indicator
                  Text(
                    route,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // date and time information
                  Text(
                    '$date • $time',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // cost display
            Text(
              cost,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8C00),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 