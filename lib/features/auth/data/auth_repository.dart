import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/auth_user.dart';
import 'auth_api.dart';

class AuthRepository {
  final DioClient _client;
  final TokenStorage _storage;
  late final AuthApi _api;

  AuthRepository(this._client, this._storage) {
    _api = AuthApi(_client.dio);
  }

  Future<void> init() async {
    final t = await _storage.read();
    _client.setToken(t);
  }

  Future<bool> isLoggedIn() async => (await _storage.read()) != null;

  Future<void> login(String email, String password) async {
    final token = await _api.login(email: email, password: password);
    await _storage.save(token);
    _client.setToken(token);
  }

  Future<AuthUser> me() async => AuthUser.fromJson(await _api.me());

  Future<void> logout() async {
    await _storage.clear();
    _client.setToken(null);
  }
}
