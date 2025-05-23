import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';

class PassengerActivity extends StatelessWidget {
  const PassengerActivity();

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
                          'Activity',
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
                    // Activity List
                    Expanded(
                      child: ListView(
                        children: [
                          // Recent Rides Section
                          const Text(
                            'Recent Rides',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildRideActivityCard(
                            context,
                            driverName: 'Michael Wong',
                            route: 'Jurong East MRT → NTU',
                            date: 'Oct 15, 2024',
                            time: '7:30 AM',
                            price: 'S\$7.20',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing3');
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildRideActivityCard(
                            context,
                            driverName: 'Sarah Lim',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 12, 2024',
                            time: '7:45 AM',
                            price: 'S\$6.00',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing2');
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Payment History Section
                          const Text(
                            'Payment History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentActivityCard(
                            context,
                            paymentId: 'PAY-3451',
                            description: 'Payment to Michael Wong',
                            route: 'Jurong East MRT → NTU',
                            date: 'Oct 15, 2024',
                            amount: 'S\$7.20',
                            status: 'Completed',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing3');
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentActivityCard(
                            context,
                            paymentId: 'PAY-3420',
                            description: 'Payment to Sarah Lim',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 12, 2024',
                            amount: 'S\$6.00',
                            status: 'Completed',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing2');
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildPaymentActivityCard(
                            context,
                            paymentId: 'PAY-3398',
                            description: 'Payment to John Tan',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 10, 2024',
                            amount: 'S\$5.50',
                            status: 'Completed',
                            onTap: () {
                              Navigator.pushNamed(context, '/passenger_listing1');
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
            child: const BottomNavBar(currentIndex: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildRideActivityCard(
    BuildContext context, {
    required String driverName,
    required String route,
    required String date,
    required String time,
    required String price,
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
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ride with $driverName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$date at $time',
                    style: TextStyle(
                      color: Colors.grey[500],
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
                    fontSize: 16,
                    color: Color(0xFFFF8C00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to view',
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

  Widget _buildPaymentActivityCard(
    BuildContext context, {
    required String paymentId,
    required String description,
    required String route,
    required String date,
    required String amount,
    required String status,
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const Icon(
                Icons.payment,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: $paymentId',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    route,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFFF8C00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tap to view ride',
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
          ],
        ),
      ),
    );
  }
} 