import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Login screen widget that provides authentication interface for CarpoolSG app.
///
/// This screen displays:
/// - Social login options (Google, Facebook) - currently disabled
/// - Email/password login form
/// - Navigation to forgot password and registration screens
/// - App branding with orange theme
class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Navigates to the passenger home screen after successful login
  void _navigateToPassengerHome(BuildContext context) {
    Navigator.pushNamed(context, '/passenger_home');
  }

  /// Navigates to the forgot password screen
  void _navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot_password');
  }

  /// Navigates to the registration screen for new users
  void _navigateToRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  String? email;
  String? password;
  var form = GlobalKey<FormState>();

  // Simple login method with automatic migration
  void login(context) async {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      try {
        await GetIt.I<FirebaseService>().login(email, password);
        
        // Migrate existing user data if needed
        final needsSetup = await GetIt.I<FirebaseService>().migrateExistingUser();
        
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User logged in successfully!')),
        );
        
        if (needsSetup) {
          // Migration indicates user needs to complete profile setup
          Navigator.of(context).pushReplacementNamed('/profile_setup');
        } else {
          // Check if user has completed profile setup (for non-migrated users)
          final hasCompletedSetup = await GetIt.I<FirebaseService>().hasCompletedProfileSetup();
          
          if (hasCompletedSetup) {
            // User has completed setup, navigate to their home screen
            final homeRoute = await GetIt.I<FirebaseService>().getHomeScreenRoute();
            Navigator.of(context).pushReplacementNamed(homeRoute);
          } else {
            // User needs to complete profile setup
            Navigator.of(context).pushReplacementNamed('/profile_setup');
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = e.code;
        if (e.code == 'email-change-pending') {
          errorMessage = 'Please verify your new email address before logging in. Check your email for verification link.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  // Google sign-in method with automatic migration
  void signInWithGoogle(context) async {
    try {
      final result = await GetIt.I<FirebaseService>().signInWithGoogle();
      if (result != null) {
        // Check if result is an error response
        if (result is Map<String, dynamic> && result['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Login failed')),
          );
          return;
        }
        
        // Migrate existing user data if needed
        final needsSetup = await GetIt.I<FirebaseService>().migrateExistingUser();
        
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In successful!')),
        );
        
        if (needsSetup) {
          // Migration indicates user needs to complete profile setup
          Navigator.of(context).pushReplacementNamed('/profile_setup');
        } else {
          // Check if user has completed profile setup (for non-migrated users)
          final hasCompletedSetup = await GetIt.I<FirebaseService>().hasCompletedProfileSetup();
          
          if (hasCompletedSetup) {
            // User has completed setup, navigate to their home screen
            final homeRoute = await GetIt.I<FirebaseService>().getHomeScreenRoute();
            Navigator.of(context).pushReplacementNamed(homeRoute);
          } else {
            // User needs to complete profile setup
            Navigator.of(context).pushReplacementNamed('/profile_setup');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed. Please try again.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      if (e.code == 'email-change-pending') {
        errorMessage = 'Please verify your new email address before logging in. Check your email for verification link.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In error: ${e.toString()}')),
      );
    }
  }

  // Real Microsoft sign-in method
  void signInWithMicrosoft(context) async {
    try {
      final result = await GetIt.I<FirebaseService>().signInWithMicrosoft(context);
      if (result != null) {
        // Check if result is an error response
        if (result is Map<String, dynamic> && result['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Login failed')),
          );
          return;
        }
        
        // Migrate existing user data if needed
        final needsSetup = await GetIt.I<FirebaseService>().migrateExistingUser();
        
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microsoft Sign-In successful!')),
        );
        
        if (needsSetup) {
          // Migration indicates user needs to complete profile setup
          Navigator.of(context).pushReplacementNamed('/profile_setup');
        } else {
          // Check if user has completed profile setup (for non-migrated users)
          final hasCompletedSetup = await GetIt.I<FirebaseService>().hasCompletedProfileSetup();
          
          if (hasCompletedSetup) {
            // User has completed setup, navigate to their home screen
            final homeRoute = await GetIt.I<FirebaseService>().getHomeScreenRoute();
            Navigator.of(context).pushReplacementNamed(homeRoute);
          } else {
            // User needs to complete profile setup
            Navigator.of(context).pushReplacementNamed('/profile_setup');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microsoft Sign-In failed. Please try again.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      if (e.code == 'email-change-pending') {
        errorMessage = 'Please verify your new email address before logging in. Check your email for verification link.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microsoft Sign-In error: ${e.toString()}')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF8C00),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Log in to CarpoolSG',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => signInWithGoogle(context),
                          icon: Image.asset(
                            'images/google_logo.png',
                            height: 24,
                            width: 24,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFFD9D9D9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => signInWithMicrosoft(context),
                          icon: const Icon(Icons.business, color: Colors.black),
                          label: const Text(
                            'Continue with Microsoft',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFFD9D9D9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 1),
                        const SizedBox(height: 16),
                        const Text(
                          'Log in with Email',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSaved: (value) => email = value,
                          validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFD9D9D9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          obscureText: true,
                          onSaved: (value) => password = value,
                          validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () => _navigateToForgotPassword(context),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New to CarpoolSG?',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 2),
                            TextButton(
                              onPressed: () => _navigateToRegisterPage(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign up here',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Color(0xFFFF8C00),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => login(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFFFF8C00),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
