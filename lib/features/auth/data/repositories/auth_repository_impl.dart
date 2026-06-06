import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.login(email: email, password: password);
  }

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    return await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      age: age,
      gender: gender,
    );
  }

  Future<UserEntity> getProfile() async {
    return await _remoteDataSource.getProfile();
  }

  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  Future<bool> isLoggedIn() async {
    return await _remoteDataSource.isLoggedIn();
  }
}
