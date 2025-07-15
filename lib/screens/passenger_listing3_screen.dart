import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';
import '../models/listing.dart';
import '../services/booking_service.dart';

/// Passenger listing 3 screen - displays details for a specific carpool listing.
/// 
/// This screen provides:
/// - Listing details (driver, route, cost, etc.)
/// - Booking and chat options
class PassengerListing3Screen extends StatefulWidget {
  const PassengerListing3Screen();

  @override
  State<PassengerListing3Screen> createState() => _PassengerListing3ScreenState();
}

class _PassengerListing3ScreenState extends State<PassengerListing3Screen> {
  // Track expanded state
  bool _isExpanded = false;
  
  // booking service to manage ride bookings
  final BookingService _bookingService = BookingService();

  // Toggle expansion
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00),
      endDrawer: ProfileDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Back button
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'CarpoolSG',
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
                                child: Icon(Icons.person, size: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Main Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Basic Info Section
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Section
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'mike_wong_2001',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'images/icons/nets-icon.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // From Section
                                  const Text(
                                    'FROM',
                                    style: TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Jurong East MRT\n10 Jurong East Street 12',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '2.5km from you',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Leave At Section
                                  Row(
                                    children: const [
                                      Text(
                                        'LEAVE AT:',
                                        style: TextStyle(
                                          color: Color(0xFFFF8C00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '7:30AM',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // To Section
                                  const Text(
                                    'TO',
                                    style: TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Nanyang Technological University\n50 Nanyang Ave,\nSingapore 639798',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '18.5 km from you',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Remarks Section
                                  const Text(
                                    'REMARKS',
                                    style: TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '• Good music, friendly conversation\n• Split petrol costs fairly',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                            // View More Details Button (Clickable)
                            InkWell(
                              onTap: _toggleExpanded,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey[300]!),
                                    bottom:
                                        _isExpanded
                                            ? BorderSide(
                                              color: Colors.grey[300]!,
                                            )
                                            : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isExpanded
                                          ? "Hide Details"
                                          : "View More Details",
                                      style: const TextStyle(
                                        color: Color(0xFFFF8C00),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      _isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: const Color(0xFFFF8C00),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Additional details section (conditionally visible)
                            if (_isExpanded)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Trip Stats Section
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              _buildStatItem(
                                                'Est. Distance',
                                                '19.8 km',
                                              ),
                                              _buildStatItem(
                                                'Est. Duration',
                                                '35 min',
                                              ),
                                              _buildStatItem('Cost', '\$7.20'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const LinearProgressIndicator(
                                            value: 0.25,
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFFF8C00),
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            '1 seat out of 4 filled',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Route Map Preview (Placeholder)
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Route Map Preview',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Driver Past Reviews
                                    const Text(
                                      'DRIVER REVIEWS',
                                      style: TextStyle(
                                        color: Color(0xFFFF8C00),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildReviewItem(
                                      'Fun ride, great playlist!',
                                      'Emma C.',
                                      '3 days ago',
                                    ),
                                    const Divider(),
                                    _buildReviewItem(
                                      'Smooth drive, fair pricing.',
                                      'Kevin L.',
                                      '1 week ago',
                                    ),
                                  ],
                                ),
                              ),

                            // Action Buttons
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigate to chats page
                                        Navigator.pushNamed(context, '/passenger_chats');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFC5A216,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'MESSAGE',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _showBookingDialog(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'BOOK',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  // Helper method to build stat items
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // Helper method to build review items
  Widget _buildReviewItem(String comment, String reviewer, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reviewer,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment),
        ],
      ),
    );
  }

  // displays booking confirmation dialog
  // allows passenger to confirm ride booking
  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver: mike_wong_2001'),
              Text('Route: Jurong East MRT, 10 Jurong East Street 12 → Nanyang Technological University'),
              Text('Cost: S\$7.20'),
              Text('Departure: 7:30AM'),
            ],
          ),
          actions: [
            // cancel booking button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            // confirm booking button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // processes the ride booking confirmation
  // shows success message and navigates to ride page
  void _confirmBooking() {
    // Create a proper Listing object for booking service
    final listing = Listing(
      id: 'listing_3',
      driverName: 'mike_wong_2001',
      pickupPoint: 'Jurong East MRT, 10 Jurong East Street 12',
      destination: 'Nanyang Technological University, 50 Nanyang Ave, Singapore 639798',
      departureTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)), // 7:30AM approximation
      cost: 7.20,
      seats: 4,
      availableSeats: 3,
      carModel: 'Mazda 3',
      licensePlate: 'SBC9876E',
    );
    
    // Book the ride using booking service
    _bookingService.bookRide(listing);
    
    // show booking success notification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ride booked successfully with mike_wong_2001!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // navigate to ride tracking page
    Navigator.pushNamed(context, '/passenger_ride');
  }
} 