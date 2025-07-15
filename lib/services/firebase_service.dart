import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'microsoft_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service class for handling Firebase operations including authentication and Firestore.
///
/// This service provides:
/// - User authentication (sign in, sign up, sign out)
/// - Firestore database operations
/// - User session management
/// - Account management features
///
/// copied from class lab
class FirebaseService {
  static const String _googleWebClientId = '858547004241-58s8sqkf1053runqnb2jmsiffh1pdn91.apps.googleusercontent.com';
  
  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login(email, password) async {
    try {
      // First, attempt to login with Firebase Auth
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      //commented off because removing pending email change
      // After successful login, check if there's a pending email change
      // if (userCredential.user != null) {
      //   final pendingChange = await getPendingEmailChange();
      //   if (pendingChange != null && 
      //       pendingChange['pendingEmail'] != null &&
      //       pendingChange['emailVerified'] == false) {
          
      //     // If user is trying to login with old email but has pending change
      //     if (email != pendingChange['pendingEmail']) {
      //       // Sign out the user and throw an error
      //       await FirebaseAuth.instance.signOut();
      //       throw FirebaseAuthException(
      //         code: 'email-change-pending',
      //         message: 'Please verify your new email address before logging in. Check your email for verification link.',
      //       );
      //     }
      //   }
      // }
      
      return userCredential;
    } catch (e) {
      debugPrint('Login failed: $e');
      throw e;
    }
  }

  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }

  // Non async forgotPassword function sends a password reset email to the user
  Future<void> forgotPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser =
          await GoogleSignIn(
            clientId: _googleWebClientId,
          ).signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Check for pending email changes after successful Google sign-in
      if (userCredential.user != null) {
        debugPrint('Google Sign-In successful for user: ${userCredential.user!.uid}');
        debugPrint('User email: ${userCredential.user!.email}');
        
        // Check if there's a pending email change for this user
        // final pendingChange = await getPendingEmailChange();
        // debugPrint('Pending email change check result: $pendingChange');
        
        // if (pendingChange != null && 
        //     pendingChange['pendingEmail'] != null &&
        //     pendingChange['emailVerified'] == false) {
          
        //   debugPrint('Found pending email change: ${pendingChange['pendingEmail']}');
        //   debugPrint('Current user email: ${userCredential.user!.email}');
          
        //   // If user is trying to login with old email but has pending change
        //   if (userCredential.user!.email != pendingChange['pendingEmail']) {
        //     debugPrint('Blocking login - user trying to login with old email while pending change exists');
        //     // Sign out the user and return a special result indicating email change pending
        //     await FirebaseAuth.instance.signOut();
        //     return {
        //       'success': false,
        //       'error': 'email-change-pending',
        //       'message': 'Please verify your new email address before logging in. Check your email for verification link.',
        //     };
        //   }
        // } else {
        //   debugPrint('No pending email change found or email is already verified');
        // }
        
        // IMPORTANT: Preserve custom name from Firestore after Google sign-in
        await _preserveUserCustomName(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      return null;
    }
  }

  // Helper method to preserve user's custom name from Firestore
  Future<void> _preserveUserCustomName(User user) async {
    try {
      // Get stored name from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        final storedName = doc.data()?['name'] as String?;
        if (storedName != null && storedName.isNotEmpty) {
          // Update Firebase Auth display name to match Firestore
          await user.updateDisplayName(storedName);
          await user.reload();
          debugPrint('Preserved custom name: $storedName for ${user.uid}');
        } else {
          debugPrint('No custom name found in Firestore for ${user.uid}');
        }
      } else {
        debugPrint('No Firestore profile found for ${user.uid}');
      }
    } catch (e) {
      debugPrint('Error preserving custom name: $e');
    }
  }

  // Helper method to check for account conflicts
  Future<bool> checkForAccountConflict(String email) async {
    try {
      // Check if there's already a Firestore document for this email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final existingDoc = querySnapshot.docs.first;
        final currentUser = FirebaseAuth.instance.currentUser;
        
        if (currentUser != null && existingDoc.id != currentUser.uid) {
          debugPrint('Account conflict detected for email: $email');
          debugPrint('Existing Firestore document: ${existingDoc.id}');
          debugPrint('Current Firebase Auth user: ${currentUser.uid}');
          return true;
        }
      }
      
      return false;
    } catch (e) {
      debugPrint('Error checking account conflict: $e');
      return false;
    }
  }

  // Account Management Features
  Future<void> changeEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('Starting email change for ${user.uid}: ${user.email} -> $newEmail');
        
        // Step 1: Update email in Firebase Auth (requires verification)
        await user.verifyBeforeUpdateEmail(newEmail);
        debugPrint('Firebase Auth email verification initiated');
        
        // Step 2: Store pending email change in Firestore with verification status
        // debugPrint('Updating Firestore with pending email change...');
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.uid)
        //     .update({
        //   'pendingEmail': newEmail,
        //   'emailChangeRequestedAt': FieldValue.serverTimestamp(),
        //   'emailVerified': false, // Mark as unverified until user clicks verification link
        //   'updatedAt': FieldValue.serverTimestamp(),
        // });
        
        debugPrint('Email change initiated for ${user.uid}: $newEmail');
        debugPrint('User will receive verification email at: $newEmail');
        // debugPrint('Firestore updated with pending email change');
        
        // Verify the update was successful
        // final doc = await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.uid)
        //     .get();
        
        // if (doc.exists) {
        //   final data = doc.data();
        //   debugPrint('Verification - Firestore data after update: $data');
        //   debugPrint('Verification - Pending email stored: ${data?['pendingEmail']}');
        // }
      }
    } catch (e) {
      debugPrint('Change email failed: $e');
      throw e;
    }
  }

  // Check if user has a pending email change
  // Future<Map<String, dynamic>?> getPendingEmailChange() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     debugPrint('getPendingEmailChange: Current user UID: ${user?.uid}');
  //     debugPrint('getPendingEmailChange: Current user email: ${user?.email}');
      
  //     if (user != null) {
  //       final doc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .collection('users')
  //           .doc(user.uid)
  //           .get();
        
  //     debugPrint('getPendingEmailChange: Firestore document exists: ${doc.exists}');
        
  //     if (doc.exists) {
  //       final data = doc.data();
  //       debugPrint('getPendingEmailChange: Firestore data: $data');
          
  //       if (data != null && data['pendingEmail'] != null) {
  //         debugPrint('getPendingEmailChange: Found pending email: ${data['pendingEmail']}');
  //         return {
  //           'pendingEmail': data['pendingEmail'],
  //           'emailChangeRequestedAt': data['emailChangeRequestedAt'],
  //           'emailVerified': data['emailVerified'] ?? false,
  //         };
  //       } else {
  //         debugPrint('getPendingEmailChange: No pending email found in data');
  //       }
  //     } else {
  //       debugPrint('getPendingEmailChange: No Firestore document found for user ${user.uid}');
  //     }
  //   } else {
  //     debugPrint('getPendingEmailChange: No current user found');
  //   }
  //   return null;
  // } catch (e) {
  //   debugPrint('Error getting pending email change: $e');
  //   return null;
  // }
  // }

  // Complete email change after verification
  Future<void> completeEmailChange() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if user's email in Firebase Auth matches the pending email
        // final pendingChange = await getPendingEmailChange();
        // if (pendingChange != null && 
        //     user.email == pendingChange['pendingEmail']) {
          
        //   // Update Firestore to reflect the completed email change
        //   await FirebaseFirestore.instance
        //       .collection('users')
        //       .doc(user.uid)
        //       .update({
        //     'email': user.email, // Update with the verified email
        //     'pendingEmail': FieldValue.delete(), // Remove pending email
        //     'emailChangeRequestedAt': FieldValue.delete(), // Remove timestamp
        //     'emailVerified': true,
        //     'updatedAt': FieldValue.serverTimestamp(),
        //   });
          
        //   debugPrint('Email change completed for ${user.uid}: ${user.email}');
        // }
      }
    } catch (e) {
      debugPrint('Complete email change failed: $e');
      throw e;
    }
  }

  // Check and handle email verification on app startup
  Future<void> checkEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        // User's email is verified, check if we need to complete email change
        // final pendingChange = await getPendingEmailChange();
        // if (pendingChange != null && 
        //     user.email == pendingChange['pendingEmail']) {
        //   await completeEmailChange();
        // }
      }
    } catch (e) {
      debugPrint('Error checking email verification: $e');
    }
  }

  // Debug method to check pending email status
  Future<void> debugPendingEmailStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      debugPrint('=== DEBUG PENDING EMAIL STATUS ===');
      debugPrint('Current user UID: ${user?.uid}');
      debugPrint('Current user email: ${user?.email}');
      debugPrint('Current user email verified: ${user?.emailVerified}');
      
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        debugPrint('Firestore document exists: ${doc.exists}');
        if (doc.exists) {
          final data = doc.data();
          debugPrint('Firestore data: $data');
          debugPrint('Pending email: ${data?['pendingEmail']}');
          debugPrint('Email verified: ${data?['emailVerified']}');
        }
      }
      debugPrint('=== END DEBUG ===');
    } catch (e) {
      debugPrint('Error in debug method: $e');
    }
  }

  // Test method to manually set a pending email change
  Future<void> setTestPendingEmailChange(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('Setting test pending email change: ${user.email} -> $newEmail');
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'pendingEmail': newEmail,
          'emailChangeRequestedAt': FieldValue.serverTimestamp(),
          'emailVerified': false,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        debugPrint('Test pending email change set successfully');
      }
    } catch (e) {
      debugPrint('Error setting test pending email change: $e');
      throw e;
    }
  }
  
  // Update display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload(); // Refresh user data
      }
    } catch (e) {
      debugPrint('Update display name failed: $e');
      throw e;
    }
  }


  Future<dynamic> signInWithMicrosoft(BuildContext context) async {
    try {
      debugPrint('Microsoft Sign-In clicked - using REAL Microsoft OAuth');
      
      // Use the real Microsoft authentication service
      final userCredential = await MicrosoftAuthService.signInWithMicrosoft(context);
      
      // Check for pending email changes after successful Microsoft sign-in
      if (userCredential != null && userCredential.user != null) {
        debugPrint('Microsoft Sign-In successful for user: ${userCredential.user!.uid}');
        debugPrint('User email: ${userCredential.user!.email}');
        
        // final pendingChange = await getPendingEmailChange();
        // debugPrint('Microsoft Sign-In - Pending email change check result: $pendingChange');
        
        // if (pendingChange != null && 
        //     pendingChange['pendingEmail'] != null &&
        //     pendingChange['emailVerified'] == false) {
          
        //   debugPrint('Microsoft Sign-In - Found pending email change: ${pendingChange['pendingEmail']}');
        //   debugPrint('Microsoft Sign-In - Current user email: ${userCredential.user!.email}');
          
        //   // If user is trying to login with old email but has pending change
        //   if (userCredential.user!.email != pendingChange['pendingEmail']) {
        //     debugPrint('Microsoft Sign-In - Blocking login - user trying to login with old email while pending change exists');
        //     // Sign out the user and return a special result indicating email change pending
        //     await FirebaseAuth.instance.signOut();
        //     return {
        //       'success': false,
        //       'error': 'email-change-pending',
        //       'message': 'Please verify your new email address before logging in. Check your email for verification link.',
        //     };
        //   }
        // } else {
        //   debugPrint('Microsoft Sign-In - No pending email change found or email is already verified');
        // }
      }
      
      return userCredential;
    } catch (e) {
      debugPrint('Microsoft Sign-In failed: $e');
      return null;
    }
  }

  // Simple User Role Management with Firestore (User-Specific)
  
  /// Store complete user profile in Firestore
  Future<void> storeUserProfile({
    required String role,
    required String name,
    required String phone,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'role': role,
        'name': name,
        'phone': phone,
        'email': user.email ?? '', // Capture user's email
        'profileCompleted': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('User profile stored successfully for ${user.uid}: role=$role, email=${user.email}');
    }
  }
  
  /// Store user role in Firestore
  Future<void> storeUserRole(String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('User role stored: $role for ${user.uid}');
    }
  }
  
  /// Get user role from Firestore
  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          final role = doc.data()?['role'] as String?;
          debugPrint('getUserRole: Found role in Firestore: $role for user ${user.uid}');
          return role;
        } else {
          debugPrint('getUserRole: No Firestore document found for user ${user.uid}');
        }
      } catch (e) {
        debugPrint('Error getting user role: $e');
      }
    } else {
      debugPrint('getUserRole: No current user found');
    }
    debugPrint('getUserRole: Returning null (no role found)');
    return null;
  }
  
  /// Check if user has completed profile setup
  Future<bool> hasCompletedProfileSetup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        return doc.exists && (doc.data()?['profileCompleted'] == true);
      } catch (e) {
        debugPrint('Error checking profile setup: $e');
      }
    }
    return false;
  }
  
  /// Mark profile setup as completed
  Future<void> markProfileSetupCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('Profile setup marked as completed for ${user.uid}');
    }
  }
  
  /// Simple helper method to navigate to correct home screen based on user role
  Future<String> getHomeScreenRoute() async {
    final userRole = await getUserRole();
    
    debugPrint('getHomeScreenRoute: userRole = $userRole');
    
    if (userRole == 'Driver') {
      debugPrint('getHomeScreenRoute: Navigating to driver home');
      return '/driver_home';
    } else {
      debugPrint('getHomeScreenRoute: Navigating to passenger home (default)');
      return '/passenger_home';
    }
  }

  /// Check if the current user can change their password
  /// Only email/password users can change their password
  /// Google and Microsoft users cannot change password through the app
  bool canUserChangePassword() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    // Check if user has email/password provider
    final hasEmailPasswordProvider = user.providerData.any(
      (provider) => provider.providerId == 'password'
    );
    
    debugPrint('User ${user.uid} can change password: $hasEmailPasswordProvider');
    debugPrint('User providers: ${user.providerData.map((p) => p.providerId).toList()}');
    
    return hasEmailPasswordProvider;
  }

  /// Get the user's authentication provider type for display purposes
  String getUserAuthProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Unknown';
    
    final providers = user.providerData.map((p) => p.providerId).toList();
    
    if (providers.contains('password')) {
      return 'Email/Password';
    } else if (providers.contains('google.com')) {
      return 'Google';
    } else if (providers.contains('microsoft.com')) {
      return 'Microsoft';
    } else {
      return 'Other';
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      
      // Check if user can change password
      if (!canUserChangePassword()) {
        throw Exception('Password change is not available for your account type. Please contact support if you need to reset your password.');
      }
      
      // Re-authenticate user first
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Then update password
      await user.updatePassword(newPassword);
      
      debugPrint('Password changed successfully for user ${user.uid}');
    } catch (e) {
      debugPrint('Change password failed: $e');
      throw e;
    }
  }

  /// Comprehensive account deletion that cleans up all user data
  Future<void> deleteAccount(String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      
      final String userId = user.uid;
      debugPrint('Starting comprehensive account deletion for user: $userId');
      
      // Step 1: Clean up Firestore data first
      await _cleanupUserData(userId);
      
      // Step 2: Re-authenticate user (required for account deletion)
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Step 3: Delete Firebase Auth account
      await user.delete();
      
      debugPrint('Account deletion completed successfully for user: $userId');
    } catch (e) {
      debugPrint('Delete account failed: $e');
      throw e;
    }
  }

  /// Delete account for social login users (Google/Microsoft) who don't have passwords
  Future<void> deleteAccountSocial() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      
      final String userId = user.uid;
      debugPrint('Starting social account deletion for user: $userId');
      
      // Step 1: Clean up Firestore data first
      await _cleanupUserData(userId);
      
      // Step 2: Delete Firebase Auth account (no re-authentication needed for social login)
      await user.delete();
      
      debugPrint('Social account deletion completed successfully for user: $userId');
    } catch (e) {
      debugPrint('Delete social account failed: $e');
      throw e;
    }
  }

  /// Check if the current user can delete their account with password
  /// Only email/password users need password for deletion
  bool canUserDeleteWithPassword() {
    return canUserChangePassword(); // Same logic as password change
  }

  /// Clean up all user data from Firestore
  Future<void> _cleanupUserData(String userId) async {
    try {
      debugPrint('Cleaning up Firestore data for user: $userId');
      
      // Delete user profile document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .delete();
      
      debugPrint('Deleted user profile document for: $userId');
      
      // TODO: Add cleanup for other collections when they are implemented
      // Examples of future collections to clean up:
      // - user_bookings
      // - user_listings  
      // - user_chats
      // - user_notifications
      // - user_preferences
      
      // Example cleanup for future collections:
      // await _cleanupUserBookings(userId);
      // await _cleanupUserListings(userId);
      // await _cleanupUserChats(userId);
      
    } catch (e) {
      debugPrint('Error cleaning up user data: $e');
      // Don't throw here - we still want to delete the auth account
      // even if Firestore cleanup fails
    }
  }

  // /// Helper method to cleanup user bookings (for future implementation)
  // Future<void> _cleanupUserBookings(String userId) async {
  //   try {
  //     // Query and delete all bookings for this user
  //     final bookingsQuery = await FirebaseFirestore.instance
  //         .collection('bookings')
  //         .where('userId', isEqualTo: userId)
  //         .get();
      
  //     for (final doc in bookingsQuery.docs) {
  //       await doc.reference.delete();
  //     }
      
  //     debugPrint('Cleaned up ${bookingsQuery.docs.length} bookings for user: $userId');
  //   } catch (e) {
  //     debugPrint('Error cleaning up user bookings: $e');
  //   }
  // }

  // /// Helper method to cleanup user listings (for future implementation)
  // Future<void> _cleanupUserListings(String userId) async {
  //   try {
  //     // Query and delete all listings created by this user
  //     final listingsQuery = await FirebaseFirestore.instance
  //         .collection('listings')
  //         .where('driverId', isEqualTo: userId)
  //         .get();
      
  //     for (final doc in listingsQuery.docs) {
  //       await doc.reference.delete();
  //     }
      
  //     debugPrint('Cleaned up ${listingsQuery.docs.length} listings for user: $userId');
  //   } catch (e) {
  //     debugPrint('Error cleaning up user listings: $e');
  //   }
  // }

  // /// Helper method to cleanup user chats (for future implementation)
  // Future<void> _cleanupUserChats(String userId) async {
  //   try {
  //     // Query and delete all chat messages for this user
  //     final chatsQuery = await FirebaseFirestore.instance
  //         .collection('chats')
  //         .where('participants', arrayContains: userId)
  //         .get();
      
  //     for (final doc in chatsQuery.docs) {
  //       await doc.reference.delete();
  //     }
      
  //     debugPrint('Cleaned up ${chatsQuery.docs.length} chats for user: $userId');
  //   } catch (e) {
  //     debugPrint('Error cleaning up user chats: $e');
  //   }
  // }

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>?;
        }
      } catch (e) {
        debugPrint('Get user profile failed: $e');
      }
    }
    return null;
  }
  
  // Get user phone number from Firestore
  Future<String?> getUserPhone() async {
    final profile = await getUserProfile();
    return profile?['phone'] as String?;
  }
  
  // Get user email from Firestore
  Future<String?> getUserEmail() async {
    final profile = await getUserProfile();
    return profile?['email'] as String?;
  }
  
  /// Update user phone number in Firestore
  Future<void> updatePhoneNumber(String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'phone': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Also update SharedPreferences for backward compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_phone', phoneNumber);
      
      debugPrint('Phone number updated: $phoneNumber for ${user.uid}');
    }
  }
  
  /// Automatic migration for existing users from SharedPreferences to Firestore
  /// Returns true if user needs to complete profile setup, false if migration was successful
  Future<bool> migrateExistingUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    try {
      // Check for potential account conflicts first
      if (user.email != null) {
        final hasConflict = await checkForAccountConflict(user.email!);
        if (hasConflict) {
          debugPrint('Account conflict detected during migration for ${user.uid}');
          // For now, log the conflict - in production, you might want to handle this differently
        }
      }
      
      // Check if user already has Firestore document
      final hasFirestoreProfile = await hasCompletedProfileSetup();
      if (hasFirestoreProfile) {
        debugPrint('User ${user.uid} already has Firestore profile');
        // Still preserve custom name in case it was overridden
        await _preserveUserCustomName(user);
        return false; // User doesn't need setup
      }
      
      // Check for existing SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      final oldRole = prefs.getString('user_role');
      final oldPhone = prefs.getString('user_phone');
      final oldCompleted = prefs.getBool('profile_completed') ?? false;
      
      // Only migrate if user has BOTH completed profile AND role data
      // This ensures we only migrate users who went through the new system
      if (oldCompleted && oldRole != null) {
        debugPrint('Migrating existing user ${user.uid} from SharedPreferences to Firestore');
        
        await storeUserProfile(
          role: oldRole,
          name: user.displayName ?? 'User',
          phone: oldPhone ?? '',
        );
        
        debugPrint('Successfully migrated user ${user.uid}: role=$oldRole, phone=$oldPhone, email=${user.email}');
        
        // Clear SharedPreferences data after successful migration
        await prefs.remove('user_role');
        await prefs.remove('profile_completed');
        // Keep user_phone for backward compatibility
        
        return false; // User doesn't need setup, migration complete
        
      } else {
        // For all other cases (existing users without complete role data), 
        // clear all data and force them through profile setup
        debugPrint('User ${user.uid} needs to complete profile setup to choose role');
        
        // Clear ALL migration-related data to ensure clean state
        await prefs.remove('user_role');
        await prefs.remove('profile_completed');
        
        // Also ensure no stale Firestore data exists for this user
        // This prevents any cached or incomplete Firestore documents from interfering
        try {
          final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
          final docSnapshot = await userDoc.get();
          
          if (docSnapshot.exists) {
            final data = docSnapshot.data();
            if (data != null && data['profileCompleted'] != true) {
              // Delete incomplete Firestore profile to ensure clean state
              await userDoc.delete();
              debugPrint('Deleted incomplete Firestore profile for user ${user.uid}');
            }
          }
        } catch (e) {
          debugPrint('Error cleaning up Firestore data: $e');
        }
        
        return true; // User needs to complete profile setup
      }
      
    } catch (e) {
      debugPrint('Error during user migration: $e');
      // On error, assume user needs setup to be safe
      return true;
    }
  }

  // Resend verification email to the pending email address
  Future<void> resendPendingEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data();
        final pendingEmail = data?['pendingEmail'];
        if (pendingEmail != null && pendingEmail is String) {
          await user.verifyBeforeUpdateEmail(pendingEmail);
        } else {
          throw Exception('No pending email to verify.');
        }
      }
    } catch (e) {
      debugPrint('Resend verification email failed: $e');
      rethrow;
    }
  }

  // Cancel the pending email change for the current user
  Future<void> cancelPendingEmailChange() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'pendingEmail': FieldValue.delete(),
          'emailChangeRequestedAt': FieldValue.delete(),
          'emailVerified': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Cancel pending email change failed: $e');
      rethrow;
    }
  }
}
