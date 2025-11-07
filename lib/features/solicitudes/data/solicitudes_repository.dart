import '../../../core/network/dio_client.dart';
import 'solicitudes_api.dart';

class SolicitudesRepository {
  final SolicitudesApi _api;
  SolicitudesRepository(DioClient client) : _api = SolicitudesApi(client.dio);

  Future<List<Map<String, dynamic>>> listar({bool mias = true, String? estado, String? categoria}) =>
      _api.listar(mias: mias, estado: estado, categoria: categoria);

  Future<Map<String, dynamic>> crear({required String titulo, required String descripcion, String? categoria}) =>
      _api.crear(titulo: titulo, descripcion: descripcion, categoria: categoria);

  Future<Map<String, dynamic>> actualizar(
    int id, {
    String? titulo,
    String? descripcion,
    String? estado,
    String? categoria,
  }) =>
      _api.actualizar(id, titulo: titulo, descripcion: descripcion, estado: estado, categoria: categoria);

  Future<void> eliminar(int id) => _api.eliminar(id);
  Future<Map<String, dynamic>> ver(int id) => _api.ver(id);
}
