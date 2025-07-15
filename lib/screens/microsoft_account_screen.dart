import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Simple Microsoft Account screen
/// 
/// This screen:
/// - Shows Microsoft account information
/// - Allows users to sign in with Microsoft
/// - Shows account details and status
/// - Routes to profile setup or home based on user status
class MicrosoftAccountScreen extends StatefulWidget {
  const MicrosoftAccountScreen();

  @override
  State<MicrosoftAccountScreen> createState() => _MicrosoftAccountScreenState();
}

class _MicrosoftAccountScreenState extends State<MicrosoftAccountScreen> {
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    setState(() {
      _currentUser = GetIt.I<FirebaseService>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8C00),
      appBar: AppBar(
        title: const Text(
          'Microsoft Account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF8C00),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              
              // Microsoft Logo Area
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.business,
                    size: 60,
                    color: Color(0xFFFF8C00),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Microsoft Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Account Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_currentUser != null) ...[
                      const Text(
                        'Currently signed in as:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentUser!.displayName ?? _currentUser!.email ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      const Text(
                        'Not signed in with Microsoft',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Sign In Button
              if (_currentUser == null) ...[
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithMicrosoft,
                  icon: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
                          ),
                        )
                      : const Icon(Icons.business),
                  label: Text(
                    _isLoading ? 'Signing in...' : 'Sign in with Microsoft',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF8C00),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else ...[
                // Continue Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _continueToApp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFF8C00),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue to App',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sign Out Button
                TextButton(
                  onPressed: _isLoading ? null : _signOut,
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Info Text
              const Text(
                'Microsoft accounts allow you to sign in with your work, school, or personal Microsoft account.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Back Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign in with Microsoft with automatic migration
  void _signInWithMicrosoft() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await GetIt.I<FirebaseService>().signInWithMicrosoft(context);

      if (result != null) {
        // Migrate existing user data if needed
        final needsSetup = await GetIt.I<FirebaseService>().migrateExistingUser();
        
        setState(() {
          _currentUser = result.user;
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microsoft Sign-In successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        if (needsSetup) {
          // Migration indicates user needs to complete profile setup
          Navigator.pushReplacementNamed(context, '/profile_setup');
        } else {
          // Check if user has completed profile setup (for non-migrated users)
          final hasCompletedSetup = await GetIt.I<FirebaseService>().hasCompletedProfileSetup();
          
          if (hasCompletedSetup) {
            // User has completed setup, navigate to their home screen
            final homeRoute = await GetIt.I<FirebaseService>().getHomeScreenRoute();
            Navigator.pushReplacementNamed(context, homeRoute);
          } else {
            // User needs to complete profile setup
            Navigator.pushReplacementNamed(context, '/profile_setup');
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microsoft Sign-In failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Microsoft Sign-In error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Continue to app with automatic migration
  void _continueToApp() async {
    if (_currentUser == null) {
      Navigator.pushReplacementNamed(context, '/profile_setup');
      return;
    }
    
    // Migrate existing user data if needed
    final needsSetup = await GetIt.I<FirebaseService>().migrateExistingUser();
    
    if (needsSetup) {
      // Migration indicates user needs to complete profile setup
      Navigator.pushReplacementNamed(context, '/profile_setup');
    } else {
      // Check if user has completed profile setup (for non-migrated users)
      final hasCompletedSetup = await GetIt.I<FirebaseService>().hasCompletedProfileSetup();
      
      if (hasCompletedSetup) {
        // User has completed setup, navigate to their home screen
        final homeRoute = await GetIt.I<FirebaseService>().getHomeScreenRoute();
        Navigator.pushReplacementNamed(context, homeRoute);
      } else {
        // User needs to complete profile setup
        Navigator.pushReplacementNamed(context, '/profile_setup');
      }
    }
  }

  // Sign out
  void _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await GetIt.I<FirebaseService>().logOut();
      setState(() {
        _currentUser = null;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 