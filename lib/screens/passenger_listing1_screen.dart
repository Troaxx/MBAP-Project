import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';
import '../models/listing.dart';
import '../services/booking_service.dart';

/// Passenger listing 1 screen - displays details for a specific carpool listing.
/// 
/// This screen provides:
/// - Listing details (driver, route, cost, etc.)
/// - Booking and chat options
class PassengerListing1Screen extends StatefulWidget {
  final Listing listing;
  
  const PassengerListing1Screen({Key? key, required this.listing}) : super(key: key);

  @override
  State<PassengerListing1Screen> createState() => _PassengerViewListingState();
}

class _PassengerViewListingState extends State<PassengerListing1Screen> {
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
                                          children: [
                                            Text(
                                              widget.listing.driverName,
                                              style: const TextStyle(
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
                                        Text(
                                          widget.listing.pickupPoint,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pickup location',
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
                                    children: [
                                      const Text(
                                        'LEAVE AT:',
                                        style: TextStyle(
                                          color: Color(0xFFFF8C00),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${widget.listing.departureTime.hour.toString().padLeft(2, '0')}:${widget.listing.departureTime.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
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
                                        Text(
                                          widget.listing.destination,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Destination',
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
                                    '• Check driver profile for specific preferences',
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
                                                '10.5 km',
                                              ),
                                              _buildStatItem(
                                                'Est. Duration',
                                                '25 min',
                                              ),
                                              _buildStatItem('Cost', 'S\$${widget.listing.cost.toStringAsFixed(2)}'),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          LinearProgressIndicator(
                                            value: (widget.listing.seats - widget.listing.availableSeats) / widget.listing.seats,
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                                const AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFFF8C00),
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${widget.listing.seats - widget.listing.availableSeats} seats out of ${widget.listing.seats} filled',
                                            style: const TextStyle(
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
                                      'Great driver, very punctual!',
                                      'John D.',
                                      '2 days ago',
                                    ),
                                    const Divider(),
                                    _buildReviewItem(
                                      'Nice car and smooth ride.',
                                      'Sarah L.',
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver: ${widget.listing.driverName}'),
              Text('Route: ${widget.listing.pickupPoint} → ${widget.listing.destination}'),
              Text('Cost: S\$${widget.listing.cost.toStringAsFixed(2)}'),
              Text('Departure: ${widget.listing.departureTime.hour.toString().padLeft(2, '0')}:${widget.listing.departureTime.minute.toString().padLeft(2, '0')}'),
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
    // Book the ride using booking service
    _bookingService.bookRide(widget.listing);
    
    // show booking success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride booked successfully with ${widget.listing.driverName}!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // navigate to ride tracking page
    Navigator.pushNamed(context, '/passenger_ride');
  }
}
