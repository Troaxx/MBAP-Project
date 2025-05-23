import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/passenger_home.dart';
import 'pages/passenger_listing1.dart';
import 'pages/passenger_listing2.dart';
import 'pages/passenger_listing3.dart';
import 'pages/passenger_listings_view.dart';
import 'pages/passenger_ride_history.dart';
import 'pages/passenger_activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarpoolSG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8C00)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/passenger_home': (context) => const PassengerHomePage(),
        '/passenger_view_listing': (context) => const PassengerViewListing(),
        '/passenger_listings_view': (context) => const PassengerListingsView(),
        '/passenger_listing1': (context) => const PassengerViewListing(),
        '/passenger_listing2': (context) => const PassengerListing2(),
        '/passenger_listing3': (context) => const PassengerListing3(),
        '/passenger_ride_history': (context) => const PassengerRideHistory(),
        '/passenger_activity': (context) => const PassengerActivity(),
      },
    );
  }
}