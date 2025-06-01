import 'package:flutter/material.dart';
import '../pages/driver_home.dart';

// profile drawer widget for passenger pages
// provides navigation menu with ride history, role switching, and logout
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // header section with profile info
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFF8C00), // orange theme
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile avatar
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFFFF8C00),
                  ),
                ),
                const SizedBox(height: 10),
                // passenger name (hardcoded for demo)
                const Text(
                  'Marie Tan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                // phone number (hardcoded for demo)
                const Text(
                  '+65 91234567',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // functional menu items
          
          // unfinished features - commented out for future development
          
          // profile editing feature - not implemented yet
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('My Profile'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // TODO: implement profile editing functionality
          //   },
          // ),
          
          // ride history - links to passenger ride history page
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Ride History'),
            onTap: () {
              Navigator.pop(context); // close drawer first
              Navigator.pushNamed(context, '/passenger_ride_history');
            },
          ),
          
          // settings feature - not implemented yet
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // TODO: implement settings functionality
          //   },
          // ),
          
          // role switching - allows passenger to switch to driver view
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Swap to Driver'),
            onTap: () {
              Navigator.pop(context); // close drawer first
              // navigate to driver home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DriverHomePage()),
              );
            },
          ),
          
          const Divider(), // visual separator
          
          // logout functionality - clears all navigation history
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // navigate to login and remove all previous routes
              // prevents users from navigating back to authenticated screens
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