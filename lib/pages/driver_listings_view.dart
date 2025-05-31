import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/driver_bottom_nav_bar.dart';
import '../widgets/driver_profile_drawer.dart';
import '../models/listing.dart';
import '../services/listing_service.dart';

class DriverListingsView extends StatefulWidget {
  const DriverListingsView();

  @override
  State<DriverListingsView> createState() => _DriverListingsViewState();
}

class _DriverListingsViewState extends State<DriverListingsView> {
  final ListingService _listingService = ListingService();
  final String currentDriverName = 'David Tan'; // In a real app, this would come from auth

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final driverListings = _listingService.getDriverListings(currentDriverName);
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFF8C00),
      endDrawer: DriverProfileDrawer(
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Listings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage your carpool offerings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                    
                    // Listings
                    Expanded(
                      child: driverListings.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: driverListings.length,
                              itemBuilder: (context, index) {
                                final listing = driverListings[index];
                                return _buildListingCard(context, listing);
                              },
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
            child: const DriverBottomNavBar(currentIndex: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No listings yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first listing to start offering rides!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/driver_create_listing');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Create Listing'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, Listing listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Listing #${listing.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFFF8C00),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editListing(listing),
                    icon: Icon(Icons.edit, color: Colors.blue),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: () => _deleteListing(listing.id),
                    icon: Icon(Icons.delete, color: Colors.red),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Route info
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFFF8C00), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(listing.pickupPoint, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.flag, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(listing.destination, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'S\$${listing.cost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFFF8C00),
                    ),
                  ),
                  Text(
                    '${listing.availableSeats} seats available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(listing.departureTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(listing.departureTime),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editListing(Listing listing) {
    final TextEditingController pickupController = TextEditingController(text: listing.pickupPoint);
    final TextEditingController destinationController = TextEditingController(text: listing.destination);
    final TextEditingController costController = TextEditingController(text: listing.cost.toString());
    final TextEditingController seatsController = TextEditingController(text: listing.availableSeats.toString());
    final TextEditingController departureTimeController = TextEditingController(text: DateFormat('dd/MM/yyyy HH:mm').format(listing.departureTime));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Listing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFFFF8C00),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: pickupController,
                          decoration: InputDecoration(
                            labelText: 'Pickup Point',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: destinationController,
                          decoration: InputDecoration(
                            labelText: 'Destination',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: costController,
                          decoration: InputDecoration(
                            labelText: 'Cost (S\$)',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: seatsController,
                          decoration: InputDecoration(
                            labelText: 'Available Seats',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: departureTimeController,
                          decoration: InputDecoration(
                            labelText: 'Departure Time',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate inputs
                        final double? cost = double.tryParse(costController.text);
                        final int? seats = int.tryParse(seatsController.text);
                        
                        if (pickupController.text.isEmpty || 
                            destinationController.text.isEmpty || 
                            cost == null || 
                            seats == null || 
                            seats <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all fields with valid values'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        
                        // Update the listing using copyWith
                        final updatedListing = listing.copyWith(
                          pickupPoint: pickupController.text,
                          destination: destinationController.text,
                          cost: cost,
                          availableSeats: seats,
                        );
                        
                        _listingService.updateListing(listing.id, updatedListing);
                        Navigator.of(context).pop();
                        setState(() {}); // Refresh the list
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Listing updated successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF8C00),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteListing(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Listing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text('Are you sure you want to delete this listing? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _listingService.deleteListing(id);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Listing deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
} 