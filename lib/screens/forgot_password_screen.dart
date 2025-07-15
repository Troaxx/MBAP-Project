import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';

/// Forgot password screen - password recovery interface.
/// 
/// This screen provides:
/// - Email input for password reset
/// - Navigation back to login screen
/// - Consistent app branding and styling
class ForgotPasswordScreen extends StatelessWidget {
  // Route name for navigation
  static String routeName = '/reset';
  // Get the FirebaseService instance using GetIt
  final FirebaseService fbService = GetIt.instance<FirebaseService>();

  // Constructor (no const because fbService is not const)
  ForgotPasswordScreen();

  @override
  Widget build(BuildContext context) {
    // Key for the form
    final _formKey = GlobalKey<FormState>();
    // Variable to store the email input
    String? email;

    /// Handles the password reset logic
    /// - Validates the form
    /// - Calls FirebaseService.forgotPassword
    /// - Shows SnackBar feedback for success or error
    Future<void> reset(BuildContext context) async {
      bool isValid = _formKey.currentState?.validate() ?? false;
      if (isValid) {
        _formKey.currentState?.save();
        try {
          // Attempt to send password reset email
          await fbService.forgotPassword(email);
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please check your email for to reset your password!')),
          );
        } catch (e) {
          // Show error message if reset fails
          String errorMsg = 'Reset failed. Please try again.';
          if (e.toString().contains('code')) {
            errorMsg = e.toString();
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
        }
      }
    }

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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Instructional text
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: const Text(
                            'Enter the email associated with your account to change your password.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email input field
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Your Email',
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
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => email = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Next button triggers reset logic
                        ElevatedButton(
                          onPressed: () => reset(context),
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
                            'Next',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFFD9D9D9),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Back to Login',
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




