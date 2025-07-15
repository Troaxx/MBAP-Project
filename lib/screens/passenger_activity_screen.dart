import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';

/// Passenger activity screen - displays recent activity and notifications.
/// 
/// This screen provides:
/// - List of recent actions and ride updates
/// - Navigation to relevant ride or chat
class PassengerActivityScreen extends StatelessWidget {
  const PassengerActivityScreen();

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
          // main content area with activity feed
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
                              'CarpoolSG',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your activity',
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
                    
                    // scrollable activity feed with rides and payments
                    Expanded(
                      child: ListView(
                        children: [
                          // recent activity section header
                          const Text(
                            'Recent Activity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // ride activity cards showing trip details
                          _buildRideActivityCard(
                            context,
                            driverName: 'John Tan',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 15, 2024',
                            time: '8:00 AM',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 12),
                          _buildRideActivityCard(
                            context,
                            driverName: 'Sarah Lim',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 14, 2024',
                            time: '7:45 AM',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 20),
                          
                          // payment activity section header
                          const Text(
                            'Payment Activity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // payment activity cards showing transaction details
                          _buildPaymentActivityCard(
                            context,
                            transactionId: 'TXN-3451',
                            description: 'Ride payment',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 15, 2024',
                            amount: 'S\$5.50',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentActivityCard(
                            context,
                            transactionId: 'TXN-3420',
                            description: 'Ride payment',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 14, 2024',
                            amount: 'S\$6.00',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentActivityCard(
                            context,
                            transactionId: 'TXN-3398',
                            description: 'Ride payment',
                            route: 'Jurong East → NTU',
                            date: 'Oct 13, 2024',
                            amount: 'S\$7.20',
                            status: 'Refunded',
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
            child: const BottomNavBar(currentIndex: 4), // highlight activity tab
          ),
        ],
      ),
    );
  }

  // helper widget to create ride activity cards
  // displays individual ride activities with trip details and status
  Widget _buildRideActivityCard(
    BuildContext context, {
    required String driverName,
    required String route,
    required String date,
    required String time,
    required String status,
  }) {
    return Container(
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
          // activity icon with orange background
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFFF8C00),
            child: Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // activity details - trip information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride with $driverName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  route,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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
          // status badge with color-coded background
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x1A4CAF50), // modern green background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // helper widget to create payment activity cards
  // displays individual payment transactions with amount and status
  Widget _buildPaymentActivityCard(
    BuildContext context, {
    required String transactionId,
    required String description,
    required String route,
    required String date,
    required String amount,
    required String status,
  }) {
    // determine colors based on payment status
    Color statusColor = status == 'Completed' ? Colors.green : Colors.orange;
    Color backgroundColor = status == 'Completed' 
      ? const Color(0x1A4CAF50) // modern green background
      : const Color(0x1AFF9800); // modern orange background
    
    return Container(
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
          // payment icon with status-colored background
          CircleAvatar(
            radius: 20,
            backgroundColor: backgroundColor,
            child: Icon(
              Icons.payment,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // payment details - transaction information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  route,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // amount and status display
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
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
        ],
      ),
    );
  }
} 