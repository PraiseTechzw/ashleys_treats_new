import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        // Update last active timestamp
        await _updateLastActive(user.uid);
        return await _getUserFromFirestore(user.uid) ?? _userFromFirebase(user);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel?> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        // Update display name in Firebase Auth
        await user.updateDisplayName(displayName);

        // Create user document in Firestore
        final userModel = UserModel(
          userId: user.uid,
          email: email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          role: 'customer', // Default role
          addresses: [],
          preferences: {
            'notifications': true,
            'emailUpdates': true,
            'theme': 'light',
          },
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        await _saveUserToFirestore(userModel);
        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Try to get user from Firestore first, fallback to Firebase Auth data
        return await _getUserFromFirestore(user.uid) ?? _userFromFirebase(user);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? phoneNumber,
    List<dynamic>? addresses,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);
      final updates = <String, dynamic>{};

      if (displayName != null) updates['displayName'] = displayName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (addresses != null) updates['addresses'] = addresses;
      if (preferences != null) updates['preferences'] = preferences;

      updates['lastActive'] = DateTime.now().toIso8601String();

      await userDoc.update(updates);
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  Future<void> updateUserRole(String userId, String role) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': role,
        'lastActive': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update user role: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Delete from Firebase Auth (requires re-authentication)
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  // Private helper methods
  Future<UserModel?> _getUserFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      // If Firestore fails, return null to fallback to Firebase Auth data
      return null;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user to database: ${e.toString()}');
    }
  }

  Future<void> _updateLastActive(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastActive': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silently fail for last active updates
    }
  }

  UserModel _userFromFirebase(User user) {
    return UserModel(
      userId: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      role: 'customer', // Default role
      addresses: [],
      preferences: {
        'notifications': true,
        'emailUpdates': true,
        'theme': 'light',
      },
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastActive: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password. Please try again';
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
