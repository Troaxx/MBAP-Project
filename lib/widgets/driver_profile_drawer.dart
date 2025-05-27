import 'package:flutter/material.dart';
import '../pages/passenger_home.dart';

class DriverProfileDrawer extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const DriverProfileDrawer({
    this.onProfileTap,
    this.onHistoryTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFFF8C00)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFFFF8C00)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'David Tan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '+65 91325151',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Ride History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/driver_history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('My Wallet'),
            onTap: () {
              Navigator.pop(context);
              if (onHistoryTap != null) {
                onHistoryTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              if (onSettingsTap != null) {
                onSettingsTap!();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Swap to Passenger'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PassengerHomePage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              ); //removes all previous routes, and ensures users can't navigate back to authenticated screens.
            },
          ),
        ],
      ),
    );
  }
}
