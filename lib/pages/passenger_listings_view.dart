import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/passenger_profile_drawer.dart';
import '../models/listing.dart';
import '../services/listing_service.dart';
import '../services/booking_service.dart';

// passenger listings view page - displays available carpool rides
// shows list of available rides that passengers can book
class PassengerListingsViewPage extends StatefulWidget {
  const PassengerListingsViewPage();

  @override
  State<PassengerListingsViewPage> createState() => _PassengerListingsViewPageState();
}

class _PassengerListingsViewPageState extends State<PassengerListingsViewPage> {
  // service instance to fetch ride listings
  final ListingService _listingService = ListingService();
  
  // booking service to manage ride bookings
  final BookingService _bookingService = BookingService();
  
  // list to store available ride listings
  List<Listing> _listings = [];
  
  // loading state to show progress indicator
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadListings(); // fetch listings when page loads
  }

  // fetches available ride listings from the service
  void _loadListings() {
    setState(() {
      _isLoading = true;
    });
    
    // simulate network delay for realistic loading experience
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _listings = _listingService.getAllListings();
        _isLoading = false;
      });
    });
  }

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
          // main content area with listings
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
                              'Available rides',
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
                    
                    // content area - either loading indicator or listings
                    Expanded(
                      child: _isLoading 
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : _listings.isEmpty
                          ? const Center(
                              child: Text(
                                'No rides available at the moment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          // scrollable list of available ride listings
                          : ListView.builder(
                              itemCount: _listings.length,
                              itemBuilder: (context, index) {
                                final listing = _listings[index];
                                return _buildListingCard(context, listing);
                              },
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
            child: const BottomNavBar(currentIndex: 1), // highlight listings tab
          ),
        ],
      ),
    );
  }

  // helper widget to create individual listing cards
  // displays ride details with driver info, route, cost, and booking option
  Widget _buildListingCard(BuildContext context, Listing listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row with driver info and availability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // driver information section
              Row(
                children: [
                  // driver avatar
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFF8C00),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // driver name and vehicle info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        listing.carModel ?? 'Driver', // show car model if available
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // available seats indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1A4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${listing.availableSeats} seats',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // route information with pickup and destination
          Column(
            children: [
              // pickup point
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
                      listing.pickupPoint,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // destination point
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
                      listing.destination,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // vehicle information if available
          if (listing.carModel != null || listing.licensePlate != null) ...[
            Column(
              children: [
                if (listing.carModel != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          listing.carModel!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                if (listing.carModel != null && listing.licensePlate != null)
                  const SizedBox(height: 4),
                if (listing.licensePlate != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          listing.licensePlate!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // bottom row with departure time, cost, and book button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // departure time and cost information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Departure: ${listing.departureTime.day}/${listing.departureTime.month}/${listing.departureTime.year} ${listing.departureTime.hour.toString().padLeft(2, '0')}:${listing.departureTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S\$${listing.cost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFFF8C00),
                    ),
                  ),
                ],
              ),
              // book ride button
              ElevatedButton(
                onPressed: () => _showBookingDialog(context, listing),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // displays booking confirmation dialog
  // allows passenger to confirm ride booking with selected listing
  void _showBookingDialog(BuildContext context, Listing listing) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver: ${listing.driverName}'),
              if (listing.carModel != null)
                Text('Vehicle: ${listing.carModel}'),
              if (listing.licensePlate != null)
                Text('License Plate: ${listing.licensePlate}'),
              Text('Route: ${listing.pickupPoint} → ${listing.destination}'),
              Text('Cost: S\$${listing.cost.toStringAsFixed(2)}'),
              Text('Departure: ${listing.departureTime.hour.toString().padLeft(2, '0')}:${listing.departureTime.minute.toString().padLeft(2, '0')}'),
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
                _confirmBooking(listing);
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
  // shows success message and updates available seats
  void _confirmBooking(Listing listing) {
    // book the ride using booking service
    _bookingService.bookRide(listing);
    
    // show booking success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride booked successfully with ${listing.driverName}!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Ride',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/passenger_ride');
          },
        ),
      ),
    );
    
    // navigate to ride tracking page
    Navigator.pushNamed(context, '/passenger_ride');
    
    // future: update booking in backend service
    // future: reduce available seats count
    // future: add to passenger's booked rides
  }
} 