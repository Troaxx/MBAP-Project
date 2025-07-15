import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Simple profile drawer widget for driver pages
// Shows user info and navigation menu
class DriverProfileDrawer extends StatefulWidget {
  const DriverProfileDrawer();

  @override
  State<DriverProfileDrawer> createState() => _DriverProfileDrawerState();
}

class _DriverProfileDrawerState extends State<DriverProfileDrawer> {
  String userName = 'User';
  String userEmail = 'No email';
  String userPhone = 'No phone';
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Listen to auth state changes to update the UI when user data changes
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void _loadUserData() async {
    // Get current user info from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    
    // Check if user exists and get basic info
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'User';
        userEmail = user.email ?? 'No email';
      });
    }

    // Load phone number from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('user_phone');
    
    setState(() {
      userPhone = phone ?? 'No phone';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header section with user profile
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C00), // Orange theme color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture (smaller circle with person icon)
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFFFF8C00)),
                ),
                const SizedBox(height: 8),
                
                // User name (big and bold)
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                
                // User phone number
                Text(
                  userPhone,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                
                // User email (smaller text)
                Text(
                  userEmail,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Menu items
          
          // Ride History button
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Ride History'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/driver_history');
            },
          ),
          
          // Account Settings button
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Account Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/account_settings');
            },
          ),
          
          const Divider(), // Line separator
          
          // Log Out button
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // Go to login screen and remove all previous screens
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
