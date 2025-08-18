import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user_model.dart';

class FirestoreUserService {
  static final FirestoreUserService _instance =
      FirestoreUserService._internal();
  factory FirestoreUserService() => _instance;
  FirestoreUserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _usersCollection.doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['userId'] = doc.id; // Ensure userId is set from document ID
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  // Create or update user profile
  Future<void> createOrUpdateUser(UserModel userModel) async {
    try {
      await _usersCollection.doc(userModel.userId).set({
        'displayName': userModel.displayName,
        'email': userModel.email,
        'phoneNumber': userModel.phoneNumber,
        'addresses': userModel.addresses,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create/update user: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? phoneNumber,
    List<String>? addresses,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updateData['displayName'] = displayName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (addresses != null) updateData['addresses'] = addresses;

      await _usersCollection.doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Add new address to user
  Future<void> addUserAddress(String userId, String address) async {
    try {
      await _usersCollection.doc(userId).update({
        'addresses': FieldValue.arrayUnion([address]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  // Remove address from user
  Future<void> removeUserAddress(String userId, String address) async {
    try {
      await _usersCollection.doc(userId).update({
        'addresses': FieldValue.arrayRemove([address]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove address: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['userId'] = doc.id; // Ensure userId is set from document ID
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Stream user data for real-time updates
  Stream<UserModel?> streamUser(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['userId'] = doc.id; // Ensure userId is set from document ID
        return UserModel.fromMap(data);
      }
      return null;
    });
  }

  // Delete user account
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
