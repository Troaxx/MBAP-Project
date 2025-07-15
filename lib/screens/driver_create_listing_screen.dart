import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/driver_bottom_nav_bar.dart';
import '../widgets/driver_profile_drawer.dart';
import '../models/listing.dart';
import '../services/listing_service.dart';

// main page for drivers to create new carpool listings
// uses stateful widget to manage form data and user interactions
/// Driver create listing screen - form for creating new carpool listings.
/// 
/// This screen provides:
/// - Form for entering ride details (pickup, destination, cost, etc.)
/// - Validation for required fields
/// - Date and time picker for departure
/// - Navigation back to listings view
class DriverCreateListingScreen extends StatefulWidget {
  const DriverCreateListingScreen();

  @override
  State<DriverCreateListingScreen> createState() => _DriverCreateListingScreenState();
}

class _DriverCreateListingScreenState extends State<DriverCreateListingScreen> {
  // form key to validate all form fields at once
  var form = GlobalKey<FormState>();

  // variables to store user input data from the form
  String? pickupPoint;    // stores the pickup location
  String? destination;    // stores the destination location
  double? cost;           // stores the ride cost in SGD
  String? carModel;       // stores the car model (e.g., Toyota Camry)
  String? licensePlate;   // stores the vehicle license plate number
  int? availableSeats;    // stores number of available seats for booking
  DateTime? leavingTime; // stores combined date and time for departure
  DateTime? arrivingTime; // future use for arrival time
  bool isAvailable = true; // tracks if listing is active
  String? vehicleType;    // future use for vehicle information
  
  // controller to display selected date/time in the text field
  final TextEditingController _leavingTimeController = TextEditingController();

  // shows date picker and updates leaving time with selected date
  // only allows future dates to prevent past bookings
  Future<void> presentDatePicker(BuildContext context) async {
    DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),        // start with today's date
      firstDate: DateTime.now(),          // prevent selecting past dates
      lastDate: DateTime.now().add(Duration(days: 365)), // limit to 1 year ahead
    );
    if (value != null) {
      setState(() {
        leavingTime = value; // store selected date
        // display only date initially (time will be added after time picker)
        _leavingTimeController.text = DateFormat('dd/MM/yyyy').format(value);
      });
    }
  }

  // shows time picker and combines with previously selected date
  // only runs if date was already selected
  Future<void> presentTimePicker(BuildContext context) async {
    TimeOfDay? value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // start with current time
    );
    // combine date and time into single datetime object
    if (value != null && leavingTime != null) {
      setState(() {
        leavingTime = DateTime(
          leavingTime!.year,   // keep selected date
          leavingTime!.month,  // keep selected month
          leavingTime!.day,    // keep selected day
          value.hour,          // add selected hour
          value.minute,        // add selected minute
        );
        // update display to show both date and time
        _leavingTimeController.text = DateFormat('dd/MM/yyyy HH:mm').format(leavingTime!);
      });
    }
  }

  // displays confirmation dialog before creating the listing
  // validates form and shows all entered details for review
  void _showConfirmationDialog() {
    // check if all form fields are valid before proceeding
    if (!form.currentState!.validate()) {
      return; // stop if validation fails
    }
    
    // save all form field values to state variables
    form.currentState!.save();
    
    // show dialog with listing details for user confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Listing Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF8C00), // orange theme color
            ),
          ),
          // scrollable content in case details are long
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please review your listing details:'),
                SizedBox(height: 16),
                // display each form field with its value
                _buildDetailRow('Pickup Point:', pickupPoint ?? ''),
                _buildDetailRow('Destination:', destination ?? ''),
                _buildDetailRow('Cost:', 'S\$${cost?.toStringAsFixed(2) ?? '0.00'}'),
                _buildDetailRow('Car Model:', carModel ?? ''),
                _buildDetailRow('License Plate:', licensePlate ?? ''),
                _buildDetailRow('Available Seats:', availableSeats?.toString() ?? ''),
                _buildDetailRow('Departure Time:', 
                  leavingTime != null 
                    ? DateFormat('dd/MM/yyyy HH:mm').format(leavingTime!)
                    : 'Not set'),
              ],
            ),
          ),
          actions: [
            // cancel button to close dialog without saving
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            // confirm button to create the listing
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog first
                _submitListing(); // then create the listing
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF8C00), // orange theme
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm & Create Listing'),
            ),
          ],
        );
      },
    );
  }

  // helper widget to create consistent detail rows in confirmation dialog
  // shows label and value in organized format
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // fixed width for labels to align values consistently
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
          // flexible width for values that might be long
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

  // creates new listing object and saves it to the service
  // also shows success notification and resets form
  void _submitListing() {
    final ListingService listingService = ListingService();
    
    // create new listing with form data and generated id
    final newListing = Listing(
      id: listingService.generateId(), // unique timestamp-based id
      driverName: 'David Tan',         // hardcoded for demo (should be from auth)
      pickupPoint: pickupPoint!,
      destination: destination!,
      cost: cost!,
      seats: availableSeats!,          // total seats in the car
      departureTime: leavingTime!,
      availableSeats: availableSeats!, // initially all seats are available
      carModel: carModel,              // vehicle make and model
      licensePlate: licensePlate,      // vehicle license plate
    );
    
    // save listing to in-memory service
    listingService.addListing(newListing);
    
    // show success message with action to view listings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Listing created successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View My Listings',
          textColor: Colors.white,
          onPressed: () {
            // navigate to driver's listings page
            Navigator.pushNamed(context, '/driver_listings');
          },
        ),
      ),
    );
    
    // clear form after successful submission
    form.currentState!.reset();
    _leavingTimeController.clear();
    setState(() {
      leavingTime = null; // clear datetime selection
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
      endDrawer: DriverProfileDrawer(),
      body: Column(
        children: [
          // main content area with form
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: form, // attach form key for validation
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header section with title and profile icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // app title and page description
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
                      
                      // form container with white background
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // scrollable form fields area
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // pickup point input field
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Pickup Point',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.location_on),
                                        ),
                                        validator: (value) {
                                          // ensure pickup point is not empty
                                          if (value == null || value.isEmpty) {
                                            return 'Pickup Point is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          pickupPoint = value; // save to state
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // destination input field
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Destination',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.flag),
                                        ),
                                        validator: (value) {
                                          // ensure destination is not empty
                                          if (value == null || value.isEmpty) {
                                            return 'Destination is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          destination = value; // save to state
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // cost input field with number keyboard
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
                                          // validate that input is a positive number
                                          final parsed = double.tryParse(value);
                                          if (parsed == null || parsed <= 0) {
                                            return 'Invalid cost.\nThe value should be a positive number.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          cost = double.tryParse(value!); // convert to double
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // car model input field
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Car Model',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.directions_car),
                                          hintText: 'e.g., Toyota Camry, Honda Civic',
                                        ),
                                        validator: (value) {
                                          // ensure car model is not empty
                                          if (value == null || value.isEmpty) {
                                            return 'Car Model is required';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          carModel = value; // save to state
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // license plate input field
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'License Plate',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.confirmation_number),
                                          hintText: 'e.g., SBA1234X',
                                        ),
                                        validator: (value) {
                                          // ensure license plate is not empty
                                          if (value == null || value.isEmpty) {
                                            return 'License Plate is required';
                                          }
                                          // basic validation for Singapore license plate format
                                          if (value.length < 7 || value.length > 8) {
                                            return 'Invalid format.\nShould be 7-8 characters (e.g., SBA1234X)';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          licensePlate = value?.toUpperCase(); // save in uppercase
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // available seats input field
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Available Seats',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.people),
                                          hintText: 'e.g., 4',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Available Seats is required';
                                          }
                                          // validate that input is a positive whole number
                                          final parsed = int.tryParse(value);
                                          if (parsed == null || parsed <= 0) {
                                            return 'Invalid seats.\nThe value should be a whole positive number.';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          availableSeats = int.tryParse(value!); // convert to integer
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // date and time picker field (read-only)
                                      TextFormField(
                                        controller: _leavingTimeController,
                                        readOnly: true, // prevent manual typing
                                        decoration: InputDecoration(
                                          labelText: 'Leaving Date & Time',
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.schedule),
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        onTap: () async {
                                          // first show date picker
                                          await presentDatePicker(context);
                                          // then show time picker only if date was selected
                                          // check mounted to prevent using context after widget disposal
                                          if (leavingTime != null && mounted) {
                                            await presentTimePicker(context);
                                          }
                                        },
                                        validator: (value) {
                                          // ensure both date and time are selected
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
                              // submit button at bottom of form
                              SizedBox(
                                width: double.infinity, // full width button
                                child: ElevatedButton(
                                  onPressed: _showConfirmationDialog, // show confirmation before submit
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFF8C00), // orange theme
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
            child: const DriverBottomNavBar(currentIndex: 2), // highlight create listing tab
          ),
        ],
      ),
    );
  }
}
