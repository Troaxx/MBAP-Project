import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/passenger_home.dart';
import 'pages/passenger_view_listing.dart';

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
      },
    );
  }
}