import '../../../core/network/dio_client.dart';
import 'users_api.dart';

class UsersRepository {
  final UsersApi _api;
  UsersRepository(DioClient client) : _api = UsersApi(client.dio);

  Future<List<Map<String, dynamic>>> listar() => _api.listar();

  Future<Map<String, dynamic>> crear({
    required String email,
    required String nombre,
    required String password,
    required String rol,
    bool activo = true,
  }) => _api.crear(email: email, nombre: nombre, password: password, rol: rol, activo: activo);

  Future<Map<String, dynamic>> actualizar(
    String id, {String? email, String? nombre, String? password, String? rol, bool? activo}
  ) => _api.actualizar(id, email: email, nombre: nombre, password: password, rol: rol, activo: activo);

  Future<void> eliminar(String id) => _api.eliminar(id);
}
