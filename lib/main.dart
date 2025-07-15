import 'package:carpool_sg/firebase_options.dart';
import 'package:carpool_sg/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for VerifyEmailScreen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login_screen.dart';
import 'screens/passenger_home_screen.dart';
import 'screens/passenger_listing1_screen.dart';
import 'screens/passenger_listing2_screen.dart';
import 'screens/passenger_listing3_screen.dart';
import 'screens/passenger_listings_view_screen.dart';
import 'screens/passenger_ride_history_screen.dart';
import 'screens/passenger_activity_screen.dart';
import 'screens/passenger_ride_screen.dart';
import 'screens/passenger_chats_screen.dart';
import 'screens/driver_create_listing_screen.dart';
import 'screens/driver_listings_view_screen.dart';
import 'screens/driver_home_screen.dart';
import 'screens/driver_history_screen.dart';
import 'screens/driver_chats_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/account_settings_screen.dart';
import 'screens/microsoft_account_screen.dart';
import 'models/listing.dart';

/// AuthWrapper widget that checks for email verification on app startup
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen();

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    setState(() { _isLoading = true; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() { _emailSent = true; });
      }
    } catch (e) {
      debugPrint('Failed to send verification email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification email: ${e.toString()}')),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _checkVerification() async {
    setState(() { _isLoading = true; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        // Check if user has completed profile setup
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists && doc.data()?['name'] != null) {
          // User has completed profile setup, go to appropriate home screen
          if (doc.data()?['role'] == 'driver') {
            Navigator.of(context).pushReplacementNamed('/driver_home');
          } else {
            Navigator.of(context).pushReplacementNamed('/passenger_home');
          }
        } else {
          // User hasn't completed profile setup yet, go to profile setup
          Navigator.of(context).pushReplacementNamed('/profile_setup');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet. Please check your inbox.')),
        );
      }
    } catch (e) {
      debugPrint('Failed to check verification: $e');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 64, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'A verification email has been sent to:\n${user?.email ?? ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              if (_emailSent)
                const Text('Please check your inbox and click the verification link.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _checkVerification,
                child: _isLoading ? const CircularProgressIndicator() : const Text('I have verified my email'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendVerificationEmail,
                child: const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _logOut,
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// AuthWrapper widget that checks for email verification on app startup
class AuthWrapper extends StatefulWidget {
  const AuthWrapper();

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    try {
      await GetIt.instance<FirebaseService>().checkEmailVerification();
    } catch (e) {
      debugPrint('Error checking email verification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (!user.emailVerified && user.providerData.any((p) => p.providerId == 'password')) {
        // Only require verification for email/password users
        return const VerifyEmailScreen();
      } else if (user.emailVerified) {
        // User is verified, check if they have completed profile setup
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              if (userData != null && userData['name'] != null) {
                // User has completed profile setup, go to appropriate home screen
                if (userData['role'] == 'driver') {
                  return const DriverHomeScreen();
                } else {
                  return const PassengerHomeScreen();
                }
              }
            }
            
            // User hasn't completed profile setup, go to profile setup
            return const ProfileSetupScreen();
          },
        );
      }
    }
    return const LoginScreen();
  }
}

/// Main entry point for the CarpoolSG Flutter application.
/// 
/// This function:
/// - Initializes Flutter bindings
/// - Sets up Firebase configuration
/// - Launches the main app widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetIt.instance.registerLazySingleton(() => FirebaseService());
  runApp(const MyApp());
}

/// Root application widget that configures the MaterialApp with routing.
/// 
/// This widget manages:
/// - Global theme settings with orange branding
/// - Navigation routes for all screens
/// - Initial screen (login) when app launches
/// - Debug banner configuration
class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides debug banner in debug mode
      title: 'CarpoolSG', // App title shown in task switcher
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8C00)),
        useMaterial3: true, // Enables latest Material Design 3
        fontFamily: 'Inter', // Custom font for consistent typography
      ),
      
      home: const AuthWrapper(), // Initial page when app launches
      
      // Named route definitions for navigation throughout the app
      routes: {
        // Authentication routes
        '/login': (context) => const LoginScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),  
        '/register': (context) => const RegisterScreen(),
        '/microsoft_account': (context) => const MicrosoftAccountScreen(),
        '/profile_setup': (context) => const ProfileSetupScreen(),
        '/account_settings': (context) => const AccountSettingsScreen(),

        // Passenger routes - main passenger functionality
        '/passenger_home': (context) => const PassengerHomeScreen(),
        '/passenger_listings': (context) => const PassengerListingsViewScreen(),
        '/passenger_listings_view': (context) => const PassengerListingsViewScreen(),
        '/passenger_ride': (context) => const PassengerRideScreen(),
        '/passenger_chats': (context) => const PassengerChatsScreen(),
        '/passenger_ride_history': (context) => const PassengerRideHistoryScreen(),
        '/passenger_activity': (context) => const PassengerActivityScreen(),

        // Driver routes - main driver functionality
        '/driver_home': (context) => const DriverHomeScreen(),
        '/driver_create_listing': (context) => DriverCreateListingScreen(),
        '/driver_listings': (context) => const DriverListingsViewScreen(),
        '/driver_chats': (context) => const DriverChatsScreen(),
        '/driver_history': (context) => const DriverHistoryScreen(),
      },
    );
  }
}
