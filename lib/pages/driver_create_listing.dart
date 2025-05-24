import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/driver_bottom_nav_bar.dart';
import '../widgets/driver_profile_drawer.dart';
import '../models/listing.dart';
import '../services/listing_service.dart';

class DriverCreateListing extends StatefulWidget {
  const DriverCreateListing();

  @override
  State<DriverCreateListing> createState() => _DriverCreateListingState();
}

class _DriverCreateListingState extends State<DriverCreateListing> {
  var form = GlobalKey<FormState>();

  String? pickupPoint;
  String? destination;
  double? cost;
  DateTime? leavingTime;
  DateTime? arrivingTime;
  bool isAvailable = true;
  String? vehicleType;

  final TextEditingController _leavingTimeController = TextEditingController();

  Future<void> presentDatePicker(BuildContext context) async {
    DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (value != null) {
      setState(() {
        leavingTime = value;
        _leavingTimeController.text = DateFormat('dd/MM/yyyy').format(value);
      });
    }
  }

  Future<void> presentTimePicker(BuildContext context) async {
    TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (value != null && leavingTime != null) {
      setState(() {
        leavingTime = DateTime(
          leavingTime!.year,
          leavingTime!.month,
          leavingTime!.day,
          value.hour,
          value.minute,
        );
        _leavingTimeController.text = DateFormat('dd/MM/yyyy HH:mm').format(leavingTime!);
      });
    }
  }

  void _showConfirmationDialog() {
    if (!form.currentState!.validate()) {
      return;
    }
    
    form.currentState!.save();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Listing Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF8C00),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please review your listing details:'),
                SizedBox(height: 16),
                _buildDetailRow('Pickup Point:', pickupPoint ?? ''),
                _buildDetailRow('Destination:', destination ?? ''),
                _buildDetailRow('Cost:', 'S\$${cost?.toStringAsFixed(2) ?? '0.00'}'),
                _buildDetailRow('Departure Time:', 
                  leavingTime != null 
                    ? DateFormat('dd/MM/yyyy HH:mm').format(leavingTime!)
                    : 'Not set'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitListing();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8C00),
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm & Create Listing'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitListing() {
    final ListingService listingService = ListingService();
    
    // Create new listing
    final newListing = Listing(
      id: listingService.generateId(),
      driverName: 'David Tan', 
      pickupPoint: pickupPoint!,
      destination: destination!,
      cost: cost!,
      departureTime: leavingTime!,
      availableSeats: 4, 
    );
    
    // Add to service
    listingService.addListing(newListing);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Listing created successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View My Listings',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/driver_listings');
          },
        ),
      ),
    );
    
    // Reset form
    form.currentState!.reset();
    _leavingTimeController.clear();
    setState(() {
      leavingTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

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
                child: Form(
                  key: form,
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
                                'CarpoolSG (Driver)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Create your listing',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
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
                      
                      // Form Fields
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Pickup Point',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.location_on),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Pickup Point is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          pickupPoint = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Destination',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.flag),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Destination is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          destination = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Cost (SGD)',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.attach_money),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Cost is required';
                                          }
                                          final parsed = double.tryParse(value);
                                          if (parsed == null || parsed <= 0) {
                                            return 'Please enter a valid cost. The value should be a number.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          cost = double.tryParse(value!);
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _leavingTimeController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Leaving Date & Time',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.schedule),
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        onTap: () async {
                                          await presentDatePicker(context);
                                          if (leavingTime != null) {
                                            await presentTimePicker(context);
                                          }
                                        },
                                        validator: (value) {
                                          if (leavingTime == null) {
                                            return 'Please select leaving date and time';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _showConfirmationDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFF8C00),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Listing',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
            child: const DriverBottomNavBar(currentIndex: 2),
          ),
        ],
      ),
    );
  }
}
