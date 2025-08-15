class UserEntity {
  final String userId;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String role;
  final List<dynamic> addresses;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime lastActive;

  UserEntity({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.role,
    required this.addresses,
    required this.preferences,
    required this.createdAt,
    required this.lastActive,
  });
}
