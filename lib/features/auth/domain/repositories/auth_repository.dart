import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login({required String email, required String password});
  Future<UserEntity?> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> forgotPassword({required String email});
}
