import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();

  @override
  Future<UserEntity?> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDataSource.login(
      email: email,
      password: password,
    );
    return userModel;
  }

  @override
  Future<UserEntity?> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    final userModel = await remoteDataSource.register(
      email: email,
      password: password,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
    return userModel;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await remoteDataSource.forgotPassword(email: email);
  }
}
