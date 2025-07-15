import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//implementation of microsoft auth service
class MicrosoftAuthService {
  
  /// Sign in with REAL Microsoft account using Firebase Auth
  static Future<UserCredential?> signInWithMicrosoft(BuildContext context) async {
    try {
      debugPrint('Starting REAL Microsoft authentication...');
      
      // Create Microsoft OAuth provider
      final microsoftProvider = MicrosoftAuthProvider();
      
      // Add required scopes for Microsoft Graph
      microsoftProvider.addScope('user.read');
      microsoftProvider.addScope('openid');
      microsoftProvider.addScope('profile');
      microsoftProvider.addScope('email');
      
             // Set custom parameters
       microsoftProvider.setCustomParameters({
         'tenant': 'common', // Supports personal and work accounts
         'prompt': 'select_account', // Always show account selection
       });
      
      debugPrint('Opening Microsoft sign-in popup...');
      
      // Sign in with Microsoft using Firebase Auth
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
      
      // Get the signed-in user
      final User? user = userCredential.user;
      
      if (user != null) {
        debugPrint('Microsoft authentication successful!');
        debugPrint('User: ${user.email}');
        debugPrint('Display Name: ${user.displayName}');
        debugPrint('Provider: ${user.providerData.first.providerId}');
        
        return userCredential;
      } else {
        debugPrint('Microsoft authentication failed - no user returned');
        return null;
      }
      
    } on FirebaseAuthException catch (e) {
      debugPrint('Microsoft authentication error: ${e.code} - ${e.message}');
      
      // Handle specific Microsoft auth errors
      switch (e.code) {
        case 'cancelled-popup-request':
        case 'popup-closed-by-user':
          debugPrint('Microsoft sign-in cancelled by user');
          break;
        case 'popup-blocked':
          debugPrint('Microsoft sign-in popup blocked');
          break;
        case 'network-request-failed':
          debugPrint('Network error during Microsoft sign-in');
          break;
        default:
          debugPrint('Unknown Microsoft sign-in error: ${e.code}');
      }
      
      return null;
    } catch (e) {
      debugPrint('Unexpected Microsoft authentication error: $e');
      return null;
    }
  }
  
  /// Sign out from Microsoft
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('Microsoft sign-out successful');
    } catch (e) {
      debugPrint('Microsoft sign-out error: $e');
    }
  }
  
  /// Get current Microsoft user info
  static User? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if user signed in with Microsoft
      final microsoftProvider = user.providerData.firstWhere(
        (provider) => provider.providerId == 'microsoft.com',
        orElse: () => throw StateError('Not a Microsoft user'),
      );
      
      debugPrint('Current Microsoft user: ${user.email}');
      return user;
    }
    return null;
  }
} 