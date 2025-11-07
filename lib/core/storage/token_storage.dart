import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _k = 'auth_token';

  Future<void> save(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_k, token);
  }

  Future<String?> read() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_k);
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_k);
  }
}
