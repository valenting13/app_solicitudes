import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<String> login({required String email, required String password}) async {
    final r = await _dio.post('/api/v1/auth/login', data: {
      'email': email,
      'password': password,
    });
    return r.data['access_token'] as String;
  }

  Future<Map<String, dynamic>> me() async {
    final r = await _dio.get('/api/v1/auth/me');
    return Map<String, dynamic>.from(r.data);
  }
}
