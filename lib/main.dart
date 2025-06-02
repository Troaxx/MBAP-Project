import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/passenger_home.dart';
import 'pages/passenger_listing1.dart';
import 'pages/passenger_listing2.dart';
import 'pages/passenger_listing3.dart';
import 'pages/passenger_listings_view.dart';
import 'pages/passenger_ride_history.dart';
import 'pages/passenger_activity.dart';
import 'pages/passenger_ride.dart';
import 'pages/passenger_chats.dart';
import 'pages/driver_create_listing.dart';
import 'pages/driver_listings_view.dart';
import 'pages/driver_home.dart';
import 'pages/driver_history.dart';
import 'pages/driver_chats.dart';
import 'pages/forgot_password.dart';
import 'pages/register_page.dart';
import 'models/listing.dart';

void main() {
  runApp(const MyApp());
}

// root application widget - configures material app with routing
// manages global theme settings and navigation between screens
class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides debug banner in debug mode
      title: 'CarpoolSG', // app title shown in task switcher
      // orange-themed color scheme matching app branding
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8C00)),
        useMaterial3: true, // enables latest material design
      ),
      home: const LoginScreen(), // initial page when app launches
      // named route definitions for navigation throughout the app
      routes: {
        // authentication routes
        '/login': (context) => const LoginScreen(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/register': (context) => const RegisterPage(),
        
        // passenger routes - main passenger functionality
        '/passenger_home': (context) => const PassengerHomePage(),
        '/passenger_listings': (context) => const PassengerListingsViewPage(), // updated class name
        '/passenger_listings_view': (context) => const PassengerListingsViewPage(), // updated class name
        '/passenger_ride': (context) => const PassengerRidePage(), // new dynamic ride page
        '/passenger_chats': (context) => const PassengerChatsPage(), // new chats page
        '/passenger_ride_history': (context) => const PassengerRideHistoryPage(), // updated class name
        '/passenger_activity': (context) => const PassengerActivityPage(), // updated class name
        
        // passenger listing detail routes - specific ride pages
        '/passenger_listing2': (context) => const PassengerListing2(),
        '/passenger_listing3': (context) => const PassengerListing3(),
        
        // driver routes - main driver functionality
        '/driver_home': (context) => const DriverHomePage(),
        '/driver_create_listing': (context) => DriverCreateListing(), // stateful widget for form management
        '/driver_listings': (context) => const DriverListingsView(),
        '/driver_chats': (context) => const DriverChatsPage(), // new driver chats page
        '/driver_history': (context) => const DriverHistoryPage(), // updated class name
      },
    );
  }
}