import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';
import '../../../shared/app_providers.dart';
import '../../../core/network/network_providers.dart';

final authRepositoryProvider = Provider((ref) {
  final client = ref.read(dioClientProvider);
  final storage = ref.read(tokenStorageProvider);
  return AuthRepository(client, storage);
});

/// Inicializa auth y determina si hay sesión previa.
final authInitProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(authRepositoryProvider);

  await repo.init();

  final logged = await repo.isLoggedIn();
  ref.read(isLoggedInProvider.notifier).setLoggedIn(logged);

  if (logged) {
    try {
      final me = await repo.me();              
      final isAdmin = me.rol == 'ADMIN';       
      ref.read(isAdminProvider.notifier).set(isAdmin);
    } catch (_) {
      ref.read(isAdminProvider.notifier).set(false);
    }
  } else {
    ref.read(isAdminProvider.notifier).set(false);
  }

  return logged;
});

class LoginController extends AsyncNotifier<void> {
  late final AuthRepository _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(authRepositoryProvider);
  }

Future<bool> login(String email, String pass) async {
    try {
      state = const AsyncLoading();
      await _repo.login(email, pass);

      ref.read(isLoggedInProvider.notifier).setLoggedIn(true);

      // Obtener rol y setear admin
      final me = await _repo.me();
      ref.read(isAdminProvider.notifier).set(me.rol == 'ADMIN');

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    ref.read(isLoggedInProvider.notifier).setLoggedIn(false);
    ref.read(isAdminProvider.notifier).set(false); // <-- NUEVO
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, void>(LoginController.new);
