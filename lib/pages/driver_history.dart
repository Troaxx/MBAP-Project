import 'package:flutter/material.dart';
import '../widgets/driver_bottom_nav_bar.dart';
import '../widgets/driver_profile_drawer.dart';

// driver history page - displays earnings summary and ride/payment history
// shows completed rides, earnings, and transaction history for drivers
class DriverHistoryPage extends StatelessWidget {
  const DriverHistoryPage();

  @override
  Widget build(BuildContext context) {
    // key to control drawer opening from profile icon
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00), // orange background theme
      // side drawer for profile menu
      endDrawer: DriverProfileDrawer(),
      body: Column(
        children: [
          // main content area with history data
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
                              'Your driving history',
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
                    
                    // earnings summary card - displays total earnings and ride count
                    Container(
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
                          // earnings icon with light green background
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0x1A4CAF50),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // earnings details and statistics
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Earnings',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                // main earnings amount in green
                                const Text(
                                  'S\$127.50',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                // additional statistics
                                Text(
                                  'From 15 completed rides',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // scrollable history list with rides and payments
                    Expanded(
                      child: ListView(
                        children: [
                          // recent rides section header
                          const Text(
                            'Recent Rides',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // individual ride cards showing trip details and earnings
                          _buildDriverRideCard(
                            context,
                            passengerName: 'Marie Tan',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 15, 2024',
                            time: '8:00 AM',
                            earnings: 'S\$11.00',
                            passengers: 2,
                          ),
                          const SizedBox(height: 12),
                          _buildDriverRideCard(
                            context,
                            passengerName: 'John Lim',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 14, 2024',
                            time: '7:45 AM',
                            earnings: 'S\$12.00',
                            passengers: 2,
                          ),
                          const SizedBox(height: 12),
                          _buildDriverRideCard(
                            context,
                            passengerName: 'Sarah Wong',
                            route: 'Jurong East → NTU',
                            date: 'Oct 13, 2024',
                            time: '7:30 AM',
                            earnings: 'S\$21.60',
                            passengers: 3,
                          ),
                          const SizedBox(height: 20),
                          
                          // payment history section header
                          const Text(
                            'Payment History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // individual payment cards showing transaction details
                          _buildDriverPaymentCard(
                            context,
                            paymentId: 'DRV-3451',
                            description: 'Ride earnings payout',
                            route: 'Tampines Hub → Temasek Polytechnic',
                            date: 'Oct 15, 2024',
                            amount: 'S\$11.00',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 12),
                          _buildDriverPaymentCard(
                            context,
                            paymentId: 'DRV-3420',
                            description: 'Ride earnings payout',
                            route: 'Bedok Mall → Singapore Polytechnic',
                            date: 'Oct 14, 2024',
                            amount: 'S\$12.00',
                            status: 'Completed',
                          ),
                          const SizedBox(height: 12),
                          _buildDriverPaymentCard(
                            context,
                            paymentId: 'DRV-3398',
                            description: 'Ride earnings payout',
                            route: 'Jurong East → NTU',
                            date: 'Oct 13, 2024',
                            amount: 'S\$21.60',
                            status: 'Completed',
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
            child: const DriverBottomNavBar(currentIndex: 4), // highlight history tab
          ),
        ],
      ),
    );
  }

  // helper widget to create ride history cards
  // displays individual completed ride details with passenger info and earnings
  Widget _buildDriverRideCard(
    BuildContext context, {
    required String passengerName,
    required String route,
    required String date,
    required String time,
    required String earnings,
    required int passengers,
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
          // ride icon with orange background
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFFF8C00),
            child: Icon(
              Icons.drive_eta,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // ride details - passenger and route information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passenger: $passengerName',
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
          // earnings and passenger count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                earnings,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$passengers passenger${passengers > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // helper widget to create payment history cards
  // displays individual payment transaction details with status
  Widget _buildDriverPaymentCard(
    BuildContext context, {
    required String paymentId,
    required String description,
    required String route,
    required String date,
    required String amount,
    required String status,
  }) {
    // determine status color based on payment status
    Color statusColor = status == 'Completed' ? Colors.green : Colors.orange;
    
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
            backgroundColor: const Color(0x1A4CAF50),
            child: const Icon(
              Icons.payment,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // payment details - transaction info and route
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentId,
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
          // payment amount and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x1A4CAF50),
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