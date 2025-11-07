import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/users_repository.dart';
import '../../../core/network/network_providers.dart';

/// Repo
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final client = ref.read(dioClientProvider);
  return UsersRepository(client);
});

/// Lista
final usersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(usersRepositoryProvider);
  return repo.listar();
});

/// Acciones
class _UsersActions extends Notifier<void> {
  late final UsersRepository _repo;
  @override
  void build() {
    _repo = ref.read(usersRepositoryProvider);
  }

  Future<void> crear({
    required String email,
    required String nombre,
    required String password,
    required String rol, // "ADMIN" | "AGENTE" | "COLABORADOR"
    bool activo = true,
  }) async {
    await _repo.crear(
        email: email, nombre: nombre, password: password, rol: rol, activo: activo);
    ref.invalidate(usersProvider);
  }

  Future<void> actualizar(
    String id, {
    String? email,
    String? nombre,
    String? password,
    String? rol,
    bool? activo,
  }) async {
    await _repo.actualizar(id,
        email: email, nombre: nombre, password: password, rol: rol, activo: activo);
    ref.invalidate(usersProvider);
  }

  Future<void> eliminar(String id) async {
    await _repo.eliminar(id);
    ref.invalidate(usersProvider);
  }
}
final usersActionsProvider =
    NotifierProvider<_UsersActions, void>(_UsersActions.new);
