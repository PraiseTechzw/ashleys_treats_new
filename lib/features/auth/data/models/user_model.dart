import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.email,
    required super.displayName,
    required super.phoneNumber,
    required super.role,
    required super.addresses,
    required super.preferences,
    required super.createdAt,
    required super.lastActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? 'customer',
      addresses: List<dynamic>.from(map['addresses'] ?? []),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      lastActive: DateTime.parse(
        map['lastActive'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role,
      'addresses': addresses,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
    };
  }
}
