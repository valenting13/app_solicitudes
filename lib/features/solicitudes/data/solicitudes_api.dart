import 'package:dio/dio.dart';

class SolicitudesApi {
  final Dio _dio;
  SolicitudesApi(this._dio);

  Future<List<Map<String, dynamic>>> listar({
    bool mias = true,
    String? estado,
    String? categoria,
    int limit = 50,
    int offset = 0,
  }) async {
    final r = await _dio.get('/api/v1/solicitudes', queryParameters: {
      if (mias) 'mias': true,
      if (estado != null) 'estado': estado,
      if (categoria != null && categoria.isNotEmpty) 'categoria': categoria,
      'limit': limit,
      'offset': offset,
    });
    return (r.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> crear({
    required String titulo,
    required String descripcion,
    String? categoria,
  }) async {
    final r = await _dio.post('/api/v1/solicitudes', data: {
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
    });
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> actualizar(
    int id, {
    String? titulo,
    String? descripcion,
    String? estado,
    String? categoria,
  }) async {
    final r = await _dio.patch('/api/v1/solicitudes/$id', data: {
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (estado != null) 'estado': estado,
      if (categoria != null) 'categoria': categoria,
    });
    return Map<String, dynamic>.from(r.data);
  }

  Future<void> eliminar(int id) async {
    await _dio.delete('/api/v1/solicitudes/$id');
  }

  Future<Map<String, dynamic>> ver(int id) async {
    final r = await _dio.get('/api/v1/solicitudes/$id');
    return Map<String, dynamic>.from(r.data);
  }
}
