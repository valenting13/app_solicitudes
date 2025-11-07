import 'package:dio/dio.dart';

class UsersApi {
  final Dio _dio;
  UsersApi(this._dio);

  Future<List<Map<String, dynamic>>> listar({int limit = 50, int offset = 0}) async {
    final r = await _dio.get('/api/v1/usuarios', queryParameters: {'limit': limit, 'offset': offset});
    return (r.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> crear({
    required String email,
    required String nombre,
    required String password,
    required String rol,
    bool activo = true,
  }) async {
    final r = await _dio.post('/api/v1/usuarios', data: {
      'email': email,
      'nombre': nombre,
      'password': password,
      'rol': rol,
      'activo': activo,
    });
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> actualizar(
    String id, {
    String? email,
    String? nombre,
    String? password,
    String? rol,
    bool? activo,
  }) async {
    final r = await _dio.patch('/api/v1/usuarios/$id', data: {
      if (email != null) 'email': email,
      if (nombre != null) 'nombre': nombre,
      if (password != null) 'password': password,
      if (rol != null) 'rol': rol,
      if (activo != null) 'activo': activo,
    });
    return Map<String, dynamic>.from(r.data);
  }

  Future<void> eliminar(String id) async {
    await _dio.delete('/api/v1/usuarios/$id');
  }
}
