import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_solicitudes/shared/app_providers.dart';
import '../data/solicitudes_repository.dart';
import '../../../core/network/network_providers.dart';


/// Repo
final solicitudesRepositoryProvider = Provider<SolicitudesRepository>((ref) {
  final client = ref.read(dioClientProvider);
  return SolicitudesRepository(client);
});


/// Filtro: categoría (nullable)
class _FiltroCategoria extends Notifier<String?> {
  @override
  String? build() => null; // sin filtro
  void set(String? v) => state = v;
}
final filtroCategoriaProvider =
    NotifierProvider<_FiltroCategoria, String?>(_FiltroCategoria.new);

/// Filtro: solo mis solicitudes (true por defecto)
class _SoloMias extends Notifier<bool> {
  @override
  bool build() {
    // Leemos el valor actual de isAdminProvider
    final isAdmin = ref.watch(isAdminProvider);

    // Si es admin -> false (ve todas)
    // Si no es admin -> true (solo las suyas)
    return !isAdmin;
  }

  void set(bool v) => state = v;
  void toggle() => state = !state;
}
final soloMiasProvider = NotifierProvider<_SoloMias, bool>(_SoloMias.new);


/// Lista de solicitudes (se vuelve a cargar cuando cambian los filtros)
final solicitudesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(solicitudesRepositoryProvider);
  final cat = ref.watch(filtroCategoriaProvider);
  final mias = ref.watch(soloMiasProvider);
  return repo.listar(mias: mias, categoria: cat);
});

/// Acciones (crear/editar/eliminar) que invalidan la lista
class _SolicitudesActions extends Notifier<void> {
  late final SolicitudesRepository _repo;
  @override
  void build() {
    _repo = ref.read(solicitudesRepositoryProvider);
  }

  Future<void> crear({
    required String titulo,
    required String descripcion,
    String? categoria,
  }) async {
    await _repo.crear(titulo: titulo, descripcion: descripcion, categoria: categoria);
    ref.invalidate(solicitudesProvider);
  }

  Future<void> actualizar(
    int id, {
    String? titulo,
    String? descripcion,
    String? estado,
    String? categoria,
  }) async {
    await _repo.actualizar(id,
        titulo: titulo, descripcion: descripcion, estado: estado, categoria: categoria);
    ref.invalidate(solicitudesProvider);
  }

  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    ref.invalidate(solicitudesProvider);
  }
}
final solicitudesActionsProvider =
    NotifierProvider<_SolicitudesActions, void>(_SolicitudesActions.new);
